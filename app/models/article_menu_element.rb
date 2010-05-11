class ArticleMenuElement
  include DataMapper::Resource
  
  property :id, Serial
  property :article_id, Integer
  property :menu_element_id, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

end
