require File.dirname(__FILE__) + '/../service'
require 'rspec'
require 'rack/test'

set :environment, :test
# including Rack::Test::Methods gives us get, post. etc,.
RSpec.configure { |config| config.include Rack::Test::Methods }

def app
  Sinatra::Application
end

describe "service" do
  before(:each) do
    User.delete_all
  end

  describe "GET on /api/v1/user/:id" do
    before(:each) do
      User.create(name: "iain",
                  email: "iain@gmail.com",
                  password: "strongpass",
                  bio: "rubyist")
    end

    it "should return a user by name" do
      get '/api/v1/users/iain'
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["user"]["name"].should == "iain"
    end

    it "should return a user with an email" do
      get '/api/v1/users/iain'
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["user"]["email"].should == "iain@gmail.com"
    end
    it "should no return a users password" do
      get '/api/v1/users/iain'
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes.should_not have_key("password")
    end

    it "should return a user with a bio" do
      get '/api/v1/users/iain'
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["user"]["bio"].should == "rubyist"
    end

    it "should return a 404 for a user that doesn't exist" do
      get '/api/v1/users/foo'
      last_response.status.should == 404
    end

  end

  describe "POST on /api/v1/users" do

    it "should create a user" do
      post '/api/v1/users', {
        name:     "trotter",
        email:    "no spam",
        password: "whatever",
        bio:      "southern belle"}.to_json

        last_response.should be_ok

        get '/api/v1/users/trotter'

        attributes = JSON.parse(last_response.body)
        attributes["user"]["name"].should   eq "trotter"
        attributes["user"]["email"].should  eq "no spam"
        attributes["user"]["bio"].should    eq "southern belle"
    end
  end

  describe "PUT on /api/v1/users/:id" do

    before(:each) do
      User.create(name:     "bryan",
                  email:    "no spam",
                  password: "whatever",
                  bio:      "rspec master")
    end

    it "should update a user" do
      put '/api/v1/users/bryan', {
          bio: "testing freak"}.to_json

        last_response.should be_ok

        get '/api/v1/users/bryan'

        attributes = JSON.parse(last_response.body)
        attributes["user"]["bio"].should eq "testing freak"
    end
  end

  describe "DELETE on /api/v1/users/:id" do

    before(:each) do
      User.create(name:     "francis",
                  email:    "no spam",
                  password: "whatever",
                  bio:      "williamsburg hipster")
    end

    it "should delete a user" do
      delete '/api/v1/users/francis'

      last_response.should be_ok

      get '/api/v1/users/francis'

      last_response.status.should eq 404
    end
  end

  describe "POST on /api/v1/users/:id/sessions" do

    before(:each) do
      User.create(name:     "josh",
                  password: "nyc.rb rules")
    end

    it "should return the user object on valid credentials" do
      post '/api/v1/users/josh/sessions', {password: "nyc.rb rules"}.to_json

      last_response.should be_ok

      attributes = JSON.parse(last_response.body)
      attributes["user"]["name"].should eq "josh"
    end

    it "should fail on invalid credentials" do
      post '/api/v1/users/josh/sessions', {password: "wrong"}.to_json

      last_response.status.should eq 400
    end
  end
end