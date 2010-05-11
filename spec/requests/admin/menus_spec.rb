require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

given "a menu exists" do
  Menu.all.destroy!
  request(resource(:menus), :method => "POST", 
    :params => { :menu => { :id => nil }})
end

describe "resource(:menus)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:menus))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of menus" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a menu exists" do
    before(:each) do
      @response = request(resource(:menus))
    end
    
    it "has a list of menus" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Menu.all.destroy!
      @response = request(resource(:menus), :method => "POST", 
        :params => { :menu => { :id => nil }})
    end
    
    it "redirects to resource(:menus)" do
      @response.should redirect_to(resource(Menu.first), :message => {:notice => "menu was successfully created"})
    end
    
  end
end

describe "resource(@menu)" do 
  describe "a successful DELETE", :given => "a menu exists" do
     before(:each) do
       @response = request(resource(Menu.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:menus))
     end

   end
end

describe "resource(:menus, :new)" do
  before(:each) do
    @response = request(resource(:menus, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@menu, :edit)", :given => "a menu exists" do
  before(:each) do
    @response = request(resource(Menu.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@menu)", :given => "a menu exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Menu.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @menu = Menu.first
      @response = request(resource(@menu), :method => "PUT", 
        :params => { :menu => {:id => @menu.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@menu))
    end
  end
  
end

