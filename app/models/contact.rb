class Contact
  include DataMapper::Resource
  
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :email,      String
  property :topic,      String
  property :name,       String
  property :surname,    String
  property :phone,      String
  property :text,       Text 
  property :created_at, DateTime
  property :updated_at, DateTime

end
