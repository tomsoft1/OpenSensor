require 'spec_helper'

describe "ElementPrototypes" do
  describe "GET /element_prototypes" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get element_prototypes_path
      response.status.should be(200)
    end
  end
end
