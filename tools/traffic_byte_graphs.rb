#!/usr/bin/env ruby
#
#
require 'gruff'

class GraphCreator
  def create_graph(node_id)
    days = 14
    g = Gruff::Line.new(500)
    #g.title = "Statistik der letzten #{days} Tage"
    g.theme = {
      :colors => %w(orange purple green white red),
      :marker_color => 'yellow',
      :background_colors => 'transparent'
    }
    tp_input = []
    tp_forward = []
    tp_output = []
    labels = {}
    days.downto(0) do |day|
      date_stamp = Time.now - (60*60*24*day)
      date_sql_string = date_stamp.strftime("%Y-%m-%d")
      traffic_packet = TrafficByteIpv4.find(:first, 
                                            :conditions => ["created_at = '#{date_sql_string}' AND node_id = #{node_id}"])
      if traffic_packet
        tp_input << traffic_packet.input
        tp_forward << traffic_packet.forward
        tp_output << traffic_packet.output
      else
        tp_input << nil
        tp_forward << nil
        tp_output << nil
      end
      labels[days-day] = date_stamp.strftime("%b %d") if day % 3 == 0
    end
    g.data("Input", tp_input)
    g.data("Forward", tp_forward)
    g.data("Output", tp_output)
    g.labels = labels
    g.write('public/traffic/byte/' + node_id + '.png')

  end



  def initialize
    Node.all.each { |node|
      create_graph(node.id.to_s)
    }
  end
end

GraphCreator.new
