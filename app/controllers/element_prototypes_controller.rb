class ElementPrototypesController < ApplicationController
  # GET /element_prototypes
  # GET /element_prototypes.json
  def index
    @element_prototypes = ElementPrototype.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @element_prototypes }
    end
  end

  # GET /element_prototypes/1
  # GET /element_prototypes/1.json
  def show
    @element_prototype = ElementPrototype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @element_prototype }
    end
  end

  # GET /element_prototypes/new
  # GET /element_prototypes/new.json
  def new
    @element_prototype = ElementPrototype.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @element_prototype }
    end
  end

  # GET /element_prototypes/1/edit
  def edit
    @element_prototype = ElementPrototype.find(params[:id])
  end

  # POST /element_prototypes
  # POST /element_prototypes.json
  def create
    @element_prototype = ElementPrototype.new(params[:element_prototype])

    respond_to do |format|
      if @element_prototype.save
        format.html { redirect_to @element_prototype, notice: 'Element prototype was successfully created.' }
        format.json { render json: @element_prototype, status: :created, location: @element_prototype }
      else
        format.html { render action: "new" }
        format.json { render json: @element_prototype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /element_prototypes/1
  # PUT /element_prototypes/1.json
  def update
    @element_prototype = ElementPrototype.find(params[:id])

    respond_to do |format|
      if @element_prototype.update_attributes(params[:element_prototype])
        format.html { redirect_to @element_prototype, notice: 'Element prototype was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @element_prototype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /element_prototypes/1
  # DELETE /element_prototypes/1.json
  def destroy
    @element_prototype = ElementPrototype.find(params[:id])
    @element_prototype.destroy

    respond_to do |format|
      format.html { redirect_to element_prototypes_url }
      format.json { head :no_content }
    end
  end
end
