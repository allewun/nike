
require 'twitter'
require 'open-uri'

NIKE_ACCT = 'NikeLA'
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
    ocr = OCR.new()

  end
end


def tweet_contains_image?(tweet)
  text = tweet[:text].downcase
  text.include?('#rsvp') && text.include?('hashtag') && text.include?('circle')
end

def get_image(url)
  open(url) do |f|
    File.open()
  end
end





# get latest tweet
last_tweet = Twitter.user_timeline(NIKE_ACCT, {:count => 1})[0]

# get good tweet
good_tweet1 = Twitter.status(TWEETS_WITH_IMAGES[0])
good_tweet2 = Twitter.status(TWEETS_WITH_IMAGES[1])
good_tweet3 = Twitter.status(TWEETS_WITH_IMAGES[2])

pp last_tweet
pp good_tweet3