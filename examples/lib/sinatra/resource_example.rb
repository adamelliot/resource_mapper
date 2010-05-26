class BasicApp < Sinatra::Base
  register Sinatra::Resource
  resource Person

  get '/normal' do
    puts "Normal"
  end
end

class CustomApp < Sinatra::Base
  register Sinatra::Resource
  resource Person do
    actions :all, :except => [:destroy, :update]
  end
end

describe Sinatra::Resource do
  
  describe "basic resource" do
    def app
      BasicApp
    end
    
    before :each do
      Person.reset!
    end

    it "returns all people in JSON" do
      get '/people.json'
      last_response.body.should == Person.all.to_json
    end
    
    it "returns a specific person as a JSON object" do
      get '/person/2.json'
      last_response.body.should == Person.find(2).to_json
    end
    
    it "creates a new person and return the JSON object" do
      len = Person.all.length
      post '/person.json', {:person => {:id => 4, :name => 'Seth'}}
      Person.all.length.should == len + 1
      last_response.body.should == Person.find(4).to_json
    end

    it "updates an existing person and returns the JSON object" do
      put '/person/3.json', {:person => {:id => 3, :name => 'Seth'}}
      Person.find(3).name.should == 'Seth'
      last_response.body.should == Person.find(3).to_json
    end
    
    it "deletes a record and return it's content in JSON" do
      len = Person.all.length
      delete '/person/3.json'
      last_response.body.should == ""
      Person.all.length.should == len - 1
    end
    
    it "fails when requesting an invalid resource" do
      get '/error'
      last_response.should_not be_ok
    end
  end

  describe "resource with actions removed" do
    def app
      CustomApp
    end

    before :each do
      Person.reset!
    end

    it "errors and the records don't get altered" do
      len = Person.all.length
      delete '/person/1.json'
      last_response.should_not be_ok
      Person.all.length.should == len
    end

    it "errors on request" do
      get '/normal'
    end

  end

end
