describe Sinatra::Resource do
  
  describe "basic resource" do
    before :each do
      mock_app {
        register Sinatra::Resource
        resource Person
      }
    end

    it "returns all people in JSON" do
      get '/people'
      last_response.body.should == Person.all.to_json
      last_response.should be_ok
    end
  end

end
