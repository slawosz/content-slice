class NewsPage
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
  property :created_on, Date

  property :created_at, DateTime
  property :updated_at, DateTime
  property :language, String

end
