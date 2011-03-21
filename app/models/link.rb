class Link < ActiveRecord::Base
belongs_to :from_node, :class_name => "Node", :foreign_key => "node1"
belongs_to :to_node, :class_name => "Node", :foreign_key => "node2"
end
