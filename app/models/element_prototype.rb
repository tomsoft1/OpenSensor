class ElementPrototype
  include Mongoid::Document
  field :name, type: String

  embeds_many :parameter_def
  has_many :widgets
end
class ParameterDef
    include Mongoid::Document
	field :name, type:String
	field :mandatory, type:Boolean,:default=>false
	embedded_in :ElementPrototype

end

class ParameterString < ParameterDef
end

class ParameterBoolean < ParameterDef
end

class ParameterFloat < ParameterDef
end

class ParameterInteger < ParameterDef
end

class ParameterEnum < ParameterDef
	field :values, type:Array
end

class ParameterSensor < ParameterDef
	has_one :sensor
end


