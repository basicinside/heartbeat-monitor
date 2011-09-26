#!/usr/bin/env ruby
#
#


class ServiceScanner
	def initialize
		nodes = Node.find(:all, :conditions => ['default_ipv4 IS NOT NULL'])
		nodes.each { |node|
			nmap = `nmap -p 80,21,137,138,139,22,443,8080 #{node.default_ipv4}`
			if nmap =~ /seem down/
				#puts "#{node.name} down"
			else
				#puts "#{node.name} has services:"
				i = 0
				lines = nmap.split("\n")
				lines.each { |line|
					next unless line =~ /tcp/ || line =~ /udp/
					#puts ":: " + line

					service_values = line.split
					port, proto = service_values[0].strip.split("/")
					service = Service.find(:first, :conditions => ['node_id = ? AND proto = ? AND port = ?', node.id, proto, port])
					if service.nil?
						service = Service.new
						service.node_id = node.id
					end
					service.proto = proto
					service.port = port
					service.state = service_values[1].strip
					service.name =  service_values[2].strip
					service.last_seen = Date.today
					service.save
				}
			end
		}


	end
end

ServiceScanner.new
