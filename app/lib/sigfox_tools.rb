class SigfoxTool

  # Extract a single data from the data feed and convert it to a correct hexa value
  # note that size is in byte, so 2 chars
  def self.extract_data data, offset, size

    tmpdata=data[offset..offset+size*2-1].reverse;
    res=[];
    0.upto(tmpdata.size/2-1).each do |i|
      res+=[tmpdata[i*2+1], tmpdata[i*2]]
    end
    res.join
  end

  def self.get_int data, offset, size
    [self.extract_data(data, offset, size).to_i(16)].pack('L').unpack('I').first
  end

  def self.get_float data, offset, size
    [self.extract_data(data, offset, size).to_i(16)].pack('L').unpack('F').first
  end

  def self.convert binding, data, result={}, offset=0
    puts "Being callded with #{binding} #{data}"
    puts "Current #{result}"
    binding.each do |a_binding|
      case a_binding["type"]
        when "position"
          result[a_binding["name"]]=convert a_binding["struct"], data, {}, offset
        when "float"
          result[a_binding["name"]]=get_float(data, offset, 4)
          offset+=8
        when "int"
          result[a_binding["name"]]=get_int(data, offset, 2)
          offset+=4
      end
    end
    result
  end
end
