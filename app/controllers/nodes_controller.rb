class NodesController < ApplicationController
  require 'open-uri'
  require 'digest/md5'

  def update
    @node = Node.find(params[:id])

    if current_user && current_user.id == @node.user_id && @node.update_attributes(params[:node])
      flash[:notice] = "Bild erfolgreich hochgeladen."
    else
      flash[:warning] = "Bild konnte nicht hochgeladen werden."
    end
  end



  # GET / edes
  # return nodes ordered by scores
  # where last_seen < 7 days
  def index
    last_seen = Date.today - 7.days
    @nodes = Node.find(:all, 
                       :conditions => ["score > 0 AND last_seen > '#{last_seen}'"],  
                       :select => "nodes.id, nodes.name, nodes.user_id, nodes.last_seen, SUM(scores.score) AS score ",
                       :joins => [:scores], 
                       :group => 'nodes.id, nodes.name, nodes.user_id, nodes.last_seen', 
                       :order => 'SUM(scores.score) DESC')

    respond_to do |format|
      format.html
    end
  end

  # register an existing node to user
  def register
    #render :text => request.path
    if params[:node_id] 
      params[:id] = params[:node_id]      
    end
    if params[:id]
      if !current_user
        flash[:notice] = 'Bitte logge dich ein, um ein Gerät zu registrieren.'
        #redirect_to root_url
        return
      end
      if node = Node.find(:first, :conditions => ["node_id = ?", params[:id]])
        if node.user && node.user != current_user
          flash[:notice] = "Das Gerät ist bereits von  #{node.user.username} registriert. 
          Bitte wende dich an den Administrator."
          #redirect_to node
          return false
        else
          flash[:notice] = "Das Gerät ist nun registriert auf  #{current_user.username}."
          node.user = current_user
          node.save
          #redirect_to '/nodes/' + node.id.to_s
          return false
        end
      else
        flash[:notice] = "Das Gerät wurde nicht gefunden."
        #redirect_to '/nodes/register'
        return false
      end
    end
  end


  # KML feed of nodes for the map
  def feed
    last_seen = Date.today - 7.days
    @nodes = Node.find(:all, :conditions => ["last_seen > '#{last_seen}'"])

    @styles = []
    @styles = [["wireless", "http://heartbeat.basicinside.de/images/flag.png"]]
    render :layout => false
  end

  # load a node from the database and display it
  def show
    @node = Node.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def traffic_bytes6
    node = Node.find_by_node_id(params[:node_id]) if params[:node_id]

    if node
      tb = TrafficByteIpv6.new()
      tb.node_id = node.id

      tb.input      = params[:i].to_i
      tb.input_udp  = params[:iu].to_i
      tb.input_olsr = params[:io].to_i
      tb.input_tcp  = params[:it].to_i
      tb.input_ftp  = params[:if].to_i
      tb.input_ssh  = params[:is].to_i
      tb.input_smtp = params[:im].to_i
      tb.input_http = params[:ih].to_i
      tb.input_https= params[:iw].to_i
      tb.input_icmp= params[:ic].to_i

      tb.forward      = params[:f].to_i
      tb.forward_udp  = params[:fu].to_i
      tb.forward_olsr = params[:fo].to_i
      tb.forward_tcp  = params[:ft].to_i
      tb.forward_ftp  = params[:ff].to_i
      tb.forward_ssh  = params[:fs].to_i
      tb.forward_smtp = params[:fm].to_i
      tb.forward_http = params[:fh].to_i
      tb.forward_https= params[:fw].to_i
      tb.forward_icmp = params[:fc].to_i

      tb.output      = params[:o].to_i
      tb.output_udp  = params[:ou].to_i
      tb.output_olsr = params[:oo].to_i
      tb.output_tcp  = params[:ot].to_i
      tb.output_ftp  = params[:of].to_i
      tb.output_ssh  = params[:os].to_i
      tb.output_smtp = params[:om].to_i
      tb.output_http = params[:oh].to_i
      tb.output_https= params[:ow].to_i
      tb.output_icmp = params[:oc].to_i
      tb.save
      render :text => "Ok" and return
    end
    render :text => "Failed"
  end

  def traffic_packets6
    node = Node.find_by_node_id(params[:node_id]) if params[:node_id]

    if node
      tp = TrafficPacketIpv6.new()
      tp.node_id = node.id

      tp.input      = params[:i].to_i
      tp.input_udp  = params[:iu].to_i
      tp.input_olsr = params[:io].to_i
      tp.input_tcp  = params[:it].to_i
      tp.input_ftp  = params[:if].to_i
      tp.input_ssh  = params[:is].to_i
      tp.input_smtp = params[:im].to_i
      tp.input_http = params[:ih].to_i
      tp.input_icmp= params[:ic].to_i

      tp.forward      = params[:f].to_i
      tp.forward_udp  = params[:fu].to_i
      tp.forward_olsr = params[:fo].to_i
      tp.forward_tcp  = params[:ft].to_i
      tp.forward_ftp  = params[:ff].to_i
      tp.forward_ssh  = params[:fs].to_i
      tp.forward_smtp = params[:fm].to_i
      tp.forward_http = params[:fh].to_i
      tp.forward_https= params[:fw].to_i
      tp.forward_icmp = params[:fc].to_i

      tp.output      = params[:o].to_i
      tp.output_udp  = params[:ou].to_i
      tp.output_olsr = params[:oo].to_i
      tp.output_tcp  = params[:ot].to_i
      tp.output_ftp  = params[:of].to_i
      tp.output_ssh  = params[:os].to_i
      tp.output_smtp = params[:om].to_i
      tp.output_http = params[:oh].to_i
      tp.output_https= params[:ow].to_i
      tp.output_icmp = params[:oc].to_i
      tp.save
      render :text => "Ok" and return
    end
    render :text => "Failed"
  end

  def traffic_bytes
    node = Node.find_by_node_id(params[:node_id]) if params[:node_id]

    if node
      tb = TrafficByteIpv4.new()
      tb.node_id = node.id

      tb.input      = params[:i].to_i
      tb.input_udp  = params[:iu].to_i
      tb.input_olsr = params[:io].to_i
      tb.input_tcp  = params[:it].to_i
      tb.input_ftp  = params[:if].to_i
      tb.input_ssh  = params[:is].to_i
      tb.input_smtp = params[:im].to_i
      tb.input_http = params[:ih].to_i
      tb.input_https= params[:iw].to_i
      tb.input_icmp= params[:ic].to_i

      tb.forward      = params[:f].to_i
      tb.forward_udp  = params[:fu].to_i
      tb.forward_olsr = params[:fo].to_i
      tb.forward_tcp  = params[:ft].to_i
      tb.forward_ftp  = params[:ff].to_i
      tb.forward_ssh  = params[:fs].to_i
      tb.forward_smtp = params[:fm].to_i
      tb.forward_http = params[:fh].to_i
      tb.forward_https= params[:fw].to_i
      tb.forward_icmp = params[:fc].to_i

      tb.output      = params[:o].to_i
      tb.output_udp  = params[:ou].to_i
      tb.output_olsr = params[:oo].to_i
      tb.output_tcp  = params[:ot].to_i
      tb.output_ftp  = params[:of].to_i
      tb.output_ssh  = params[:os].to_i
      tb.output_smtp = params[:om].to_i
      tb.output_http = params[:oh].to_i
      tb.output_https= params[:ow].to_i
      tb.output_icmp = params[:oc].to_i
      tb.save
      render :text => "Ok" and return
    end
    render :text => "Failed"
  end

  def traffic_packets
    node = Node.find_by_node_id(params[:node_id]) if params[:node_id]

    if node
      tp = TrafficPacketIpv4.new()
      tp.node_id = node.id

      tp.input      = params[:i].to_i
      tp.input_udp  = params[:iu].to_i
      tp.input_olsr = params[:io].to_i
      tp.input_tcp  = params[:it].to_i
      tp.input_ftp  = params[:if].to_i
      tp.input_ssh  = params[:is].to_i
      tp.input_smtp = params[:im].to_i
      tp.input_http = params[:ih].to_i
      tp.input_icmp= params[:ic].to_i

      tp.forward      = params[:f].to_i
      tp.forward_udp  = params[:fu].to_i
      tp.forward_olsr = params[:fo].to_i
      tp.forward_tcp  = params[:ft].to_i
      tp.forward_ftp  = params[:ff].to_i
      tp.forward_ssh  = params[:fs].to_i
      tp.forward_smtp = params[:fm].to_i
      tp.forward_http = params[:fh].to_i
      tp.forward_https= params[:fw].to_i
      tp.forward_icmp = params[:fc].to_i

      tp.output      = params[:o].to_i
      tp.output_udp  = params[:ou].to_i
      tp.output_olsr = params[:oo].to_i
      tp.output_tcp  = params[:ot].to_i
      tp.output_ftp  = params[:of].to_i
      tp.output_ssh  = params[:os].to_i
      tp.output_smtp = params[:om].to_i
      tp.output_http = params[:oh].to_i
      tp.output_https= params[:ow].to_i
      tp.output_icmp = params[:oc].to_i
      tp.save
      render :text => "Ok" and return
    end
    render :text => "Failed"
  end


  #function triggered by heartbeat script (node side)
  def status
    if !params[:node_id] || !(/^[0-9a-f]{32}$/.match(params[:node_id]))
      flash[:notice] = 'Update fehlgeschlagen<br />Interner Fehler: Datenbank nicht erreichbar.<br /> Bitte versuchen Sie es später noch einmal.'
      redirect_to :action => "index"
      return
    end

    #support older version typo
    params[:version]  ||= params[:rev]
    params[:neighbors] ||= params[:neighboors]

    # node exists without heartbeat
      node = Node.find_by_node_id(params[:node_id])	
    if node.nil? 
    node = Node.find_or_create_by_name(params[:name]) 
    end

    #update or create values
    node.name 	= params[:name] if params[:name]
    node.arch   = params[:arch] if params[:arch]
    node.model = params[:model] if params[:model]
    node.default_ipv4 = params[:ipv4] if params[:ipv4]
    node.default_ipv6 = params[:ipv6] if params[:ipv6]
    node.version 	= params[:version] if params[:version]
    node.lat 	= params[:lat] if params[:lat]
    node.lon 	= params[:lon] if params[:lon]
    node.save

    if node.last_seen.nil? || node.last_seen < Date.today
      heartbeat = Heartbeat.new
      heartbeat.node = node
      heartbeat.date = Date.today
      #check for first time arrival
      if Heartbeat.find_by_node_id(node.id) == nil
        Score.new(:variant => 0, :score => 500, :node_id => node.id).save
      end

      #validate score
      #heartbeat score
      Score.new(:variant => 1, :score => 5, :node_id => node.id).save

      #clients score
      heartbeat.clients = params[:clients].to_i if params[:clients]
      Score.new(:variant => 2, :score => 1 * params[:clients].to_i, :node_id => node.id).save
      #neighbors score
      heartbeat.neighbors = params[:neighbors].to_i if params[:neighbors]
      Score.new(:variant => 3, :score => 2 * params[:neighbors].to_i, :node_id => node.id).save

      heartbeat.save

      #set last_seen
      node.last_seen = Date.today
      node.save

    end

      if node.save
        render :text => 'Ok'
      end

  end
end
