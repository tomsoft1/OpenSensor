class Trigger
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :limit, type: Float
  field :operator, type: String
end
