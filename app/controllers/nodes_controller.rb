class NodesController < ApplicationController
  require 'open-uri'
  require 'digest/md5'
  filter_access_to :all

  # GET /nodes
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
    if params[:node_id]
      redirect_to "/nodes/register/#{params[:node_id]}"
      return
    end
    if params[:id] 
      if !current_user
        flash[:notice] = 'Bitte logge dich ein, um ein Gerät zu registrieren.'
        redirect_to root_url
      end
      if node = Node.find(:first, :conditions => ["node_id = ?", params[:id]])
        if node.user && node.user != current_user
          flash[:notice] = "Das Gerät ist bereits von 
          <a href='/users/show/#{node.user.id}'>#{node.user.username}</a> registriert. 
          Bitte wende dich an den Administrator."
          redirect_to node
        else
          flash[:notice] = "Das Gerät ist nun registriert auf 
          <a href='/users/show/#{current_user.id}'>#{current_user.username}</a>."
          node.user = current_user
          node.save
          redirect_to node
        end
      else
        flash[:notice] = "Das Gerät wurde nicht gefunden."
        redirect_to '/nodes/register'
      end
    else
      respond_to do |format|
        format.html
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
    #check for node

    # node exists without heartbeat
    node = Node.find_by_name(params[:name], :conditions => ['id = NULL'])	
    if node.nil?
      node = Node.find_or_create_by_node_id(params[:node_id]) 
    end

    #update or create values
    node.version 	= params[:version] 		if params[:version]
    node.name 	= params[:name] 	if params[:name]
    node.lat 	= params[:lat] 		if params[:lat]
    node.lon 	= params[:lon] 		if params[:lon]
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

    respond_to do |format|
      if node.save
        flash[:notice] = 'Node was successfully created.'
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => node, :status => :created, :location => node }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => node.errors, :status => :unprocessable_entity }
      end
    end
  end
end
