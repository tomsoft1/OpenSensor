class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    redirect_to user_path current_user     	
  end

  def show
  	if params[:id]=="me" 
  		@user=current_user
  	else
	    @user = User.find(params[:id])
	end
  end

end
