class HomeController < ApplicationController
 before_filter :authenticate_user!,:except=>[:show,:index]
  def index
  end
end
