class PhotoDescription
  include DataMapper::Resource
  
  property :id, Serial
  property :photo_id, Integer
  property :description, String
  property :language, String

  property :created_at, DateTime
  property :updated_at, DateTime
  belongs_to :photo

end
