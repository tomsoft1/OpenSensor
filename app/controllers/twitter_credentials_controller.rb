class TwitterCredentialsController < ApplicationController
   before_filter :authenticate_user!

  def connect
    puts "In connect"

    session[:twitter_referer]=request.env["HTTP_REFERER"]
    puts "Source:"+session[:twitter_referer].to_s

    client =TwitterOAuth::Client.new(
    :consumer_secret=>TWITTER_CONSUMER_SECRET,
    :consumer_key=>TWITTER_CONSUMER_KEY)
    puts client.inspect
    puts "Callback: http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/twitter_credentials/callback"
    requestOauth= client.request_token(:oauth_callback => "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/twitter_credentials/callback")
    session[:token]=requestOauth.token
    session[:secret]=requestOauth.secret
    redirect_to requestOauth.authorize_url
  end

  def callback
    begin
      if params[:denied]
        flash[:notice]="No problem, you will be able to log in anytime"
        redirect_to "/"
      else
        puts params.to_s
        client =TwitterOAuth::Client.new(
        :consumer_secret=>TWITTER_CONSUMER_SECRET,
        :consumer_key=>TWITTER_CONSUMER_SECRET)
        access_token = client.authorize(
        session[:token],
        session[:secret],
        :oauth_verifier => params[:oauth_verifier]

        )
        puts access_token.inspect
        puts "screen name"+access_token.params[:screen_name]
        cred=TwitterCredential.where(:user=>@current_user,:twitter_id=>access_token.params[:user_id].to_s).first
        if cred==nil
          cred=TwitterCredential.where(:user=>@current_user,:screen_name=>access_token.params[:screen_name]).first
        end
        if cred==nil
          cred=TwitterCredential.new(:user=>@current_user)
        end
        cred.twitter_id=access_token.params[:user_id]
        cred.screen_name=access_token.params[:screen_name]
        cred.token_access=access_token.token
        cred.token_secret=access_token.secret
        cred.save        
        redirect=session[:twitter_referer]
        session[:twitter_referer]=nil
        # If there is a current trigger being creaed

        if session[:trigger]
          trigger=Trigger.find session[:trigger]
          if trigger.target!=cred.screen_name
            trigger.target=cred.screen_name
            trigger.save
            session[:trigger]=nil
             flash.notice="Warning,you've registered with a different twitter account, this will be updated"
          end

        end

        # Do a test
        puts  "Authorized: #{client.authorized?}"
        # if  !client.authorized?
        #   flash[:notice]="error authorization"
        # end
        if redirect then
          redirect_to redirect
        else
          redirect_to :action=>"show"
        end
      end
    rescue Exception => e
      flash.notice="error while getting authorization"
        redirect_to "/"
    end
  end
  # GET /twitter_credentials
  # GET /twitter_credentials.json
  def index
    @twitter_credentials = TwitterCredential.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @twitter_credentials }
    end
  end

  # GET /twitter_credentials/1
  # GET /twitter_credentials/1.json
  def show
    @twitter_credential = TwitterCredential.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @twitter_credential }
    end
  end

  # GET /twitter_credentials/new
  # GET /twitter_credentials/new.json
  def new
    @twitter_credential = TwitterCredential.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @twitter_credential }
    end
  end

  # GET /twitter_credentials/1/edit
  def edit
    @twitter_credential = TwitterCredential.find(params[:id])
  end

  # POST /twitter_credentials
  # POST /twitter_credentials.json
  def create
    @twitter_credential = TwitterCredential.new(params[:twitter_credential])

    respond_to do |format|
      if @twitter_credential.save
        format.html { redirect_to @twitter_credential, notice: 'Twitter credential was successfully created.' }
        format.json { render json: @twitter_credential, status: :created, location: @twitter_credential }
      else
        format.html { render action: "new" }
        format.json { render json: @twitter_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /twitter_credentials/1
  # PUT /twitter_credentials/1.json
  def update
    @twitter_credential = TwitterCredential.find(params[:id])

    respond_to do |format|
      if @twitter_credential.update_attributes(params[:twitter_credential])
        format.html { redirect_to @twitter_credential, notice: 'Twitter credential was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @twitter_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_credentials/1
  # DELETE /twitter_credentials/1.json
  def destroy
    @twitter_credential = TwitterCredential.find(params[:id])
    @twitter_credential.destroy

    respond_to do |format|
      format.html { redirect_to twitter_credentials_url }
      format.json { head :no_content }
    end
  end
end
