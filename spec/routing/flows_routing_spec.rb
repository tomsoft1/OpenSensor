require "spec_helper"

describe FlowsController do
  describe "routing" do

    it "routes to #index" do
      get("/flows").should route_to("flows#index")
    end

    it "routes to #new" do
      get("/flows/new").should route_to("flows#new")
    end

    it "routes to #show" do
      get("/flows/1").should route_to("flows#show", :id => "1")
    end

    it "routes to #edit" do
      get("/flows/1/edit").should route_to("flows#edit", :id => "1")
    end

    it "routes to #create" do
      post("/flows").should route_to("flows#create")
    end

    it "routes to #update" do
      put("/flows/1").should route_to("flows#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/flows/1").should route_to("flows#destroy", :id => "1")
    end

  end
end
