class TrafficPacketsController < ApplicationController
  # GET /traffic_packets
  # GET /traffic_packets.xml
  def index
    @traffic_packets = TrafficPacket.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @traffic_packets }
    end
  end

  # GET /traffic_packets/1
  # GET /traffic_packets/1.xml
  def show
    @traffic_packet = TrafficPacket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @traffic_packet }
    end
  end

  # GET /traffic_packets/new
  # GET /traffic_packets/new.xml
  def new
    @traffic_packet = TrafficPacket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @traffic_packet }
    end
  end

  # GET /traffic_packets/1/edit
  def edit
    @traffic_packet = TrafficPacket.find(params[:id])
  end

  # POST /traffic_packets
  # POST /traffic_packets.xml
  def create
    @traffic_packet = TrafficPacket.new(params[:traffic_packet])

    respond_to do |format|
      if @traffic_packet.save
        format.html { redirect_to(@traffic_packet, :notice => 'Traffic packet was successfully created.') }
        format.xml  { render :xml => @traffic_packet, :status => :created, :location => @traffic_packet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @traffic_packet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /traffic_packets/1
  # PUT /traffic_packets/1.xml
  def update
    @traffic_packet = TrafficPacket.find(params[:id])

    respond_to do |format|
      if @traffic_packet.update_attributes(params[:traffic_packet])
        format.html { redirect_to(@traffic_packet, :notice => 'Traffic packet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @traffic_packet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /traffic_packets/1
  # DELETE /traffic_packets/1.xml
  def destroy
    @traffic_packet = TrafficPacket.find(params[:id])
    @traffic_packet.destroy

    respond_to do |format|
      format.html { redirect_to(traffic_packets_url) }
      format.xml  { head :ok }
    end
  end
end
