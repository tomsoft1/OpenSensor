# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
load 'api.rb'
# Sinatra logs are in stdout...
log = File.new("log/sinatra.log", "a+")
# reopen does not works with passenger
#$stdout.reopen(log)
#$stderr.reopen(log)

#run OpenSensor::Application

# Mapping
# -------
 
# Rest with Rails
#map "/" do
#  run OpenSensor::Application
#end
 
# Anything urls starting with /slim will go to Sinatra
#map "/api" do
#  run OpenSensorApi
#end

class SubdomainDispatcher
  def initialize
    @frontend = OpenSensor::Application
    @api      = OpenSensorApi.new
  end

  def call(env)
    if subdomain(env) == 'api'
      return @api.call(env)
    else
      return @frontend.call(env)
    end
  end

  private

  # If may be more robust to use a 3rd party plugin to extract the subdomain
  # e.g ActionDispatch::Http::URL.extract_subdomain(@env['HTTP_HOST'])
  def subdomain env
    env['HTTP_HOST'].split('.').first
  end
end


run SubdomainDispatcher.new 
