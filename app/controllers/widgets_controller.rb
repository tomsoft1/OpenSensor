class WidgetsController < ApplicationController
 before_filter :authenticate_user!
  # GET /widgets
  # GET /widgets.json
  def index
    @widgets =  @current_user.widget

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @widgets }
    end
  end

  # GET /widgets/1
  # GET /widgets/1.json
  def show
    @widget = Widget.find(params[:id])
    if @widget.user!=@current_user then raise "Widget does not belongs to you"; end;
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @widget }
    end
  end

  # GET /widgets/new
  # GET /widgets/new.json
  def new
    @widget = Widget.new
    @widget.dashboard=Dashboard.find params[:dashboard]
    @widget.element_prototype
    if params[:type] then @widget.type=params[:type] end
    respond_to do |format|
      format.html { if !params[:type] then render "select_type" else render end}
      format.json { render json: @widget }
    end
  end

  # GET /widgets/1/edit
  def edit
    @widget = Widget.find(params[:id])
  end

  # POST /widgets
  # POST /widgets.json
  def create
    @widget = Widget.new(params[:widget])
         if @widget.update_attributes(params[:widget])
        redirect_to @widget.dashboard
      return
    end
    respond_to do |format|
      if @widget.save
        format.html { redirect_to @widget, notice: 'Widget was successfully created.' }
        format.json { render json: @widget, status: :created, location: @widget }
      else
        format.html { render action: "new" }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /widgets/1
  # PUT /widgets/1.json
  def update
    @widget = Widget.find(params[:id])
      if @widget.update_attributes(params[:widget])
        @widget.element_prototype=Widget.find_prototype(@widget.type)
        redirect_to @widget.dashboard
      end
      return
    respond_to do |format|
      if @widget.update_attributes(params[:widget])
        redirect_to @widget.dashboard
#        format.html { redirect_to @widget, notice: 'Widget was successfully updated.' }
       format.json { render json: @widget }
      else
        format.html { render action: "edit" }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /widgets/1
  # DELETE /widgets/1.json
  def destroy
    @widget = Widget.find(params[:id])
    @widget.destroy

    respond_to do |format|
      format.html { redirect_to  @widget.dashboard }
      format.json { head :no_content }
    end
  end
end
