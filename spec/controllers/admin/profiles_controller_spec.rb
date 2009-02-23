require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ProfilesController do
  dataset :users

  integrate_views

  before(:each) do
    login_as :existing
    @profile = mock(StaffProfile, :null_object => true)
  end

  context 'index' do
    before(:each) do
      StaffProfile.stub!(:find).and_return(@profiles = [@profile])
    end

    it 'should render the index template' do
      get 'index'
      response.should be_success
      response.should render_template('index')
    end
  end

  context 'new' do
    it 'should render the edit template' do
      get 'new'
      response.should be_success
      response.should render_template('edit')
    end
  end

  context 'create' do
    before(:each) do
      StaffProfile.stub!(:new).and_return(@profile)
    end

    it 'should create a new profile and redirect' do
      @profile.should_receive(:save).and_return(true)
      post 'create', :profile => { :first_name => 'new name' }
      response.should be_redirect
      response.should redirect_to(admin_profiles_path)
    end

    it 'should re-render the edit template if save fails' do
      @profile.should_receive(:save).and_return(false)
      post 'create', :profile => { :first_name => 'new name' }
      response.should be_success
      response.should render_template('edit')
      flash[:error].should_not be_nil
    end
  end

  context 'edit' do
    before(:each) do
      StaffProfile.stub!(:find).and_return(@profile)
    end

    it 'should render the edit template' do
      get 'edit', :id => 1
      response.should be_success
      response.should render_template('edit')
    end
  end

  context 'update' do
    before(:each) do
      StaffProfile.stub!(:find).and_return(@profile)
    end

    it 'should update the program and redirect' do
      @profile.should_receive(:update_attributes).and_return(true)
      put 'update', :id => 1, :profile => { :first_name => 'new name' }
      response.should be_redirect
      response.should redirect_to(admin_profiles_path)
    end

    it 'should re-render the edit template if update fails' do
      @profile.should_receive(:update_attributes).and_return(false)
      put 'update', :id => 1, :profile => { :first_name => 'new name' }
      response.should be_success
      response.should render_template('edit')
      flash[:error].should_not be_nil
    end
  end

  context 'destroy' do
    before(:each) do 
      StaffProfile.stub!(:find).and_return(@profile)
    end

    it 'should destroy the program and redirect' do
      @profile.should_receive(:destroy).and_return(true)
      delete 'destroy', :id => 1
      response.should be_redirect
      response.should redirect_to(admin_profiles_path)
    end
  end
end
