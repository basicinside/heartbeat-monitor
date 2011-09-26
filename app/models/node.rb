class Node < ActiveRecord::Base

  has_many :photos
  validates_presence_of :name

  belongs_to :user
  has_one :group, :through => :user
  has_one :party, :through => :user
  has_one :location, :through => :user
  has_many :heartbeats, :dependent => :destroy
  has_many :services, :conditions => ["state = 'open' AND last_seen > ?", Date.today - 4.days]
  has_many :scores, :dependent => :destroy
  has_many :links, :class_name => "Link", :finder_sql => 'SELECT * FROM links WHERE (node1 = #{id} OR node2 = #{id}) AND last_seen > \'#{Date.today - 7.days}\''
  #paperclip
    has_attached_file :photo,
         :styles => { :small  => "150x150#" }

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

  def map_desc
    desc = ""
    desc = "<div id=\"punkte\">#{score_count} Punkte</div> <br />"
    desc += "von #{user.username}" if user
    desc += "( #{user.group.name} )" if user && user.group
    desc += "<br />aus <i>#{user.location.province.name} - #{user.location.name}</i><br />" if user && user.location
    desc += "<br />Freifunk IPv4: <a href='http://#{default_ipv4}'>#{default_ipv4}</a><br />" if default_ipv4
    desc += "<br />#{description}" if description
    desc
  end

  def score_count
    Score.sum('score', :conditions => ['node_id = ?', id])
  end


  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
  end

end
