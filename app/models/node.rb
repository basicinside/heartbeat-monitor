class Node < ActiveRecord::Base

  has_many :photos
  validates_presence_of :name
  
  belongs_to :user
  has_one :group, :through => :user
	has_one :party, :through => :user
	has_one :location, :through => :user
	has_many :heartbeats, :dependent => :destroy
	has_many :scores, :dependent => :destroy
        has_many :links, :class_name => "Link", :finder_sql => 'SELECT * FROM links WHERE (node1 = #{id} OR node2 = #{id}) AND last_seen > \'#{Date.today - 7.days}\''

  def neighbors
    neighbor_arr = []
    links.each { |link|
      if link.node1 == id
        neighbor_arr << Node.find(link.node2)
      else
        neighbor_arr << Node.find(link.node1)
      end
    }
    neighbor_arr
  end

  def score_count
  	Score.sum('score', :conditions => ['node_id = ?', id])
  end
  

def photo_attributes=(photo_attributes)
  photo_attributes.each do |attributes|
    photos.build(attributes)
  end
end
  
  def popup_info
  	if name != ''
  		"<h4><a href='/nodes/#{id}'>#{name}</a></h4>
  		Firmware #{version}<br />
 			#{score_count} Punkte"
 		else
 		""
 		end
  end
end
