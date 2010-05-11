class Option
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :value, TrueClass
  property :description, String 
  property :created_at, DateTime
  property :updated_at, DateTime

end
