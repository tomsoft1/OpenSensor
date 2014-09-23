class Device
	include Mongoid::Document

	field :name, type: String
	field :description, type: String
	field :type, type: String,:default=>"Device"
	field :sigfox,  type: String
	field :sigfox_device_id, type:Integer
	validates_presence_of :name
	belongs_to :user
	has_many :sensors

	def parse_binary_data params
		f=File.open("log/areku.log","a+");
		f.write(params.to_json+"\n")
		time=Time.now
		if params["time"] then Time.at params["time"].to_i end
		decode=SigfoxTool.convert JSON.parse(self.sigfox.gsub(/\'/,'"')),params["data"]
		f.write("Converted:#{decode}")
		decode.each do |key,value|
			sensor=Sensor.find_by_name_or_create key,self
			if value.class==Hash && value["lat"]!=nil then sensor.set(:type,"Position") end
			measure=sensor.add_measure(value,time )
			f.write("Adding: #{measure.to_s}\n")
			sensors<<sensor
		end
		# check if we get signaldata
		if params["signal"]
			sensor=Sensor.find_by_name_or_create("signal",self)
			measure=sensor.add_measure(params["signal"].to_f,time )
			sensors<<sensor
			f.write("Adding: #{measure.to_s}\n")
		end
		f.close
		Sensor.check_and_update sensors
	end
end
