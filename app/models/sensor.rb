
class Sensor
  include Mongoid::Document

  field :name, type: String
  field :description, type: String
  field :type, type: String, :default=>"Float"
  field :unit, type: String, :default=>""
  field :is_saved, type: Boolean, :default=>true

  # Last value, used manyly when feed is notsaved
  field :last_measure, type:Hash 

  belongs_to :device
  has_many :measures # only is is_saved==true
  has_and_belongs_to_many :elements
  belongs_to :user
  before_destroy :delete_measures

  index({ devices: 1 },{background: true})

  Pusher.url = "http://#{PUSHER_KEY}:#{PUSHER_SECRET}@api.pusherapp.com/apps/#{PUSHER_APP}"
  
  def Sensor.find_by_name_or_create name,device
    sensor=Sensor.where(:name=>name).first
    if sensor==nil
      puts "Creating sensor:#{name}"
      sensor=Sensor.new(:name=>name)
      sensor.device=device
      sensor.user=device.user
      sensor.save
    else
      puts "sensor found"
    end
    sensor
  end
  def Sensor.sensor_types
    %w(Float Int Boolean String Position)
  end
  def Sensor.check_and_update sensors
=begin
    puts "in check and pudate"
    sensors.each{|s| s.publish}
    dashboards={}
    puts "after sensors Size:#{sensors.size}"
    puts "Sensor:#{sensors}"
    sensors.each do |sensor|
      sensor.actions.where(:_type=>Widget).each do |widget|
        puts "Widget #{widget.name} in dashboard:#{widget.dashboard.name}"
        to_send={:_id=>widget.id,:data=>widget.sensor.last_measure.as_json}
        dashboards[widget.dashboard]=(dashboards[widget.dashboard]||[])+[to_send]
      end
    end

    puts dashboards
    dashboards.each do |dashboard,widgets|
      publish_on dashboard,widgets 
    end
=end

    
  end
  def publish(force_publish=false)
    if self[:active_channel]==true ||force_publish
      puts "Published:#{self.name} #{self.last_measure}"
      Pusher["sensor-#{self.id}"].trigger('update', self.last_measure.to_json)
    else
      puts "Channel:#{self.name} inactive"
    end
  end

  def Sensor.publish_on dashboard,content

    if dashboard.active_channel?
      puts "Published:#{dashboard.name} #{content}"
      Pusher["dashboard-#{dashboard.id}"].trigger('update', content)
    else
      puts "Channel:#{dashboard.name} inactive"
    end
  end



#  def last_measure
#  	self.measures.desc(:timeStamp).first||Measure.new(:value=>"N/A")
#  end
  def device=in_device
  	self[:device_id]=in_device.id
  	self.user=in_device.user
  end
  def delete_measures
    self.measures.delete_all
  end
  def publish_update m
    publish
    dashboards={}
    self.elements.where(:_type=>Widget).each do |widget|
        puts "Widget #{widget.name} in dashboard:#{widget.dashboard.name}"
        to_send={:_id=>widget.id,:data=>m.as_json}
        dashboards[widget.dashboard]=(dashboards[widget.dashboard]||[])+[to_send]
    end
    dashboards.each do |dashboard,widgets|
      Sensor.publish_on dashboard,widgets 
    end

  end

  def last_measure
    res= self[:last_measure]
    if res==nil
      res={:value=>"N/A",:timeStamp=>Time.now}
   end
    return Measure.new(:sensor   =>self,
                       :value    =>res["value"],
                       :timeStamp=>res["timeStamp"])
  end
  def add_measure value,timeStamp=Time.now
    m=Measure.new(:sensor=>self,:value=>value,:timeStamp=>timeStamp)
    puts m
    if is_saved
  	   m.save
    end
    self.set(:last_measure,{"timeStamp"=>m.timeStamp,"value"=>m.value})
    publish_update m
    # Update all elemet execpt those which are output
    elements.each do |t| 
      if !t.output_feed.include?(self)
        t.measure_added self,m
      end
    end
    return m
  end



end
