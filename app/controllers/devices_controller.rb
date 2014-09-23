class DevicesController < ApplicationController
  before_filter :authenticate_user!,:except=>[:webhook]

  # GET /devices
  # GET /devices.json
  def index
    @devices = current_user.devices.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @devices }
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    @device = Device.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @device }
    end
  end

  # GET /devices/new
  # GET /devices/new.json
  def new
    @device = Device.new
    if params[:type] then @device.type=params[:type].capitalize end
    respond_to do |format|
      format.html { if !params[:type] then render "select_type" else render end}
      format.json { render json: @device }
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id])
    if @device.type=="akeru"  && @device[:sigfox]==nil then @device[:sigfox]="" end

  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.create(params[:device])
    @device.user=current_user
    if @device.type=="Akeru" &&  @device.sigfox_device_id==nil then @device[:sigfox]="";@device[:sigfox_device_id]=nil; end
    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render json: @device, status: :created, location: @device }
      else
        format.html { render action: "new" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.json
  def update
    @device = Device.find(params[:id])

    respond_to do |format|
      puts params
      if @device.update_attributes(params[:device])
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device = Device.find(params[:id])
    @device.destroy

    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end
end
