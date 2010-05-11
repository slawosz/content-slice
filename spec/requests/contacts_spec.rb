require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a contact exists" do
  Contact.all.destroy!
  request(resource(:contacts), :method => "POST", 
    :params => { :contact => { :id => nil }})
end

describe "resource(:contacts)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:contacts))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of contacts" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a contact exists" do
    before(:each) do
      @response = request(resource(:contacts))
    end
    
    it "has a list of contacts" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Contact.all.destroy!
      @response = request(resource(:contacts), :method => "POST", 
        :params => { :contact => { :id => nil }})
    end
    
    it "redirects to resource(:contacts)" do
      @response.should redirect_to(resource(Contact.first), :message => {:notice => "contact was successfully created"})
    end
    
  end
end

describe "resource(@contact)" do 
  describe "a successful DELETE", :given => "a contact exists" do
     before(:each) do
       @response = request(resource(Contact.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:contacts))
     end

   end
end

describe "resource(:contacts, :new)" do
  before(:each) do
    @response = request(resource(:contacts, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@contact, :edit)", :given => "a contact exists" do
  before(:each) do
    @response = request(resource(Contact.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@contact)", :given => "a contact exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Contact.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @contact = Contact.first
      @response = request(resource(@contact), :method => "PUT", 
        :params => { :contact => {:id => @contact.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@contact))
    end
  end
  
end

