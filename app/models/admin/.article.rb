module Admin
  class Article
    include DataMapper::Resource
    
    property :id, Serial
  
    property :position, Integer
    property :title, String
    property :content, Text
    property :link_address, String
    property :menu_element_id, Integer
    property :active, Boolean
  
  end
end # Admin
