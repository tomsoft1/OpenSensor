require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra'
require "sinatra/reloader" if development?
require 'mongoid'
require 'pusher'
require ::File.dirname(__FILE__) + '/config/environment'

Pusher.url = "http://#{PUSHER_KEY}:#{PUSHER_SECRET}@api.pusherapp.com/apps/#{PUSHER_APP}"

class OpenSensorApi < Sinatra::Base

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


	get "/sensor/:sensor_id" do
		sensor=Sensors.find params["sensor_id"]
		return sensor.to_json
		#	return params
	end

	post "/sensor/:sensor_id" do
		sensor=Sensors.find params["sensor_id"]
		puts params
		newMeasure=JSON.parse request.body.read
		measure=Measure.new(newMeasure)
		measure.sensor=sensor
		measure.save
		{:code=>1}.to_json
	end

	get "/device/:device_id" do
		device=Device.find params["device_id"]
		res=device.as_json
		res[:sensors]=device.sensors.as_json
		res.to_json
	end

	#
	#
	post "/device/:device_id" do
		errors=[]
		device=Device.find params["device_id"]
		sensors=[]
		newMeasure=JSON.parse request.body.read
		newMeasure.each do |sensor_data|
			begin
				if sensor_data['sensor_id']
					sensor=Sensor.find(sensor_data["sensor_id"])
				else
					sensor=Sensor.where(:name=>sensor_data["name"]).first
					if sensor==nil
						puts "Creating sensor:#{sensor_data['name']}"
						sensor=Sensor.new(:name=>sensor_data["name"])
						sensor.device=device
						sensor.save
					else
						puts "sensor found"
					end
				end
			rescue Exception =>e
				puts e
				sensor=nil
				errors<<e.to_s
			end
			if sensor
				measure=Measure.new(:value=>sensor_data["value"].to_f)
				if sensor_data["timestamp"] then measure.timeStamp=Time.at sensor_data["timestamp"] end
				measure.sensor=sensor
				measure.save
				sensors<<sensor
			end
		end
		res={}
		@current_user.dashboards.each do |dashboard|
			widgets=[]
			dashboard.widgets.each do |widget|
				if sensors.include? widget.sensor
					widgets<<{:_id=>widget.id,:data=>widget.sensor.last_measure.as_json}
				end
			end
			publish_on dashboard,widgets unless widgets.size==0

		end
		if errors.size>0 then res[:errors]=errors.join(',') 
		else
			res[:msg]="Updated #{sensors.count}"
		end
		res.to_json
	end

	def publish_on dashboard,content

		if dashboard.active_channel?
			Pusher["dashboard-#{dashboard.id}"].trigger('update', content)
		else
			puts "Channel:#{dashboard.name} inactive"
		end
	end

end

#OpenSensoreApi.run!
