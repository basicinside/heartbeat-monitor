class MapsController < ApplicationController
  caches_page :map
  def index
    render :layout => false
  end
  def map
    if params[:lat] && params[:lon]
      @lat = params[:lat]
      @lon = params[:lon]
    end
    if params[:zoom] 
      @zoom = params[:zoom]
    end


    last_seen = Date.today - 7.days
    nodes = []
    links = []

    Node.find(:all, :conditions => ["last_seen > '#{last_seen}'"]).each { |node|
      nodes << { 
        :id => node.id,
        :name => node.name, 
          :lat => node.lat,
          :lon => node.lon,
          :ipv4 => node.default_ipv4
      }
    }

    Link.find(:all, :conditions => ["last_seen > '#{last_seen}'"]).each { |link|
      begin
        links << {
        :from => link.node1,
        :to => link.node2,
        :lq => link.lq,
        :nlq => link.nlq
      }
      rescue
      end
    }

    @nodes = nodes.to_json
    @links = links.to_json

    render :layout => false
   end
  end
