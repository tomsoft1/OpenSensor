class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!,:assign_user

  Mongoid.logger.level = Logger::ERROR
  Moped.logger.level = Logger::ERROR

  def assign_user
  	if current_user then @current_user=current_user end
  end



end
