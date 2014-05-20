require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra'
require "sinatra/jsonp"
require "sinatra/reloader" #if development?
require 'mongoid'
require 'pusher'
load "app/lib/sigfox_tools.rb"
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

	post "/device/sigfox" do
		if params[:device]
			device=Device.where(:sigfox_device_id=>params[:device]).first
			if device
				device.parse_binary_data params
				{:done=>"ok"}.to_json
			else
				halt 302,{:error=>"Device not found"}.to_json
			end
		else
		end
	end

	post "/device/:device_id/binary" do
		begin
			sensors=[]
			device=Device.find params["device_id"]
			device.parse_binary_data params
			{:done=>"ok"}.to_json
		rescue Exception => e
			puts "ERROR:#{e.to_s}"
			{:error =>e.to_s}.to_json
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
					sensor=Sensor.find(sensor_data["sensor_id"],:device=>device)
				else
					sensor=Sensor.find_by_name_or_create sensor_data["name"],device
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
				sensors<<sensor
			end
		end
		res={}
		Sensor.check_and_update sensors
		if errors.size>0 then res[:errors]=errors.join(',')
		else
			res[:msg]="Updated #{sensors.count}"
		end
		res.to_json
	end


end


