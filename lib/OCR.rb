# encoding: utf-8

require 'tesseract'
require 'RMagick'

include Magick

THRESHOLD = 21000
THRESHOLD_DIRTY = 21700 # for the dirty region (top ~280-330px)

LINE_THRESH  = 40
START_THRESH = 20
CURVATURE    = 5

SHOE_X_MIN = 50
SHOE_X_MAX = 300
SHOE_Y_MIN = 180
SHOE_Y_MAX = 290

DIRTY_Y_MIN = 280
DIRTY_Y_MAX = 330

class OCR

  def initialize(file)
    @ocr = Tesseract::Engine.new do |e|
      e.language  = :eng
      e.blacklist = '\'"|,.:;/?<>!@\\$%^&*()[]{}`~‘¥§-_=+£1234567890’'
    end

    @original  = Image.read(file)[0]
    @processed = @original.sharpen.threshold(THRESHOLD)
    @mask      = OCR.increase_contrast(file).transparent('white').opaque_channel('black', 'white')
    @composed  = @processed.composite(@mask, 0, 0, AtopCompositeOp)

    @width  = @original.columns
    @height = @original.rows

  end

  def self.increase_contrast(infile)
    name    = infile.gsub(/\.(png|gif|jpg)+$/, '')
    ext     = infile.gsub(/^[^.]*\./, '')
    outfile = "#{name}_contrast.#{ext}"

    `./2colorthresh #{infile} #{outfile}`

    contrast = Image.read(outfile)[0]
    `rm #{outfile}`

    contrast
  end

  def get_hashtag
    t,b,l,r = find_line_pair(get_line_data)

    cropped = @original.crop(l, t, r-l, b-t)

    if t.between?(DIRTY_Y_MIN, DIRTY_Y_MAX)
      cropped = cropped.threshold(THRESHOLD_DIRTY)
    end

    @ocr.text_for(cropped).strip.upcase
  end

  private

  def get_line_data
    size = start = 0
    max_size = max_start = 0

    line_data = []

    # find horizontal lines
    @composed.each_pixel do |px,c,r|

      # ignore central shoe
      if !(r.between?(SHOE_Y_MIN, SHOE_Y_MAX))

        # start of a new row
        if c == 0
          size = start = 0
          max_size = max_start = 0
        end

        # end of row
        if c == @width-1
          line_data.push({:row => r, :start => max_start, :size => max_size})
          next
        end

        # black pixel
        if px.to_color == 'black'

          # first black segment
          if size == 0
            start = c
          end

          # increment length of line
          size = size + 1

          # find largest black line of row
          if size > max_size
            max_size = size
            max_start = start
          end

        # reset line after running into white
        else
          size = start = 0
        end
      end
    end

    line_data
  end

  def find_line_pair(data)

    data.sort_by! { |h| h[:size] }.reverse!

    for i in 0..(data.size-1) do
      for j in (i+1)..(data.size-1) do

        if (((data[i][:size] - data[j][:size]).abs <= LINE_THRESH && (data[i][:start] - data[j][:start]).abs <= START_THRESH) ||
             (data[i][:row] - data[j][:row]).abs.between?(40,50))

          top    = [data[i][:row],   data[j][:row]].min + 4
          bottom = [data[i][:row],   data[j][:row]].max - 2
          left   = [data[i][:start], data[j][:start]].min - 6
          right  = [data[i][:start], data[j][:start]].max + data[i][:size] - 6

          return [top, bottom, left, right]
        end
      end
    end
  end

end
