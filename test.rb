require './OCR.rb'

start = Time.now


(1..7).each do |i|
  ocr = OCR.new("original#{i}.jpg")
  p ocr.get_hashtag
end

fin = Time.now

p "Time elapsed = #{fin-start}"