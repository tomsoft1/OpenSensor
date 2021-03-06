require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe DashoboardsController do

  # This should return the minimal set of attributes required to create a valid
  # Dashoboard. As you add validations to Dashoboard, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DashoboardsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all dashoboards as @dashoboards" do
      dashoboard = Dashoboard.create! valid_attributes
      get :index, {}, valid_session
      assigns(:dashoboards).should eq([dashoboard])
    end
  end

  describe "GET show" do
    it "assigns the requested dashoboard as @dashoboard" do
      dashoboard = Dashoboard.create! valid_attributes
      get :show, {:id => dashoboard.to_param}, valid_session
      assigns(:dashoboard).should eq(dashoboard)
    end
  end

  describe "GET new" do
    it "assigns a new dashoboard as @dashoboard" do
      get :new, {}, valid_session
      assigns(:dashoboard).should be_a_new(Dashoboard)
    end
  end

  describe "GET edit" do
    it "assigns the requested dashoboard as @dashoboard" do
      dashoboard = Dashoboard.create! valid_attributes
      get :edit, {:id => dashoboard.to_param}, valid_session
      assigns(:dashoboard).should eq(dashoboard)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Dashoboard" do
        expect {
          post :create, {:dashoboard => valid_attributes}, valid_session
        }.to change(Dashoboard, :count).by(1)
      end

      it "assigns a newly created dashoboard as @dashoboard" do
        post :create, {:dashoboard => valid_attributes}, valid_session
        assigns(:dashoboard).should be_a(Dashoboard)
        assigns(:dashoboard).should be_persisted
      end

      it "redirects to the created dashoboard" do
        post :create, {:dashoboard => valid_attributes}, valid_session
        response.should redirect_to(Dashoboard.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved dashoboard as @dashoboard" do
        # Trigger the behavior that occurs when invalid params are submitted
        Dashoboard.any_instance.stub(:save).and_return(false)
        post :create, {:dashoboard => { "name" => "invalid value" }}, valid_session
        assigns(:dashoboard).should be_a_new(Dashoboard)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Dashoboard.any_instance.stub(:save).and_return(false)
        post :create, {:dashoboard => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested dashoboard" do
        dashoboard = Dashoboard.create! valid_attributes
        # Assuming there are no other dashoboards in the database, this
        # specifies that the Dashoboard created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Dashoboard.any_instance.should_receive(:update_attributes).with({ "name" => "" })
        put :update, {:id => dashoboard.to_param, :dashoboard => { "name" => "" }}, valid_session
      end

      it "assigns the requested dashoboard as @dashoboard" do
        dashoboard = Dashoboard.create! valid_attributes
        put :update, {:id => dashoboard.to_param, :dashoboard => valid_attributes}, valid_session
        assigns(:dashoboard).should eq(dashoboard)
      end

      it "redirects to the dashoboard" do
        dashoboard = Dashoboard.create! valid_attributes
        put :update, {:id => dashoboard.to_param, :dashoboard => valid_attributes}, valid_session
        response.should redirect_to(dashoboard)
      end
    end

    describe "with invalid params" do
      it "assigns the dashoboard as @dashoboard" do
        dashoboard = Dashoboard.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Dashoboard.any_instance.stub(:save).and_return(false)
        put :update, {:id => dashoboard.to_param, :dashoboard => { "name" => "invalid value" }}, valid_session
        assigns(:dashoboard).should eq(dashoboard)
      end

      it "re-renders the 'edit' template" do
        dashoboard = Dashoboard.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Dashoboard.any_instance.stub(:save).and_return(false)
        put :update, {:id => dashoboard.to_param, :dashoboard => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested dashoboard" do
      dashoboard = Dashoboard.create! valid_attributes
      expect {
        delete :destroy, {:id => dashoboard.to_param}, valid_session
      }.to change(Dashoboard, :count).by(-1)
    end

    it "redirects to the dashoboards list" do
      dashoboard = Dashoboard.create! valid_attributes
      delete :destroy, {:id => dashoboard.to_param}, valid_session
      response.should redirect_to(dashoboards_url)
    end
  end

end
