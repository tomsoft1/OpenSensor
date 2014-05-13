class Device
  include Mongoid::Document

  field :name, type: String
  field :description, type: String

  validates_presence_of :name
  belongs_to :user
  has_many :sensors
end
