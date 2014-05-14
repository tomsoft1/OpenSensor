class Measure
  include Mongoid::Document
  field :timeStamp, type: Time
  field :value ,type:Object

  belongs_to :sensor
  index({ sensor: 1 },{background: true})
end
