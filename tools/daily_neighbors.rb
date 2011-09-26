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
		neigh_to_date = []
		labels = {}
		days.downto(0) do |day|
			date_stamp = Time.now - (60*60*24*day)
			date_sql_string = date_stamp.strftime("%Y-%m-%d")
			daily_neigh_score = Score.find(:first, 
				   :conditions => ["variant = 3 AND created_at = '#{date_sql_string}' AND node_id = #{node_id}"])
			if daily_neigh_score
				neigh_to_date << daily_neigh_score.score/2
			else
				neigh_to_date << nil
			end
			labels[days-day] = date_stamp.strftime("%b %d") if day % 3 == 0
		end
		g.data("Nachbarn", neigh_to_date)
		g.labels = labels
		g.write('public/neighbors/' + node_id + '.png')

	end

	def initialize
		Node.all.each { |node|
			create_graph(node.id.to_s)
		}
		puts "Graphen erstellt"
	end
end

GraphCreator.new
