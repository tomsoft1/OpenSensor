require "spec_helper"

describe ElementPrototypesController do
  describe "routing" do

    it "routes to #index" do
      get("/element_prototypes").should route_to("element_prototypes#index")
    end

    it "routes to #new" do
      get("/element_prototypes/new").should route_to("element_prototypes#new")
    end

    it "routes to #show" do
      get("/element_prototypes/1").should route_to("element_prototypes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/element_prototypes/1/edit").should route_to("element_prototypes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/element_prototypes").should route_to("element_prototypes#create")
    end

    it "routes to #update" do
      put("/element_prototypes/1").should route_to("element_prototypes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/element_prototypes/1").should route_to("element_prototypes#destroy", :id => "1")
    end

  end
end
