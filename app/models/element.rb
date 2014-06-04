# Element is base class for action on feed/sensors
# typically:
# trigger, widget
#
# An action can have several sensors as input, and produce output
#
# TODO: remove trick with sensor_id/sensor and keep only sensors, initially there was a 1-N connection
#
class Element
  include Mongoid::Document
  field :name, type: String
  field :type, type: String

  
  belongs_to :user
  belongs_to :element_prototype
  # Input feeds
  has_and_belongs_to_many :sensors
  # Output feeds
  has_and_belongs_to_many :output_feed, class_name: "Sensor"
  before_destroy :delete_output_feed
  def self.find_prototype name
  	ElementPrototype.where(:name=>name).first
  end

  def delete_output_feed
  	output_feed.each{|afeed| afeed.delete} 
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
  	if res==nil then res=Element.find_prototype(type) end
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

  # Callback called whena measure is added to a sensor the we follow
  def measure_added sensor,measure
  end

  def params
    proto=get_prototype
    res={}
    if proto
      proto.parameter_def.each do |p|
        res[p.name_param.to_sym]=self[p.name_param.to_sym];
      end
    end
    res
  end

  # Hook to pare some of the attributes which are part of the prototype, espcially
  #  sensors which are treated differentyl
  def update_attributes params
    puts params

    if !params then return end
    if params[:sensor_id]
      self.sensor_ids=[params[:sensor_id]]
      params.delete :sensor_id
    end
    if proto=get_prototype
      proto.parameter_def.each do |proto|
        if proto.is_a? ParameterSensor
          puts "Sensor found..."
          begin
            self.sensor_ids << params[proto.name_param.to_sym] unless params[proto.name_param.to_sym]==""
          rescue Exception => e
            puts e
          end
        end
      end
      self.save
    end
    puts self.sensors
    super params
  end
end

