require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra'
require "sinatra/jsonp"
require "sinatra/reloader" #if development?
require 'mongoid'
require 'pusher'
require ::File.dirname(__FILE__) + '/config/environment'

Pusher.url = "http://#{PUSHER_KEY}:#{PUSHER_SECRET}@api.pusherapp.com/apps/#{PUSHER_APP}"

class OpenSensorApi < Sinatra::Base
	helpers Sinatra::Jsonp

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
		api_key=request.env["HTTP_X_APIKEY"]||params["api_key"]
		if api_key
			u=User.where(:api_key=>api_key).first
			@current_user=u
		end
		return u!=nil
	end


	get "/sensor/:sensor_id" do
		sensor=Sensor.find params["sensor_id"]
		res=sensor.as_json
		res[:measures_count]=sensor.measures.count
		res.to_json
	end

	get "/sensor" do
		@current_user.sensors.as_json
	end
	post "/sensor/:sensor_id" do
		sensor=Sensor.find params["sensor_id"]
		puts sensor
		newMeasure=JSON.parse request.body.read
		measure=Measure.new(newMeasure)
		measure.sensor=sensor
		measure.save
		{:code=>1}.to_json
	end

	def conv_time in_time
		times=in_time.split('_')
		if time==3
			return Time.utc(times[2].to_i,times[1].to_i,times[0].to_i)
		elsif times.size==5
			return Time.utc(times[2].to_i,times[1].to_i,times[0].to_i,times[3].to_i,times[4].to_i)
		end

	end

	get "/sensor/:sensor_id/measures" do
		begin
			sensor=Sensor.find params["sensor_id"]
			limit=params[:numbers]||100_000
		    page=params[:page]||0
		    criteria=sensor.measures.asc(:timeStamp).skip(limit*page).limit(limit)
		    if(params[:startTime])then criteria=criteria.where(:timeStamp.gte=>conv_time(params[:timeStamp])) end
		    if(params[:endTime])then criteria=criteria.where(:timeStamp.lt=>conv_time(params[:endTime])) end
			puts sensor
			jsonp criteria.map{|m|[m.timeStamp.to_i*1000,m.value]}
		rescue Exception=>e
		   {:error=>e.to_s}
		end
	end
	get "/devices" do
		devices=@current_user.devices
		devices.to_json
	end

	get "/device/:device_id" do
		device=Device.find params["device_id"]
		res=device.as_json
		res[:sensors]=device.sensors.as_json
		res.to_json
	end

	post "/device/:device_id/sigfox" do
		begin
			device=Device.find params["device_id"]
			f=File.open("log/areku.log","a+");
			f.write(params.to_json)
			f.close
		rescue Excepion => e
			{:ok =>e.to_s}.to_json
		end
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
						sensor.user=device.user
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
				if sensor_data["data"]  then sensor_data=sensor_data["data"] else sensor_data=[sensor_data] end
				puts sensor_data
				sensor_data.each do |data|
					puts"data:#{data}"
					measure=sensor.add_measure(data["value"],data["time_stamp"]||Time.now )
				end
				publish_on_sensor sensor
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

	def publish_on_sensor sensor
		if sensor[:active_channel]==true
			puts "Published:#{sensor.name} #{sensor.last_measure}"
			Pusher["sensor-#{sensor.id}"].trigger('update', sensor.last_measure.to_simple_json)
		else
			puts "Channel:#{sensor.name} inactive"
		end
	end
	def publish_on dashboard,content

		if dashboard.active_channel?
			puts "Published:#{dashboard.name} #{content}"
			Pusher["dashboard-#{dashboard.id}"].trigger('update', content)
		else
			puts "Channel:#{dashboard.name} inactive"
		end
	end

end


