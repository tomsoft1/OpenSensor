class Feed
  include Mongoid::Document
#  field :uid, type: String
  field :name, type: String
  field :description, type: String
  field :type, type: String ,:default=>"Float"
  field :unit, type:String  ,:default=>""
  belongs_to :device
  has_many :measures
  belongs_to :user
  has_many :feed
  index({ devices: 1 },{background: true})

  def last_measure
  	self.measures.last
  end
  def device=in_device
  	self[:device_id]=in_device.id
  	self.user=in_device.user
  end

  def add_measure value
  	m=Measure.new(:feed=>self,:value=>value)
  	puts m
  	m.save
  end
end
