class HomeController < ApplicationController
 before_filter :authenticate_user!,:except=>[:show,:index]
  def index
  	redirect_to "/home/index.html"
  end
end
