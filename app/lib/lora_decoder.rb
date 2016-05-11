class LoraDecoder
  def self.decode params

    puts "Lora Decode:params:#{params.to_json}"

    f=File.open("log/decode.log", "a+");
    f.write(params.to_json+"\n")
    time=Time.now

    if params["time"] then
      Time.at params["time"].to_i
    end

    if uplinkindication = params["UplinkIndication"]
      devEui = (Base64.decode64(uplinkindication["LNS-DevEUI"])).unpack('H*').first
      puts "Decode: #{devEui}"
      device=Device.where(:sigfox_device_id => devEui).first
      if device
        puts "Device found"
        data = uplinkindication["LORA-FRMPayloadClearText"]
        decode = SigfoxTools.convert JSON.parse(device.codec.gsub(/\'/, '"')), data
        f.write("Converted:#{decode}\n")

        decode.each do |key, value|
          sensor = Sensor.find_by_name_or_create key, device
          if value.class == Hash && value["lat"]!=nil then
            sensor.set(:type, "Position")
          end
          measure = sensor.add_measure(value, time)
          f.write("Adding: #{measure.inspect}\n")
          device.sensors<<sensor
        end

        # check if we get signaldata
        if params["signal"]
          sensor = Sensor.find_by_name_or_create("signal", device)
          measure = sensor.add_measure(params["signal"].to_f, time)
          sensors<<sensor
          f.write("Adding Signal: #{measure.inspect}\n")
        end
        f.close
        Sensor.check_and_update device.sensors
      else
        puts "Device not found :#{device}"
      end

    end
  end


end