class TwitterCredential
  include Mongoid::Document
  field :screen_name, type: String
  field :user_id  , type:String
  field :token_access, type: String
  field :token_secret, type: String

  def client
  	  Twitter::REST::Client.new do |config|
  		config.consumer_key        =  TWITTER_CONSUMER_KEY
  		config.consumer_secret     =  TWITTER_CONSUMER_SECRET
  		config.access_token        =  self.token_access
  		config.access_token_secret =  self.token_secret
	end
  end

  def update message
	self.client.update(message)
  end
  def send_dm user,message
	self.client.create_direct_message(user,message)
  end
end
