class Language
  include DataMapper::Resource
  
  property :id, Serial
  property :code, String
  property :polish_name, String
  property :name, String
  property :created_at, DateTime
  property :updated_at, DateTime


end
