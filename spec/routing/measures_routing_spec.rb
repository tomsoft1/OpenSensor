require "spec_helper"

describe MeasuresController do
  describe "routing" do

    it "routes to #index" do
      get("/measures").should route_to("measures#index")
    end

    it "routes to #new" do
      get("/measures/new").should route_to("measures#new")
    end

    it "routes to #show" do
      get("/measures/1").should route_to("measures#show", :id => "1")
    end

    it "routes to #edit" do
      get("/measures/1/edit").should route_to("measures#edit", :id => "1")
    end

    it "routes to #create" do
      post("/measures").should route_to("measures#create")
    end

    it "routes to #update" do
      put("/measures/1").should route_to("measures#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/measures/1").should route_to("measures#destroy", :id => "1")
    end

  end
end
