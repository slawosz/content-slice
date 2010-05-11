require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/content" do
  before(:each) do
    @response = request("/content")
  end
end