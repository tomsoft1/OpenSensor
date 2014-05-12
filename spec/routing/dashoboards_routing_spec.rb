require "spec_helper"

describe DashoboardsController do
  describe "routing" do

    it "routes to #index" do
      get("/dashoboards").should route_to("dashoboards#index")
    end

    it "routes to #new" do
      get("/dashoboards/new").should route_to("dashoboards#new")
    end

    it "routes to #show" do
      get("/dashoboards/1").should route_to("dashoboards#show", :id => "1")
    end

    it "routes to #edit" do
      get("/dashoboards/1/edit").should route_to("dashoboards#edit", :id => "1")
    end

    it "routes to #create" do
      post("/dashoboards").should route_to("dashoboards#create")
    end

    it "routes to #update" do
      put("/dashoboards/1").should route_to("dashoboards#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/dashoboards/1").should route_to("dashoboards#destroy", :id => "1")
    end

  end
end
