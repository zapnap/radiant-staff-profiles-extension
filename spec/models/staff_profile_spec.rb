require File.dirname(__FILE__) + '/../spec_helper'

describe StaffProfile do
  TEST_FILE = RAILS_ROOT + '/public/images/admin/page.png'

  before(:each) do
    @profile = StaffProfile.new(valid_attributes)
    @uploaded_file = ActionController::TestUploadedFile.new(TEST_FILE,'image/jpeg')
    @profile.photo = @uploaded_file
  end

  it "should be valid" do
    @profile.should be_valid
  end

  context "validations" do
    it "should require a first name" do
      @profile.first_name = nil
      @profile.should_not be_valid
      @profile.errors.on(:first_name).should == "can't be blank"
    end

    it "should require a last name" do
      @profile.last_name = nil
      @profile.should_not be_valid
      @profile.errors.on(:last_name).should == "can't be blank"
    end

    #it "should have a valid attachment" do
    #  @profile.photo = nil
    #  @profile.should_not be_valid
    #  @profile.errors.on(:photo).should == "must be set."
    #end

    it "should check content type of attachment" do
      @profile.photo = ActionController::TestUploadedFile.new(TEST_FILE, 'application/pdf')
      @profile.should_not be_valid
      @profile.errors.on(:photo).should == "is not one of the allowed file types."
    end
  end

  it "should have return the profile status" do
    Status.should_receive(:find).with(@profile.status_id).and_return(status = mock_model(Status))
    @profile.status.should == status
  end

  it "should set the profile status" do
    status = mock_model(Status, :id => 100)
    @profile.status = status
    @profile.status_id.should == status.id
  end

  it "should return the full name" do
    @profile.full_name.should == "Hank McCoy"
  end

  it "should filter the biography as Textile" do
    TextileFilter.should_receive(:filter).with(@profile.biography).and_return('filtered text')
    @profile.filtered_biography
  end

  private

  def valid_attributes
    { :first_name => 'Hank',
      :last_name  => 'McCoy' }
  end
end
