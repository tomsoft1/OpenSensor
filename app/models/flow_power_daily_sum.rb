

class FlowPowerDailySum < Flow
  field :daily_total, type: Float ,:default=>0
  field :last_update, type: Time

  after_create :get_output_feed

	def get_output_feed
		if !output_feed.first
			puts "Creating feed"
			feed=Sensor.new(:name=>"#{name}_daily_sum",:type=>"Float",:user=>sensor.user)
			output_feed<<feed
			self.save
			feed.save

      # Check if we need to compute previous days
      sensor.measures.asc(:timeStamp).first.timeStamp.to_date.upto(Date.yesterday) do |date|
        computeDailySum date
      end
		end
		output_feed.first
	end

  def measure_added sensor,measure
    # check previous measure
    puts" Measure added, computing sum#{measure.inspect}"
    if self.last_update!=nil && self.last_update.to_date!=Date.today
      # puts new day
      puts "New dy, computing daily stats"
      computeDailySum Date.yesterday
      self.daily_total=0
    end
    puts "Current total:#{daily_total}"
    self.daily_total+=measure.value
    self.last_update=measure.timeStamp
    self.save
  end

	def computeDailySum in_date
		if get_output_feed.measures.where(:timeStamp=>(in_date+1).to_time).count==0
			sum=(Measure.computeArea sensor.measures,in_date.to_time,(in_date+1).to_time)/1000
			output_feed.first.add_measure(sum,(in_date+1).to_time)
		else
			puts "Alredady here"
		end
	end

end

