class LinksController < ApplicationController

  def feed
    last_seen = Date.today - 4.days
    @links = Link.find(:all, :conditions => ["last_seen > '#{last_seen}'"], :include => [:from_node, :to_node])

    @styles = []
    #@styles = [["link", "df7401", "2"]]
    @links.each { |link|
      @styles << link.color if !@styles.include?(link.color)
    }
    render :layout => false
  end
end
