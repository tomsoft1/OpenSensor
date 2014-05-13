class Widget
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :input, type: String
  field :color, type: String, :default=>"#EFE"

  belongs_to :dashboard
  belongs_to :sensor
  belongs_to :element_prototype

  def self.find_prototype name
  	ElementPrototype.where(:name=>name).first
  end

  def self.types
  	(["Default","Gauge","Trace"]+ElementPrototype.all.distinct(:name)).uniq
  end
  
public

  def get_prototype
  	res=self.element_prototype
  	if res==nil then res=Widget.find_prototype(type) end
  	res
  end

  def ensure_params
  	proto=get_prototype
  	if proto
  		proto.parameter_def.each do |p|
  			self[p.name_param.to_sym]=""
  		end
  	end
  end
end
