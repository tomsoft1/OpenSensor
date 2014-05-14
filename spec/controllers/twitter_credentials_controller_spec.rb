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

describe TwitterCredentialsController do

  # This should return the minimal set of attributes required to create a valid
  # TwitterCredential. As you add validations to TwitterCredential, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "screen_name" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TwitterCredentialsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all twitter_credentials as @twitter_credentials" do
      twitter_credential = TwitterCredential.create! valid_attributes
      get :index, {}, valid_session
      assigns(:twitter_credentials).should eq([twitter_credential])
    end
  end

  describe "GET show" do
    it "assigns the requested twitter_credential as @twitter_credential" do
      twitter_credential = TwitterCredential.create! valid_attributes
      get :show, {:id => twitter_credential.to_param}, valid_session
      assigns(:twitter_credential).should eq(twitter_credential)
    end
  end

  describe "GET new" do
    it "assigns a new twitter_credential as @twitter_credential" do
      get :new, {}, valid_session
      assigns(:twitter_credential).should be_a_new(TwitterCredential)
    end
  end

  describe "GET edit" do
    it "assigns the requested twitter_credential as @twitter_credential" do
      twitter_credential = TwitterCredential.create! valid_attributes
      get :edit, {:id => twitter_credential.to_param}, valid_session
      assigns(:twitter_credential).should eq(twitter_credential)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TwitterCredential" do
        expect {
          post :create, {:twitter_credential => valid_attributes}, valid_session
        }.to change(TwitterCredential, :count).by(1)
      end

      it "assigns a newly created twitter_credential as @twitter_credential" do
        post :create, {:twitter_credential => valid_attributes}, valid_session
        assigns(:twitter_credential).should be_a(TwitterCredential)
        assigns(:twitter_credential).should be_persisted
      end

      it "redirects to the created twitter_credential" do
        post :create, {:twitter_credential => valid_attributes}, valid_session
        response.should redirect_to(TwitterCredential.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved twitter_credential as @twitter_credential" do
        # Trigger the behavior that occurs when invalid params are submitted
        TwitterCredential.any_instance.stub(:save).and_return(false)
        post :create, {:twitter_credential => { "screen_name" => "invalid value" }}, valid_session
        assigns(:twitter_credential).should be_a_new(TwitterCredential)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TwitterCredential.any_instance.stub(:save).and_return(false)
        post :create, {:twitter_credential => { "screen_name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested twitter_credential" do
        twitter_credential = TwitterCredential.create! valid_attributes
        # Assuming there are no other twitter_credentials in the database, this
        # specifies that the TwitterCredential created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        TwitterCredential.any_instance.should_receive(:update_attributes).with({ "screen_name" => "" })
        put :update, {:id => twitter_credential.to_param, :twitter_credential => { "screen_name" => "" }}, valid_session
      end

      it "assigns the requested twitter_credential as @twitter_credential" do
        twitter_credential = TwitterCredential.create! valid_attributes
        put :update, {:id => twitter_credential.to_param, :twitter_credential => valid_attributes}, valid_session
        assigns(:twitter_credential).should eq(twitter_credential)
      end

      it "redirects to the twitter_credential" do
        twitter_credential = TwitterCredential.create! valid_attributes
        put :update, {:id => twitter_credential.to_param, :twitter_credential => valid_attributes}, valid_session
        response.should redirect_to(twitter_credential)
      end
    end

    describe "with invalid params" do
      it "assigns the twitter_credential as @twitter_credential" do
        twitter_credential = TwitterCredential.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TwitterCredential.any_instance.stub(:save).and_return(false)
        put :update, {:id => twitter_credential.to_param, :twitter_credential => { "screen_name" => "invalid value" }}, valid_session
        assigns(:twitter_credential).should eq(twitter_credential)
      end

      it "re-renders the 'edit' template" do
        twitter_credential = TwitterCredential.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TwitterCredential.any_instance.stub(:save).and_return(false)
        put :update, {:id => twitter_credential.to_param, :twitter_credential => { "screen_name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested twitter_credential" do
      twitter_credential = TwitterCredential.create! valid_attributes
      expect {
        delete :destroy, {:id => twitter_credential.to_param}, valid_session
      }.to change(TwitterCredential, :count).by(-1)
    end

    it "redirects to the twitter_credentials list" do
      twitter_credential = TwitterCredential.create! valid_attributes
      delete :destroy, {:id => twitter_credential.to_param}, valid_session
      response.should redirect_to(twitter_credentials_url)
    end
  end

end