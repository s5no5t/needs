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

describe RequirementsController do

  # This should return the minimal set of attributes required to create a valid
  # Requirement. As you add validations to Requirement, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "title" => "MyString" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RequirementsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all requirements as @requirements" do
      requirement = Requirement.create! valid_attributes
      get :index, {}, valid_session
      assigns(:requirements).should eq([requirement])
    end
  end

  describe "GET show" do
    it "assigns the requested requirement as @requirement" do
      requirement = Requirement.create! valid_attributes
      get :show, {:id => requirement.to_param}, valid_session
      assigns(:requirement).should eq(requirement)
    end
  end

  describe "GET new" do
    it "assigns a new requirement as @requirement" do
      get :new, {}, valid_session
      assigns(:requirement).should be_a_new(Requirement)
    end
  end

  describe "GET edit" do
    it "assigns the requested requirement as @requirement" do
      requirement = Requirement.create! valid_attributes
      get :edit, {:id => requirement.to_param}, valid_session
      assigns(:requirement).should eq(requirement)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Requirement" do
        expect {
          post :create, {:requirement => valid_attributes}, valid_session
        }.to change(Requirement, :count).by(1)
      end

      it "assigns a newly created requirement as @requirement" do
        post :create, {:requirement => valid_attributes}, valid_session
        assigns(:requirement).should be_a(Requirement)
        assigns(:requirement).should be_persisted
      end

      it "redirects to the created requirement" do
        post :create, {:requirement => valid_attributes}, valid_session
        response.should redirect_to(Requirement.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved requirement as @requirement" do
        # Trigger the behavior that occurs when invalid params are submitted
        Requirement.any_instance.stub(:save).and_return(false)
        post :create, {:requirement => { "title" => "invalid value" }}, valid_session
        assigns(:requirement).should be_a_new(Requirement)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Requirement.any_instance.stub(:save).and_return(false)
        post :create, {:requirement => { "title" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested requirement" do
        requirement = Requirement.create! valid_attributes
        Requirement.any_instance.should_receive(:title=).with("MyString")
        Requirement.any_instance.should_receive(:save)
        put :update, {:id => requirement.to_param, :requirement => { "title" => "MyString" }}, valid_session
      end

      it "assigns the requested requirement as @requirement" do
        requirement = Requirement.create! valid_attributes
        put :update, {:id => requirement.to_param, :requirement => valid_attributes}, valid_session
        assigns(:requirement).should eq(requirement)
      end

      it "redirects to the requirement" do
        requirement = Requirement.create! valid_attributes
        put :update, {:id => requirement.to_param, :requirement => valid_attributes}, valid_session
        response.should redirect_to(requirement)
      end
    end

    describe "with invalid params" do
      it "assigns the requirement as @requirement" do
        requirement = Requirement.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Requirement.any_instance.stub(:save).and_return(false)
        put :update, {:id => requirement.to_param, :requirement => { "title" => "invalid value" }}, valid_session
        assigns(:requirement).should eq(requirement)
      end

      it "re-renders the 'edit' template" do
        requirement = Requirement.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Requirement.any_instance.stub(:save).and_return(false)
        put :update, {:id => requirement.to_param, :requirement => { "title" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested requirement" do
      requirement = Requirement.create! valid_attributes
      expect {
        delete :destroy, {:id => requirement.to_param}, valid_session
      }.to change(Requirement, :count).by(-1)
    end

    it "redirects to the requirements list" do
      requirement = Requirement.create! valid_attributes
      delete :destroy, {:id => requirement.to_param}, valid_session
      response.should redirect_to(requirements_url)
    end
  end

end
