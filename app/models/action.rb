# Action is base class for action on feed/sensors
# typically:
# trigger, widget
#
# An action can have several sensors as input, and produce output
#
# TODO: remove trick with sensor_id/sensor and keep only sensors, initially there was a 1-N connection
#
class Action
  include Mongoid::Document
  field :name, type: String
  field :type, type: String

  
  belongs_to :user
  belongs_to :element_prototype
  # Input feeds
  has_and_belongs_to_many :sensors
  # Output feeds
  has_and_belongs_to_many :output_feed, class_name: "Sensor", inverse_of: nil


  def self.find_prototype name
  	ElementPrototype.where(:name=>name).first
  end

  
public

  def sensor
  	if sensors.first
  		sensors.first
  	elsif self[:sensor_id]
  		sensors<<Sensor.find(self[:sensor_id])
  		self.save
  		sensors.first
  	end

  end
  def sensor=(in_sensor)
  	puts "Assingment #{in_sensor.name}"
  	self.sensors=[in_sensor]
  end
  def sensor_id
  	if sensors.size>0
  		sensors.first.id
  	else
  		nil
  	end
  end
   def sensor_id=(in_sensor_id)
   	puts "setting sensor_id"
   	self.sensor=Sensor.find(in_sensor_id)
  end
  def get_prototype
  	res=self.element_prototype
  	if res==nil then res=Action.find_prototype(type) end
  	res
  end

  def ensure_params
  	proto=get_prototype
  	if proto
  		proto.parameter_def.each do |p|
  			self[p.name_param.to_sym]="" unless self[p.name_param.to_sym]
  		end
  	end
  end
end


class ActionPowerDailySum < Action

	def get_output_feed
		if output_feed.firt
			puts "Creating feed"
			feed=Sensor.new(:name=>"#{name}_daily_sum",:type=>"Float",:user=>sensor.user)
			output_feed<<feed
			self.save
			feed.save
		end
		output_feed.first
	end

	def computeDailySum in_date
		if get_output_feed.measures.where(:timeStamp=>(in_date+1).to_time).count==0
			sum=(Measure.computeArea sensor.measures,in_date.to_time,in_date.to_time)/1000
			output_feed.add_measure(sum,(in_date+1).to_time)
		else
			puts "Alredady here"
		end
	end

end