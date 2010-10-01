describe Sinatra::Resource do

  class BasicApp < Sinatra::Base
    register Sinatra::Resource
    resource Person

    get '/normal' do
      puts "Normal"
    end
  end

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
      get '/people/2.json'
      last_response.body.should == Person.find(2).to_json
    end

    it "creates a new person and return the JSON object" do
      len = Person.all.length
      post '/people.json', {:person => {:id => 4, :name => 'Seth'}}
      Person.all.length.should == len + 1
      last_response.body.should == Person.find(4).to_json
    end

    it "updates an existing person and returns the JSON object" do
      put '/people/3.json', {:person => {:id => 3, :name => 'Seth'}}
      Person.find(3).name.should == 'Seth'
      last_response.body.should == Person.find(3).to_json
    end

    it "deletes a record and return it's content in JSON" do
      len = Person.all.length
      delete '/people/3.json'
      last_response.body.should == ""
      Person.all.length.should == len - 1
    end

    it "fails when requesting an invalid resource" do
      get '/error'
      last_response.should_not be_ok
    end
  end

  class ActionsRemovedApp < Sinatra::Base
    register Sinatra::Resource

    helpers do
      def authorized!
        true
      end
    end

    resource Person do
      actions :all, :except => [:destroy]

      create.before do
        object.name = object.name.upcase
      end

      update.before do
        authorized!
      end
    end
  end

  describe "resource with actions removed" do
    def app
      ActionsRemovedApp
    end

    before :each do
      Person.reset!
    end

    it "errors and the records don't get altered" do
      len = Person.all.length
      delete '/people/1.json'
      last_response.should_not be_ok
      Person.all.length.should == len
    end

    it "sets the name to upper case in the before create section" do
      post '/people.json', {:person => {:id => 4, :name => 'Adam'}}
      last_response.should be_ok
      Person.find(4).name.should == 'ADAM'
    end

    it "allows calling of sinatra helpers from the actions in the resource" do
      put '/people/1.json', {:person => {:name => 'Astro'}}
      last_response.should be_ok
      Person.find(1).name.should == 'Astro'
    end
  end


  class BeforeAndAfterSetsApp < Sinatra::Base
    register Sinatra::Resource

    helpers do
      def authorized!
        true
      end
    end

    resource Person do
      before :create, :update do
        object_params[:name].upcase!
      end

      after :show, :index do
        Person.clear!
      end
    end
  end

  describe "before and after sets" do
    def app
      BeforeAndAfterSetsApp
    end

    before :each do
      Person.reset!
    end

    it "sets the same before action for create and update" do
      post '/people.json', {:person => {:id => 4, :name => 'Adam'}}
      last_response.should be_ok
      Person.find(4).name.should == 'ADAM'

      put '/people/4.json', {:person => {:id => 4, :name => 'Sandra'}}
      last_response.should be_ok
      Person.find(4).name.should == 'SANDRA'
    end

  end

  class RenderTemplateThroughResourceApp < Sinatra::Base
    register Sinatra::Resource

    resource Person do
      index.wants.html { erb '<%= 3 * 3 %>' }
    end
  end

  describe "rendering template through a resource" do
    def app
      RenderTemplateThroughResourceApp
    end

    it "displays the erb rendered output" do
      get '/people'
      last_response.body.should == '9'
    end
  end
end
