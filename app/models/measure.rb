class Measure
  include Mongoid::Document
  field :timeStamp, type: Time, default: Time.now
  field :value ,type:Float

  belongs_to :sensor

    index({ sensor: 1 },{background: true})
end
