class Widget
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :input, type: String

  belongs_to :dashboard
  belongs_to :sensor
  belongs_to :element_prototype

  def self.find_prototype name
  	ElementPrototype.where(:name=>name).first
  end
end
