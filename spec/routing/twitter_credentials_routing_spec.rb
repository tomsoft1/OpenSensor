require "spec_helper"

describe TwitterCredentialsController do
  describe "routing" do

    it "routes to #index" do
      get("/twitter_credentials").should route_to("twitter_credentials#index")
    end

    it "routes to #new" do
      get("/twitter_credentials/new").should route_to("twitter_credentials#new")
    end

    it "routes to #show" do
      get("/twitter_credentials/1").should route_to("twitter_credentials#show", :id => "1")
    end

    it "routes to #edit" do
      get("/twitter_credentials/1/edit").should route_to("twitter_credentials#edit", :id => "1")
    end

    it "routes to #create" do
      post("/twitter_credentials").should route_to("twitter_credentials#create")
    end

    it "routes to #update" do
      put("/twitter_credentials/1").should route_to("twitter_credentials#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/twitter_credentials/1").should route_to("twitter_credentials#destroy", :id => "1")
    end

  end
end
