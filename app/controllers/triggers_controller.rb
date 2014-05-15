class TriggersController < ApplicationController
  before_filter :authenticate_user!
  # GET /triggers
  # GET /triggers.json
  def index
    @triggers = @current_user.triggers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @triggers }
    end
  end

  # GET /triggers/1
  # GET /triggers/1.json
  def show
    @trigger = Trigger.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trigger }
    end
  end

  # GET /triggers/new
  # GET /triggers/new.json
  def new
    @trigger = Trigger.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trigger }
    end
  end

  # GET /triggers/1/edit
  def edit
    @trigger = Trigger.find(params[:id])
  end

  # POST /triggers
  # POST /triggers.json
  def create
    @trigger = Trigger.new(params[:trigger])
    @trigger.user=@current_user
    respond_to do |format|
      if @trigger.save
        if check_creation @trigger then return end
        format.html { redirect_to @trigger, notice: 'Trigger was successfully created.' }
        format.json { render json: @trigger, status: :created, location: @trigger }
      else
        format.html { render action: "new" }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /triggers/1
  # PUT /triggers/1.json
  def update
    @trigger = Trigger.find(params[:id])

    respond_to do |format|
      @trigger.user=@current_user
      if @trigger.update_attributes(params[:trigger])
        if check_creation @trigger then return end
        format.html { redirect_to @trigger, notice: 'Trigger was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /triggers/1
  # DELETE /triggers/1.json
  def destroy
    @trigger = Trigger.find(params[:id])
    @trigger.destroy

    respond_to do |format|
      format.html { redirect_to triggers_url }
      format.json { head :no_content }
    end
  end

  def check_creation trigger
    if trigger.type=="twitter"
      name=trigger.target
      if name[0]=="@"
        name=name[1..-1]
        trigger.set(:target,name)
      end
      if trigger.is_dm
        cred=TwitterCredential.where(:screen_name=>"opensensorcloud").first
        begin
          u=cred.client.user name
          rel=cred.client.friendship(cred.twitter_id.to_i,u.id)
          if !rel.source.can_dm?
            flash[:notice]="The user @#{name} is not following @opensensorcloud, I can not DM to it"
            redirect_to edit_trigger_path trigger
            return true
          end
        rescue Twitter::Error::NotFound=>e
          flash[:notice]="Unkown twitter use...#{name}"
          redirect_to edit_trigger_path trigger
          return true
        end


      else
        if TwitterCredential.where(:user=>@current_user,:screen_name=>name).first==nil
          puts "We dont'thave yet credential!"
          session[:trigger]=trigger.id
          redirect_to connect_twitter_credentials_path
          return true
        end
      end
    end
    return false
  end
end
