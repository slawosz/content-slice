class Gallery
  include DataMapper::Resource
  property :id,          Serial
  property :name,       String
  property :description, Text
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  has n, :photos
  has n, :menu_elements

  validates_present :name

  def add_photos(photos)
    position = self.photos.length
    photos.each do |v|
      position += 1
      Photo.create(:file => v, :gallery_id => self.id, :position => position ) unless v.blank?
      p "\n\n"
      p "dodano zdjęcie #{v.inspect}"
      p "\n\n"
    end
  end

end
