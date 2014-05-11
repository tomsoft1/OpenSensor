class Device
  include Mongoid::Document
  field :uid, type: String
  field :name, type: String
  field :description, type: String

  validates_presence_of :name
  belongs_to :user
  has_many :feeds
end
