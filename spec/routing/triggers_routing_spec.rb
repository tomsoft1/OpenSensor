require "spec_helper"

describe TriggersController do
  describe "routing" do

    it "routes to #index" do
      get("/triggers").should route_to("triggers#index")
    end

    it "routes to #new" do
      get("/triggers/new").should route_to("triggers#new")
    end

    it "routes to #show" do
      get("/triggers/1").should route_to("triggers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/triggers/1/edit").should route_to("triggers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/triggers").should route_to("triggers#create")
    end

    it "routes to #update" do
      put("/triggers/1").should route_to("triggers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/triggers/1").should route_to("triggers#destroy", :id => "1")
    end

  end
end
