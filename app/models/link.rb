class Link < ActiveRecord::Base
belongs_to :from_node, :class_name => "Node", :foreign_key => "node1"
belongs_to :to_node, :class_name => "Node", :foreign_key => "node2"

def color
  if quality == 1
    ["00FF00", 2]
  elsif quality > 0.75 && quality < 1
    ["33FF00", 2]
  elsif quality > 0.5 && quality <= 0.75
    ["66FF00", 2]
  elsif quality > 0.25 && quality <= 0.5
    ["99FF00", 1]
  else
    ["CCFF00", 1]
  end
end
end
