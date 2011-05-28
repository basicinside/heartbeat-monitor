class ApiController < ApplicationController

  # create or update a node by its hostname
  # takes 
  # hostname :: hostname of the node
  # ip :: ip of the node
  # lat :: Latitude position of the node (optional)
  # lon :: Longitude position of the node (optional)
  def node(hostname = params[:hostname], 
           ip = params[:ip], 
           lat = params[:lat], 
           lon = params[:lon])
    node = Node.find(:first, :conditions => ['name = ?', hostname], :order => 'last_seen DESC')
    if node.nil?
      node = Node.new
    end
    node.name = hostname
    # TODO: IPv6 support
    node.default_ipv4 = ip
    node.lat = lat
    node.lon = lon
    node.last_seen = Date.today - 3.days if node.last_seen.nil? || node.last_seen < (Date.today - 3.days)
    node.save
  end

  # create or update a link
  # takes
  # from_ip :: ip addr of the first node
  # to_ip :: ip addr of the second node
  # quality :: some link quality metric in percent
  def link(from_ip = params[:from_ip], 
           to_ip = params[:to_ip], 
           quality = params[:quality])
    # TODO: IPv6 support
    nodeA = Node.find(:first, :select => ['id'], :conditions => ['default_ipv4 = ?',from_node_ip])
    nodeB = Node.find(:first, :select => ['id'], :conditions => ['default_ipv4 = ?',to_node_ip])

    links = Link.find(:first, :conditions => ['(node1 = ? AND node2 =?) OR (node2 = ? AND node1 = ?)',
                      nodeA.id, nodeB.id, nodeA.id, nodeB.id])
    if links.nil?
      link = Link.new
      link.node1 = nodeA.id
      link.node2 = nodeB.id
      link.quality = quality
      link.last_seen = Date.today
      link.save
    else
      links.last_seen = Date.today
      links.save
    end
  end
end
