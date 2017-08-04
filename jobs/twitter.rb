require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom

#Change these to bdp-access keys
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = "pTiKY8JlS9VCb3R77a0DtmtDu"
  config.consumer_secret = "aCMoyVHax6xHmDsHhg2Z1osDyoAdBqO9q0T2F0v9G3VvcKXLsJ"
  config.access_token = "4895381980-Oy5e11WQbpoJsPEhOSlSRDi2xuFQ3gPdtcxIKW3"
  config.access_token_secret = "E96EgxyhwUxfCbKOHxCpOUvUWQzC7Ax6pFYoldoBV4BKP"
end

search_term = URI::encode('#Data -filter:retweets :)')
SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}", {result_type: "popular"})

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
