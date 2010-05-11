class Article
  include DataMapper::Resource
  
  property :id, Serial

  property :position, Integer
  property :title, String
  property :preface, Text
  property :content, Text
  property :link_address, String
  property :menu_element_id, Integer
  property :active, TrueClass
  property :description, String
  property :language, String
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :menu_elements
end
