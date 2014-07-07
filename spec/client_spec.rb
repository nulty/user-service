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

  describe "Destroying a User" do
    it "should destroy a user" do
      user = User.destroy("bryan").should == true
      User.find_by_name("bryan").should be_nil
    end
  end

  describe "Destroying a User" do
    it "should verify login credentials" do
      user = User.login("iain", "strongpass")
      user["user"]["name"].should eq "iain"
    end

    it "should return nil with invalid credentials" do
      User.login("iain", "wrongpass").should be_nil
    end
  end
end