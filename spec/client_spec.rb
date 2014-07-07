require_relative '../client'

describe "client" do
  before(:each) do
    User.base_uri = "http://localhost:3000"
  end

  describe "Finding a User" do

    it "should get a user" do
      user = User.find_by_name("iain")
      user["user"]["name"].should  == "iain"
      user["user"]["email"].should == "iain@iainmcnulty.com"
      user["user"]["bio"].should   == "rubyist"
    end

    it "should return nil for a user not found" do
      User.find_by_name("joe").should be_nil
    end
  end

  describe "Creating a User" do
    it "should create a user" do
      user = User.create(
            name: "trotter",
            email: "no spam",
            password: "whatev")
      user["user"]["name"].should         == "trotter"
      user["user"]["email"].should        == "no spam"
      User.find_by_name("trotter").should == user
    end
  end

  describe "Updating a User" do
    it "should update a user" do
      user = User.update("iain",
            bio: "rubyist and coffee drinker")
      user["user"]["name"].should         == "iain"
      user["user"]["bio"].should        == "rubyist and coffee drinker"
      User.find_by_name("iain").should == user
    end
  end
end