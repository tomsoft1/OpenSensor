require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra'
require "sinatra/reloader" if development?
require 'mongoid'
require 'pusher'
require ::File.dirname(__FILE__) + '/config/environment'

Pusher.url = "http://#{PUSHER_KEY}:#{PUSHER_SECRET}@api.pusherapp.com/apps/#{PUSHER_APP}"


configure do
  Mongoid.load!("config/mongoid.yml")
end

get '/' do
	  "Please read  the doc"
end


  before do
    protected! #if request.path =~ %r{\A/api}
  end

  before do
    case request.path[0, 4]
    when "/api"
      cache_control :private, max_age: 86400 # 24 hours
    when "/doc"
      cache_control :public, max_age: 86400
    else
      cache_control :no_store
    end
  end

  def protected!
    return if authorized?
    halt 401, {"Error"=>"Not authorized"}
  end

  def authorized?
  	puts request.env
  	if request.env["HTTP_X_APIKEY"]
	  	u=User.where(:api_key=>request.env["HTTP_X_APIKEY"]).first
  		@current_user=u
  	end
  	return u!=nil
   end


get "/feed/:feed_id" do 
	feed=Feed.find params["feed_id"]
	return feed.to_json
#	return params
end

post "/feed/:feed_id" do 
	feed=Feed.find params["feed_id"]
	puts params
	newMeasure=JSON.parse request.body.read
	measure=Measure.new(newMeasure)
	measure.feed=feed
	measure.save
	{:code=>1}.to_json
end

get "/device/:device_id" do 
	device=Device.find params["device_id"]
	res=device.as_json
	res[:feeds]=device.feeds.as_json
	res.to_json
end

#
#
post "/device/:device_id" do 
	errors=[]
	device=Device.find params["device_id"]
	feeds=[]
	newMeasure=JSON.parse request.body.read
	newMeasure.each do |feed_data|
		begin
			if feed_data['feed_id']
				feed=Feed.find(feed_data["feed_id"])
			else
				feed=Feed.where(:name=>feed_data["name"]).first
				if feed==nil
					puts "Creating feed:#{feed_data['name']}"
					feed=Feed.new(:name=>feed_data["name"])
					feed.device=device
					feed.save
				else
					puts "Feed found"
				end
			end
		rescue Exception =>e
			puts e
			feed=nil
			errors<<e.to_s
		end
		if feed
			measure=Measure.new(:value=>feed_data["value"].to_f)
			if feed_data["timestamp"] then measure.timeStamp=Time.at feed_data["timestamp"] end
			measure.feed=feed
			measure.save
			feeds<<feed
		end
	end
	res={}
	@current_user.dashboards.each do |dashboard|
		widgets=[]
		dashboard.widgets.each do |widget|
			if feeds.include? widget.feed
				widgets<<{:_id=>widget.id,:data=>widget.feed.last_measure.as_json}
			end
		end
		publish_on dashboard,widgets unless widgets.size==0

	end
	if errors.size>0 then res[:errors]=errors.join(',') end
	res.to_json
end

def publish_on dashboard,content

    if dashboard.active_channel?
       Pusher["dashboard-#{dashboard.id}"].trigger('update', content)
    else
      puts "Channel:#{dashboard.name} inactive"
    end
end



