require "spec_helper"

describe SensorsController do
  describe "routing" do

    it "routes to #index" do
      get("/sensors").should route_to("sensors#index")
    end

    it "routes to #new" do
      get("/sensors/new").should route_to("sensors#new")
    end

    it "routes to #show" do
      get("/sensors/1").should route_to("sensors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sensors/1/edit").should route_to("sensors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sensors").should route_to("sensors#create")
    end

    it "routes to #update" do
      put("/sensors/1").should route_to("sensors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sensors/1").should route_to("sensors#destroy", :id => "1")
    end

  end
end
