require "spec_helper"

describe WidgetsController do
  describe "routing" do

    it "routes to #index" do
      get("/widgets").should route_to("widgets#index")
    end

    it "routes to #new" do
      get("/widgets/new").should route_to("widgets#new")
    end

    it "routes to #show" do
      get("/widgets/1").should route_to("widgets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/widgets/1/edit").should route_to("widgets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/widgets").should route_to("widgets#create")
    end

    it "routes to #update" do
      put("/widgets/1").should route_to("widgets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/widgets/1").should route_to("widgets#destroy", :id => "1")
    end

  end
end
