#!/usr/bin/env ruby

# run with script/runner

# read latlon,js file
# update or create nodes ([id, name,] default_ipv4, lat, lon)
# update or create links ([id, ] node1, node2)

class LatLonJSUpdate < ActiveRecord::Base
	def initialize(file)
		return unless File.exists?(file)
		fd = File.open(file)
		begin
			while (line = fd.readline)
				mid_entry(line) if line =~ /Mid/
				plink_entry(line) if line =~ /PLink/
				link_entry(line) if line !~ /PLink/ && line =~ /Link/
				node_entry(line) if line =~ /Node/  || line =~ /Self/
				unknown_entry(line) if line !~ /Link/ && line !~ /Node/ && line !~ /Mid/ && line !~ /Self/
			end
		rescue EOFError
		end 	
	end

	def mid_entry(entry)
	end

	def link_entry(entry)
	end

	def plink_entry(entry)
	end

	def node_entry(entry)

		data = entry.gsub(/'/, '').split(',')
		data[0] = data[0].split('(')[1]
		data[5] = data[5].split(')')[0]
		a = ""
		node = Node.find_or_create_by_name(data[5].strip)
		node.name = data[5].strip
		node.default_ipv4 = data[0].strip
		node.lat = data[1].strip
		node.lon = data[2].strip
		node.last_seen = Date.today - 5.days if node.last_seen.nil? || node.last_seen < (Date.today - 5.days)
		node.save
		puts "#{data[5]} #{data[0]} #{a}"
	end

	def self_entry(entry)
		node_entry(entry)
	end

	def unknown_entry(entry)
		puts "Unknown Entry: #{entry}"
	end
end

LatLonJSUpdate.new("/var/run/latlon.js")
