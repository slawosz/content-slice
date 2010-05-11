class Menu
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :active, TrueClass
  property :levels_count, Integer
  property :language, String

  property :created_at, DateTime
  property :updated_at, DateTime
  has n, :menu_elements
end
