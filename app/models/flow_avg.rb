

class FlowAvg < Flow
  field :last_update, type: Time
  field :every , type:Integer ,:default=>5.minutes
  after_create :get_output_feed

	def get_output_feed
		if !output_feed.first
			puts "Creating feed"
			feed = Sensor.new(:name=>"#{name}_avg",:type=>"Float",:user=>sensor.user,:is_saved=>false)
			output_feed<<feed
			self.save
			feed.save

		end
		output_feed.first
	end

  def measure_added sensor,measure
    # check previous measure
    puts "computeAvg"
    if self.last_update==nil || Time.now-self.last_update>self.every
      get_output_feed.add_measure computeAvg,measure.timeStamp
      self.set(:last_update,measure.timeStamp)
    end
  end

	def computeAvg range=30.minutes
    total = 0
    count = 0
    lastVal = Time.now-range
    sensor.measures.where(:timeStamp.gte=>lastVal).asc(:timeStamp).each do |m|
      total+=m.value*(m.timeStamp-lastVal)
      lastVal = m.timeStamp
      puts "#{m.inspect} #{count} #{total} #{total/(lastVal-(Time.now-range))}"
      count+=1
    end
    puts "Avg:#{total/range} elemnt:#{count} range:#{range}"
    if count!=0
      total/range
    else
      0
    end
	end

end

