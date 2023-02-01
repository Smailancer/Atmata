class TweetsController < ApplicationController
  # Show all tweets
  def index
    @tweets = Tweet.all
  end

  # Show a specific tweet
  def show
    @tweet = Tweet.find(params[:id])
  end

  # Render a form to create a new tweet
  def new
    @tweet = Tweet.new
  end

  # Create a new tweet
  def create
    @tweet = Tweet.new(tweet_params)
    if @tweet.save
      redirect_to @tweet, notice: "Tweet was successfully created."
    else
      render :new
    end
  end

  # Render a form to edit an existing tweet
  def edit
    @tweet = Tweet.find(params[:id])
  end

  # Update an existing tweet
  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update(tweet_params)
      redirect_to @tweet, notice: "Tweet was successfully updated."
    else
      render :edit
    end
  end

  # Delete an existing tweet
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to tweets_url, notice: "Tweet was successfully deleted."
  end


  #####################################################


  def retrieve_tweets
    require "httparty"
  
    # Set the username of the account you want to retrieve tweets from
    username = "eyaaaad"
  
    # Set the number of tweets you want to retrieve
    count = 15
  
    # Set the query parameters for the request
    query = {
      query: "from:#{username} -filter:retweets -filter:quotes",
      max_results: count,
      tweet: {
        fields: "text,created_at,entities"
      },
      user: {
        fields: "username"
      }
    }
  
    # Set the authorization headers for the request
    headers = {
      "Authorization" => "Bearer AAAAAAAAAAAAAAAAAAAAAAEhGjQEAAAAAnLzymoztLvSgqmlwSoB6WL8eqGs%253DqiKLE1Jo8xTHNbGlA0Ju5f25kHQxNGQ8budPI7atHwSi4yy3Bc"
    }
  
    # Send the GET request to the Twitter API
    response = HTTParty.get("https://api.twitter.com/2/tweets/search/recent", query: query, headers: headers)
    puts 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
    puts response
    binding.pry
    # Save the tweets to the database
    response["data"].each do |tweet|
      # Check if the tweet is a retweet
      if tweet["text"].include?("#") || tweet["text"].include?("@")
        # Skip the tweet
        next
      end
  
      # Save the tweet to the database
      db_tweet = Tweet.create(
        user_id: current_user.id,
        text: tweet["text"],
        tweeted_at: tweet["created_at"]
      )
  
      # If the tweet has media, save the media to the database
      if tweet["entities"].has_key?("media")
        tweet["entities"]["media"].each do |medium|
          db_tweet.update(
            media_url: medium["media_url"],
            type: medium["type"]
          )
        end
      end
    end
  end
  
  
  
  private

  # Permit only the text and media_url parameters to be passed through the form
  def tweet_params
    params.require(:tweet).permit(:text, :media_url,:type,:tweeted_at)
  end
end
