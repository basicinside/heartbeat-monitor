class LinksController < ApplicationController

  def feed
    last_seen = Date.today - 7.days
    @links = Link.find(:all, :conditions => ["last_seen > '#{last_seen}'"], :include => [:from_node, :to_node])

    @styles = []
    @styles = [["link", "df7401", "2"]]
    render :layout => false
  end
end
