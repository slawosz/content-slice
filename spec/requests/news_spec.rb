require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/news" do
  before(:each) do
    @response = request("/news")
  end
end