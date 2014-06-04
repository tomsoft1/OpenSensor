require "spec_helper"

describe ElementsController do
  describe "routing" do

    it "routes to #index" do
      get("/elements").should route_to("elements#index")
    end

    it "routes to #new" do
      get("/elements/new").should route_to("elements#new")
    end

    it "routes to #show" do
      get("/elements/1").should route_to("elements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/elements/1/edit").should route_to("elements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/elements").should route_to("elements#create")
    end

    it "routes to #update" do
      put("/elements/1").should route_to("elements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/elements/1").should route_to("elements#destroy", :id => "1")
    end

  end
end
