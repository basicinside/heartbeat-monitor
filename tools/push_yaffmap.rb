#!/usr/bin/env ruby
#
#
require 'savon'

class PushYaffmap
  def initialize
    client = Savon::Client.new do
      wsdl.document = 'http://yaffmap.gross-holger.de/soap.php?wsdl'
    end
    #response = client.request :get_backends do
    #  soap.body = { :version => '0.1-21' }
    #end

    #response2 = client.request :get_ff_nodes do
    #  soap.body = { :ul => '0', :lr => '0' }
    #end

    #puts response2.inspect


    Node.all.each { |node|
      if node.score_count > 0 
        response3 = client.request :set_misc do
          soap.body = { :host_name => node.name, :data => node.map_desc }
        end 
        puts node.name
      end
    }
  end
end
  PushYaffmap.new
