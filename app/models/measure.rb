class Measure
  include Mongoid::Document
  field :timeStamp, type: Time, default: Time.now
  field :value ,type:Float

  belongs_to :feed

    index({ feed: 1 },{background: true})
end
