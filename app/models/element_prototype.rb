class ElementPrototype
  include Mongoid::Document
  field :name, type: String
  field :icon, type: String
  field :description, type: String
  embeds_many :parameter_def
  has_many :widgets
end

class ParameterDef
  include Mongoid::Document
  field :name, type: String
  field :mandatory, type: Boolean, :default => false
  field :default, type: Object
  field :description, type: String
  embedded_in :ElementPrototype

  def name_param
    res=name.downcase
    if res=="type" then
      res="param_"+res
    end
    res
  end
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
  field :values, type: Array
end

class ParameterSensor < ParameterDef
  field :can_be_empty, type: Boolean, :default => false
  has_one :sensor
end


