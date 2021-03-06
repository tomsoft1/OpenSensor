class DashboardsController < ApplicationController
  before_filter :authenticate_user!,:except=>[:show,:webhook]
  # GET /dashboards
  # GET /dashboards.json
  def index
    @dashboards = current_user.dashboards

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dashboards }
    end
  end

  # GET /dashboards/1
  # GET /dashboards/1.json
  def show
    @dashboard = Dashboard.find(params[:id])
    if @dashboard.is_public || authenticate_user! || @dashboard.user==@current_user
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @dashboard }
      end
    end
  end

  # GET /dashboards/new
  # GET /dashboards/new.json
  def new
    @dashboard = Dashboard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dashboard }
    end
  end

  # GET /dashboards/1/edit
  def edit
    @dashboard = Dashboard.find(params[:id])
  end

  # POST /dashboards
  # POST /dashboards.json
  def create
    @dashboard = Dashboard.new(params[:dashboard])
    @dashboard.user=current_user
    respond_to do |format|
      if @dashboard.save
        format.html { redirect_to @dashboard, notice: 'Dashboard was successfully created.' }
        format.json { render json: @dashboard, status: :created, location: @dashboard }
      else
        format.html { render action: "new" }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dashboards/1
  # PUT /dashboards/1.json
  def update
    @dashboard = Dashboard.find(params[:id])

    respond_to do |format|
      if @dashboard.update_attributes(params[:dashboard])
        format.html { redirect_to @dashboard, notice: 'Dashboard was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.json
  def destroy
    @dashboard = Dashboard.find(params[:id])
    @dashboard.destroy

    respond_to do |format|
      format.html { redirect_to dashboards_url }
      format.json { head :no_content }
    end
  end

  def subscribe
    response.headers['Content-Type'] = 'text/event-stream'
    begin
      loop do
        response.stream.write "data: #{generate_new_values}\n\n" # Add 2 line breaks to delimitate events
        sleep 5.second
      end
    rescue IOError # Raised when browser interrupts the connection
    ensure
      response.stream.close # Prevents stream from being open forever
    end
  end

  # Web hook for Pusher
  def webhook
    puts "webhook"
    Pusher.url = "http://#{PUSHER_KEY}:#{PUSHER_SECRET}@api.pusherapp.com/apps/#{PUSHER_APP}"
    res = Pusher::WebHook.new(request)
    puts request.to_s
    begin
      if res.valid?
        res.events.each do |event|
          elems=event['channel'].split('-')
          active=false
          case event["name"]
          when 'channel_occupied'
            active=true
          when 'channel_vacated'
            active=false
          end
          dbclass=Object.const_get elems[0].capitalize
          db=dbclass.find elems[1]
          db.set(:active_channel,active)
        end
        render text: 'ok'
      else
        render text: 'invalid', status: 401
      end
    rescue Exception => e
      puts "Webhook exception:#{e}"
      render text: 'invalid', status: 401
    end
  end

def positions
  puts "Pos"
  #  binding.pry
  data=request.body.read
  puts ":"+data
  res=JSON.parse data
  puts res
  res.each do | widget_pos|
    widget=Widget.find widget_pos["widget_id"]
    widget.size_x=widget_pos["size_x"]
    widget.size_y=widget_pos["size_y"]
    widget.col=widget_pos["col"]
    widget.row=widget_pos["row"]
    widget.save
  end
  render :json=>{:ok=>1}
end

end
