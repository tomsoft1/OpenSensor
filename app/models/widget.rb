class Widget < Action
  field :color,  type: String, :default=>"#EFE"
  field :input,  type: String
  field :size_x, type: Integer,:default=>2
  field :size_y, type: Integer,:default=>1
  field :col,    type: Integer,:default=>1
  field :row,    type: Integer,:default=>1
  
  field :order,  type: Integer


  belongs_to :dashboard

  def self.types
    (["Default","Gauge","Trace"]+ElementPrototype.all.distinct(:name)).uniq
  end


end

