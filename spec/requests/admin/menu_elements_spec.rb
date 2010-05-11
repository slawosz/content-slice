require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

given "a menu_element exists" do
  MenuElement.all.destroy!
  request(resource(:menu_elements), :method => "POST", 
    :params => { :menu_element => { :id => nil }})
end

describe "resource(:menu_elements)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:menu_elements))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of menu_elements" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a menu_element exists" do
    before(:each) do
      @response = request(resource(:menu_elements))
    end
    
    it "has a list of menu_elements" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      MenuElement.all.destroy!
      @response = request(resource(:menu_elements), :method => "POST", 
        :params => { :menu_element => { :id => nil }})
    end
    
    it "redirects to resource(:menu_elements)" do
      @response.should redirect_to(resource(MenuElement.first), :message => {:notice => "menu_element was successfully created"})
    end
    
  end
end

describe "resource(@menu_element)" do 
  describe "a successful DELETE", :given => "a menu_element exists" do
     before(:each) do
       @response = request(resource(MenuElement.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:menu_elements))
     end

   end
end

describe "resource(:menu_elements, :new)" do
  before(:each) do
    @response = request(resource(:menu_elements, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@menu_element, :edit)", :given => "a menu_element exists" do
  before(:each) do
    @response = request(resource(MenuElement.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@menu_element)", :given => "a menu_element exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(MenuElement.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @menu_element = MenuElement.first
      @response = request(resource(@menu_element), :method => "PUT", 
        :params => { :menu_element => {:id => @menu_element.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@menu_element))
    end
  end
  
end

