class Sensor
  include Mongoid::Document

  field :name, type: String
  field :description, type: String
  field :type, type: String, :default=>"Float"
  field :unit, type: String, :default=>""

  belongs_to :device
  has_many :measures
  has_many :triggers
  belongs_to :user
  before_destroy :delete_measures

  index({ devices: 1 },{background: true})

  def Sensor.find_by_name_or_create name,device
    sensor=Sensor.where(:name=>name).first
    if sensor==nil
      puts "Creating sensor:#{name}"
      sensor=Sensor.new(:name=>name)
      sensor.device=device
      sensor.user=device.user
      sensor.save
    else
      puts "sensor found"
    end
    sensor
  end
  def Sensor.sensor_types
    %w(Float Int Boolean String Position)
  end
  def last_measure
  	self.measures.last||Measure.new(:value=>"N/A")
  end
  def device=in_device
  	self[:device_id]=in_device.id
  	self.user=in_device.user
  end
  def delete_measures
    self.measures.delete_all
  end
  def add_measure value,timeStamp=Time.now
  	m=Measure.new(:sensor=>self,:value=>value,:timeStamp=>timeStamp)
  	puts m
  	m.save
    triggers.each{|t| t.check_trigger m}
    m
  end
end
