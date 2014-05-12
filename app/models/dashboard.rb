class Dashboard
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :active_channel, type:Boolean ,:default=>false
  belongs_to :user
  has_many :widgets
end
