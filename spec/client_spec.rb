require 'active_record'
require_relative '../client'

describe "client" do
  before(:each) do
    User.base_uri = "http://localhost:3000"
  end

  it "should get a user" do
    user = User.find_by_name("iain")
    user["user"]["name"].should == "iain"
    user["user"]["email"].should == "iain@iainmcnulty.com"
    user["user"]["bio"].should == "rubyist"
  end

  it "should return nil for a user not found" do
    User.find_by_name("joe").should be_nil
  end
end