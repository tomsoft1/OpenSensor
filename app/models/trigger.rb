class Trigger < Action
	field :target, type:String
	field :limit, type: Float
	field :operator, type: String
	field :target , type: String
	field :is_dm  , type: Boolean
	field :is_triggered,type:Boolean,:default=>false
	has_many :trigger_events

	index({ sensor: 1 }, {  background: true })
	def self.operators
		{"gt"=>">","lt"=>"<","eq"=>"=","outside"=>"outside"}
	end

	# should be put insome utility classes
	def distance a, b
		rad_per_deg = Math::PI/180  # PI / 180
		rkm = 6371                  # Earth radius in kilometers
		rm = rkm * 1000             # Radius in meters

		dlon_rad = (b["lon"]-a["lon"]) * rad_per_deg  # Delta, converted to rad
		dlat_rad = (b["lat"]-a["lat"]) * rad_per_deg

#		lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
#		lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

		a = Math.sin(dlat_rad/2)**2 + Math.cos(a["lat"]*rad_per_deg) * Math.cos(b["lat"]*rad_per_deg) * Math.sin(dlon_rad/2)**2
		c = 2 * Math.asin(Math.sqrt(a))

		rm * c # Delta in meters
	end

	def measure_added sensor,measure
		check_trigger measure
	end

	def check_trigger measure
		begin
			val=measure.value
			puts "Checking #{val} #{operator} #{limit}"
			cond=false
			case operator
			when "gt"
				if val>limit then cond=true end
			when "lt"
				if val<limit then cond=true end
			when "eq"
				if val==limit then cond=true end
			when "outside"
				center=JSON.parse limit
				
				if distance(center,val)>limit then cond=true end
				puts "Distance:#{distance(center,val)}"
			end
			puts "Result:#{cond}"
			if cond && !is_triggered
				evt=TriggerEvent.new(:trigger=>self,:measure=>measure,
				:log=>"Checking #{val} #{operator} #{limit} Action:#{type} on:#{target}",:timeStamp=>Time.now)
				trigger_events<<evt
				process_event evt	
			end
			self.is_triggered=cond
			self.save
		rescue Exception => e
			puts "Exception #{e}"
		end
	end

	def process_event evt
		begin
			target=self.target
			name=self.sensor.name
			device_name="unkwown"
			if self.sensor.device then device_name=self.sensor.device.name end

			case type
			when "email"
				begin
					puts "Processing email"
					mail = Mail.deliver do
						from    'opensensorcloud@gmail.com'
						cc	  target
						subject "ALERT: trigger reached on #{name}"
						body    "The trigger has been activated..."
					end
				rescue Exception => e
					puts e
					evt.log=evt.log+" #{e}"
				end
			when "twitter"
				puts "Twitter envoi"
				msg="ALERT, your #{name} on #{device_name} reached:#{evt.measure.value} (condition #{self.operator}  #{self.limit})"
				if self.is_dm
					begin
						puts "Is dm"
						cred=TwitterCredential.where(:user=>self.user,:screen_name=>"opensensorcloud").first
						res=cred.send_dm(self.target,msg)
						puts res
						evt.log+=" DM send"
					rescue Exception=> e
						puts "Error #{e}"
						evt.log+="\nERROR:#{e}"
						evt.error=true
					end
				else
					cred=TwitterCredential.where(:user=>self.user,:screen_name=>target).first
					if cred
						if cred.update msg
							evt.log+=" Tweet send..."
						end

					else
						evt.log+="\nERROR: Cannot find credential for #{target}"
						evt.error=true
					end
				end
			end
			evt.processed=true
			evt.save
		rescue Exception =>e
			puts "Exception #{e}"
		end
	end

end
