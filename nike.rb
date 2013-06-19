#!/usr/bin/env ruby

require 'twitter'
require 'pp'
require 'open-uri'
require 'tesseract'
require 'RMagick'

include Magick

ocr = Tesseract::Engine.new {|e|
  e.language  = :eng
  e.blacklist = '|'
}

img = Image.read('full.jpg')[0]

start = Time.now

img.each_pixel do |px,c,r|
  if r.even?
    px.to_color
  end
end

p Time.now - start

p ocr.text_for('hashtag.png').strip



# def tweet_contains_image?(tweet)
#   text = tweet[:text].downcase
#   text.include?('#rsvp') && text.include?('hashtag') && text.include?('circle')
# end

# def get_image(url)
#   open(url) do |f|
#     File.open()
#   end
# end

# NIKE_ACCT = 'NikeLA'
# TWEETS_WITH_IMAGES = [345683429796487168,
#                       345344666348171265,
#                       345302373763280898]

# # setup credentials
# Twitter.configure do |config|
#   config.consumer_key       = '5HNcoVBGgt01mjdrRLLpw'
#   config.consumer_secret    = 'zk0gCA0oFN7rYrZGCHbr01yR9pK2M82cjeeHKug'
#   config.oauth_token        = '1530046740-vMzPHDsVOB6FbWE4Z5hOuRTqgIzi66GA3acruEj'
#   config.oauth_token_secret = 'cUJ0MOM8iKd8mn4DSVGxVZ2fwyS4l0Y5jZfk4B1sbA'
# end


# # get latest tweet
# last_tweet = Twitter.user_timeline(NIKE_ACCT, {:count => 1})[0]

# # get good tweet
# good_tweet1 = Twitter.status(TWEETS_WITH_IMAGES[0])
# good_tweet2 = Twitter.status(TWEETS_WITH_IMAGES[1])
# good_tweet3 = Twitter.status(TWEETS_WITH_IMAGES[2])

# pp last_tweet
# pp good_tweet3