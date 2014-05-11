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
  index({ devices: 1 },{background: true})

  def last_measure
  	self.measures.last
  end
end
