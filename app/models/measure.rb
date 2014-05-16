class Measure
  include Mongoid::Document
  field :timeStamp, type: Time
  field :value ,type:Object

  belongs_to :sensor
  index({ sensor: 1 },{background: true})

   def to_simple_json
    {:timeStamp=>timeStamp.to_i*1000,:value=>value}
  end

end
