class TrafficBytesController < ApplicationController
  # GET /traffic_bytes
  # GET /traffic_bytes.xml
  def index
    @traffic_bytes = TrafficByte.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @traffic_bytes }
    end
  end

  # GET /traffic_bytes/1
  # GET /traffic_bytes/1.xml
  def show
    @traffic_byte = TrafficByte.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @traffic_byte }
    end
  end

  # GET /traffic_bytes/new
  # GET /traffic_bytes/new.xml
  def new
    @traffic_byte = TrafficByte.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @traffic_byte }
    end
  end

  # GET /traffic_bytes/1/edit
  def edit
    @traffic_byte = TrafficByte.find(params[:id])
  end

  # POST /traffic_bytes
  # POST /traffic_bytes.xml
  def create
    @traffic_byte = TrafficByte.new(params[:traffic_byte])

    respond_to do |format|
      if @traffic_byte.save
        format.html { redirect_to(@traffic_byte, :notice => 'Traffic byte was successfully created.') }
        format.xml  { render :xml => @traffic_byte, :status => :created, :location => @traffic_byte }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @traffic_byte.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /traffic_bytes/1
  # PUT /traffic_bytes/1.xml
  def update
    @traffic_byte = TrafficByte.find(params[:id])

    respond_to do |format|
      if @traffic_byte.update_attributes(params[:traffic_byte])
        format.html { redirect_to(@traffic_byte, :notice => 'Traffic byte was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @traffic_byte.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /traffic_bytes/1
  # DELETE /traffic_bytes/1.xml
  def destroy
    @traffic_byte = TrafficByte.find(params[:id])
    @traffic_byte.destroy

    respond_to do |format|
      format.html { redirect_to(traffic_bytes_url) }
      format.xml  { head :ok }
    end
  end
end
