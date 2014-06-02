class Measure
  include Mongoid::Document
  field :timeStamp, type: Time
  field :value ,type:Object

  belongs_to :sensor
  index({ sensor: 1 },{background: true})
  index({ sensor:  1,timeStamp: 1 })

   def to_simple_json
    {:timeStamp=>timeStamp.to_i*1000,:value=>value}
  end

  def Measure.computeArea measures,startTime,endTime
  	lastTime=startTime.to_time
  	# Get the previous mesure
  	lastMesure=measures.where(:timeStamp.lt=>startTime).desc(:timeStamp).first
  	#	puts lastMesure

  	#	delta=lastMesure.timeStamp-lastTime
  	#	puts "#{delta}"
  	total=0
  	measures.where(:timeStamp.gte=>startTime,:timeStamp.lt=>endTime).each do |m|
  		delta=m.timeStamp-lastTime
  		total+=m.value*delta/3600.0
  		#puts "Delta:#{delta} Watt:#{m.value} Total:#{total}"
  		lastTime=m.timeStamp
  	end
  	total

  end
end
