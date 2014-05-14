class Trigger
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :target, type:String
  field :limit, type: Float
  field :operator, type: String
  field :target , type: String
  field :is_dm  , type: Boolean
  belongs_to :sensor
  belongs_to :user
  has_many :trigger_events

  index({ sensor: 1 }, {  background: true })
def self.operators
	{"gt"=>">","lt"=>"<","eq"=>"="}
end

def check_trigger measure
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
	end
	puts "Result:#{cond}"
	if cond
		evt=TriggerEvent.new(:trigger=>self,:measure=>measure,
			:log=>"Checking #{val} #{operator} #{limit} Action:#{type} on:#{target}")
		trigger_events<<evt
		self.save
		process_event evt
	end
end

def process_event evt
	target=self.target
	name=self.sensor.name
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
		msg="ALERT, your #{self.sensor.name} on #{self.sensor.device.name} reached:#{evt.measure.value} (condition #{self.operator}  #{self.limit})"
		if self.is_dm
			begin
				puts "Is dm"
				cred=TwitterCredential.where(:screen_name=>"opensensorcloud").first
				res=cred.send_dm(self.target,msg)
				puts res
				evt.log+=" DM send"
			rescue Exception=> e
				puts "Error #{e}"
				evt.log+="\nERROR:#{e}"
				evt.error=true
			end
		else
			cred=TwitterCredential.where(:screen_name=>target).first
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
end

end
