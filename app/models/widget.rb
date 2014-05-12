class Widget
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :input, type: String

  belongs_to :dashboard
  belongs_to :feed
end
