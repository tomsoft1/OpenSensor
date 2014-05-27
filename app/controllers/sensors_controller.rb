class SensorsController < ApplicationController
  # GET /sensors
  # GET /sensors.json
  def index
    @sensors = Sensor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sensors }
    end
  end

  # GET /sensors/1
  # GET /sensors/1.json
  def show
    @sensor = Sensor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sensor }
    end
  end

  def drop
    @sensor = Sensor.find(params[:id])
    @sensor.measures.delete_all
    redirect_to @sensor

  end

  # GET /sensors/new
  # GET /sensors/new.json
  def new
    @sensor = Sensor.new
    if params[:device]
      device=Device.find params[:device]
      @sensor.device=device
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sensor }
    end
  end

  # GET /sensors/1/edit
  def edit
    @sensor = Sensor.find(params[:id])
  end

  # POST /sensors
  # POST /sensors.json
  def create
    @sensor = Sensor.new(params[:sensor])
    @sensor.user=@current_user
    respond_to do |format|
      if @sensor.save
        format.html { redirect_to @sensor, notice: 'Sensor was successfully created.' }
        format.json { render json: @sensor, status: :created, location: @sensor }
      else
        format.html { render action: "new" }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sensors/1
  # PUT /sensors/1.json
  def update
    @sensor = Sensor.find(params[:id])

    respond_to do |format|
      if @sensor.update_attributes(params[:sensor])
        format.html { redirect_to @sensor, notice: 'Sensor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensors/1
  # DELETE /sensors/1.json
  def destroy
    @sensor = Sensor.find(params[:id])
    @sensor.destroy

    respond_to do |format|
      format.html { redirect_to sensors_url }
      format.json { head :no_content }
    end
  end
end
