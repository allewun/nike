
require 'twitter'
require 'open-uri'
require './lib/OCR.rb'
require 'pp'

NIKE_ACCT = ['NikeLA', 'NikeSantaMonica']
TWEETS_WITH_IMAGES = [345683429796487168,
                      345344666348171265,
                      345302373763280898]

class Nike
  def initialize

    # setup credentials
    Twitter.configure do |config|
      config.consumer_key       = '5HNcoVBGgt01mjdrRLLpw'
      config.consumer_secret    = 'zk0gCA0oFN7rYrZGCHbr01yR9pK2M82cjeeHKug'
      config.oauth_token        = '1530046740-vMzPHDsVOB6FbWE4Z5hOuRTqgIzi66GA3acruEj'
      config.oauth_token_secret = 'cUJ0MOM8iKd8mn4DSVGxVZ2fwyS4l0Y5jZfk4B1sbA'
    end
  end

  def ocr_tweet(tweet)
    if tweet_contains_image? tweet
      url   = get_url(tweet)
      image = get_image(url)

      ocr = OCR.new(image.filename)
      ocr.get_hashtag
    else
      nil
    end
  end

  def test
    puts "Starting test..."
    start = Time.now

    (1..3).each do |i|
      ocr = OCR.new("original#{i}.jpg")
      puts "  " + ocr.get_hashtag
    end

    puts "Time elapsed: #{Time.now-start}"
  end

  def loop(time=10)
    loop do
      yield
      sleep(time)
    end
  end

  def run
    NIKE_ACCT.each do |acct|
      puts "#{acct}:"
      Twitter.user_timeline(acct, {:count => 200}).each do |t|
        if tweet_contains_image?(t)
          puts "  #{ocr_tweet(t)} <= #{get_url(t)}"
        end
      end
    end
  end

  def tweet_contains_image?(tweet)
    text = tweet[:text].downcase
    text.include?('#rsvp') && text.include?('hashtag') && text.include?('circle')
  end

  def get_url(tweet)
    tweet.media[0].media_url
  end

  def get_image(url)
    filename = url.gsub(/^.*\/([\w-]+\.jpg)$/, '\1')

    File.open("#{$DIR}#{filename}", 'wb') do |f|
      f.write open(url).read
    end

    Image.read("#{$DIR}#{filename}")[0]
  end

end








# # get latest tweet
# last_tweet = Twitter.user_timeline(NIKE_ACCT, {:count => 1})[0]

# # get good tweet
# good_tweet1 = Twitter.status(TWEETS_WITH_IMAGES[0])
# good_tweet2 = Twitter.status(TWEETS_WITH_IMAGES[1])
# good_tweet3 = Twitter.status(TWEETS_WITH_IMAGES[2])

# pp last_tweet
# pp good_tweet3