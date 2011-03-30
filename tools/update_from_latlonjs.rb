#!/usr/bin/env ruby

# run with script/runner

# read latlon,js file
# update or create nodes ([id, name,] default_ipv4, lat, lon)
# update or create links ([id, ] node1, node2)

class LatLonJSUpdate
  def initialize(file)
    return unless File.exists?(file)
    fd = File.open(file)
    fd_content = ""
    begin
      while (line = fd.readline)
        fd_content += "#{line}"
      end
    rescue EOFError
    end
    begin
      fd_content.each_line do |line|
        mid_entry(line) if line =~ /Mid/
          plink_entry(line) if line =~ /PLink/
          link_entry(line) if line !~ /PLink/ && line =~ /Link/
          node_entry(line) if line =~ /Node/  || line =~ /Self/
          unknown_entry(line) if line !~ /Link/ && line !~ /Node/ && line !~ /Mid/ && line !~ /Self/
      end
      #rescue EOFError
    end 	
  end

  def mid_entry(entry)
  end

  def link_entry(entry)
  end

  def plink_entry(entry)
    data = entry.gsub(/'/, '').split(',')
    data[0] = data[0].split('(')[1]
    nodeA = Node.find(:first, :select => ['id, name'], :conditions => ['default_ipv4 = ?',data[0].strip])
    nodeB = Node.find(:first, :select => ['id, name'], :conditions => ['default_ipv4 = ?',data[1].strip])

    links = Link.find(:first, :conditions => ['(node1 = ? AND node2 =?) OR (node2 = ? AND node1 = ?)', 
                      nodeA.id, nodeB.id, nodeA.id, nodeB.id])
    if links.nil?
      puts "New Link from #{nodeA.name} to #{nodeB.name}"
      link = Link.new
      link.node1 = nodeA.id
      link.node2 = nodeB.id
      link.quality = data[2].strip
      link.last_seen = Date.today
      link.save
    else
      links.last_seen = Date.today
      links.save
    end
  end

  def node_entry(entry)
    data = entry.gsub(/'/, '').split(',')
    data[0] = data[0].split('(')[1]
    data[5] = data[5].split(')')[0]
    node = Node.find(:first, :conditions => ['name = ?', data[5].strip], :order => 'last_seen DESC')
    if node.nil?
      node = Node.new
    end
    puts "Node #{node.name} updated"
    node.name = data[5].strip
    node.default_ipv4 = data[0].strip
    node.lat = data[1].strip
    node.lon = data[2].strip
    node.last_seen = Date.today - 3.days if node.last_seen.nil? || node.last_seen < (Date.today - 3.days)
    node.save
  end

  def self_entry(entry)
    node_entry(entry)
  end

  def unknown_entry(entry)
    puts "Unknown Entry: #{entry}"
  end
end

LatLonJSUpdate.new("/var/run/latlon.js")
