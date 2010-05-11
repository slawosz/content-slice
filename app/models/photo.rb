class Photo
  include DataMapper::Resource
  include Paperclip::Resource
  
  property :id, Serial
  property :file_file_name, String
  property :file_content_type, String
  property :file_file_size, Integer
  property :file_updated_at, DateTime
  property :gallery_id, Integer
  property :title, String
  property :description, Text
  property :position, Integer
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has_attached_file :file, :styles => { :huge => "800x800>", :big => "600x600>", :medium => "300x300>", :small => "150x150>", :thumb => "100x100>", :tiny => "50>x50>" }

  belongs_to :gallery
  has n, :photo_descriptions

  #returns photo descriiption in lang #{lang}
  #if none, method creates blank description
  def get_description(lang)
    desc = Photo.get(self.id).photo_descriptions.first( :language => lang ).description
    if desc == nil
      desc = ""
    else
      return desc
    end
  rescue
    desc = self.photo_descriptions.create( :language => lang, :description => "" )
    ""
  end

  def edit_description(lang,desc)
    photo_description = self.photo_descriptions.first( :language => lang )
    photo_description.description = desc
    photo_description.save
  end

  def has_description?(lang)
    desc = self.photo_descriptions.first( :language => lang ).description
    !desc.blank?
  rescue
    self.photo_descriptions.create( :language => lang, :description => "" )
  end

end
