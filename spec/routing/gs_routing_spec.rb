require "spec_helper"

describe GsController do
  describe "routing" do

    it "routes to #index" do
      get("/gs").should route_to("gs#index")
    end

    it "routes to #new" do
      get("/gs/new").should route_to("gs#new")
    end

    it "routes to #show" do
      get("/gs/1").should route_to("gs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/gs/1/edit").should route_to("gs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/gs").should route_to("gs#create")
    end

    it "routes to #update" do
      put("/gs/1").should route_to("gs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/gs/1").should route_to("gs#destroy", :id => "1")
    end

  end
end
