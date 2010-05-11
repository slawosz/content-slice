class MenuElement
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :active, TrueClass
  property :is_link, Boolean, :default => false
  property :url, String
  property :position, Integer
  property :description, String
  property :menu_id, Integer
  property :article_id, Integer 
  property :gallery_id, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :menu
  belongs_to :article
  belongs_to :gallery

  def to_param
    "#{id}-abc"
  end
end
