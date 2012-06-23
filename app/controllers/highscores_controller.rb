class HighscoresController < ApplicationController
  caches_page :index

  @@last_seen = Date.today - 7.days

  def groups
    @groups = Group.find(:all,  
                         :select => "groups.id, groups.name, groups.description, SUM(scores.score) AS score", 
                         :conditions => ["nodes.last_seen > '#{@@last_seen}'"],
                         :joins =>  {:users => {:nodes => :scores}}, 
                         :group => "groups.id, groups.name, groups.description", 
                         :order => 'SUM(scores.score) DESC')
  end

  def users
    @users = User.find(:all,  
                       :select => "users.id, users.username, users.group_id, users.location_id, SUM(scores.score) AS score", 
                       :conditions => ["nodes.last_seen > '#{@@last_seen}'"],
                       :joins =>  {:nodes => :scores}, 
                       :group => "users.id, users.username, users.group_id, users.location_id", 
                       :order => 'SUM(scores.score) DESC')
  end

  def owned
    return unless current_user
    @owned = Node.find(:all,
                       :conditions => ["user_id = '#{current_user.id}' AND score > 0"],
                       :select => "nodes.id, nodes.name, nodes.user_id, nodes.last_seen, nodes.node_id, SUM(scores.score) AS score ",
                       :joins => [:scores],
                       :group => 'nodes.id, nodes.name, nodes.user_id, nodes.last_seen, nodes.node_id',
                       :order => 'SUM(scores.score) DESC')
  end

  def nodes
    @nodes = Node.find(:all,
                       :conditions => ["score > 0 AND last_seen > '#{@@last_seen}'"],
                       :select => "nodes.id, nodes.name, nodes.user_id, nodes.last_seen, SUM(scores.score) AS score ",
                       :joins => [:scores],
                       :group => 'nodes.id, nodes.name, nodes.user_id, nodes.last_seen',
                       :order => 'SUM(scores.score) DESC')
  end

  def provinces
    @provinces = Province.find(:all,  
                               :select => "provinces.id, provinces.name, provinces.description, SUM(scores.score) AS score",  
                               :conditions => ["nodes.last_seen > '#{@@last_seen}'"],
                               :joins => {:locations =>  {:users => {:nodes => :scores}}}, 
                               :group => "provinces.id, provinces.name, provinces.description", 
                               :order => 'SUM(scores.score) DESC')
  end

  def parties
    @parties = Party.find(:all,  
                          :select => "parties.name, parties.id, parties.description, SUM(scores.score) AS score",  
                          :conditions => ["nodes.last_seen > '#{@@last_seen}'"],
                          :joins =>  {:users => {:nodes => :scores}}, 
                          :group => "parties.name, parties.id, parties.description", 
                          :order => 'SUM(scores.score) DESC')
  end

  def locations
    @locations = Location.find(:all,  
                               :select => "locations.name, locations.id, locations.province_id, SUM(scores.score) AS score",  
                               :conditions => ["nodes.last_seen > '#{@@last_seen}'"],
                               :joins =>  {:users => {:nodes => :scores}}, 
                               :group => "locations.id, locations.name, locations.province_id", 
                               :order => 'SUM(scores.score) DESC')
  end

  def index
    groups
    users
    nodes
    provinces
    parties
    locations
    owned
  end
end
