require 'rubygems'
require 'mqtt'
require './config/environment'

Pusher.url = "http://#{PUSHER_KEY}:#{PUSHER_SECRET}@api.pusherapp.com/apps/#{PUSHER_APP}"

# Publish example
#MQTT::Client.connect('localhost') do |c|
#  c.publish('sensors/temperature', 'message')
#end

def publish_on dashboard,content

	if dashboard.active_channel?
		Pusher["dashboard-#{dashboard.id}"].trigger('update', content)
	else
		puts "Channel:#{dashboard.name} inactive"
	end
end


puts "Starting...."
MQTT::Client.connect('localhost') do |c|
	# If you pass a block to the get method, then it will loop
	c.get('device/#') do |topic,message|
		begin
			puts "#{topic}: #{message}"
			split=topic.split('/')

			d=Device.find split[1]
			puts d.name
			sensor=Sensor.where(:device=>d,:name=>split[3]).first
			if sensor
				puts "Sensor found"
			else
				puts "Sensor notfound #{split[3]}"
			end
			if sensor
				m=sensor.add_measure message

				sensor.user.dashboards.each do |dashboard|
					widgets=[]
					dashboard.widgets.each do |widget|
						if widget.sensor==sensor
							widgets<<{:_id=>widget.id,:data=>widget.sensor.last_measure.as_json}
						end
					end
					puts "Pbulishing on #{dashboard.id} #{widgets}"
					publish_on dashboard,widgets unless widgets.size==0
				end
			end
		rescue Exception => e 
			puts e
		end
	end
end
