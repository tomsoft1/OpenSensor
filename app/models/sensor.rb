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
    triggers.each{|t| t.check_trigger}
  end
end
