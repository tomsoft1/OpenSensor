class TriggerEvent
  include Mongoid::Document
  field :time_stamp, type: Time,:default=>Time.now
  field :log, type: String, :default=>""
  field :processed, type: Boolean,:default=>false
  field :error, type:Boolean,:default=>false
  belongs_to :trigger
  belongs_to :measure
  index({ trigger: 1 }, { background: true })
  index({ processed: 1 }, { sparse: true, background: true })
  index({ time_stamp:1,processed: 1 }, {  background: true })
end
