module ContentSlice::Admin
  class Galleries < Base
    # provides :xml, :yaml, :js
  
    def index
      @galleries = Gallery.all
      display @galleries
    end
  
    def show(id)
      @gallery = Gallery.get(id)
      raise NotFound unless @gallery
      display @gallery
    end
  
    def new
      only_provides :html
      @gallery = Gallery.new
      display @gallery
    end
  
    def edit(id)
      only_provides :html
      @gallery = Gallery.get(id)
      @photos = @gallery.photos.all( :order => [:position.asc] )
      raise NotFound unless @gallery
      display @gallery
    end
  
    def create(gallery)
      @gallery = Gallery.new(gallery)
      if @gallery.save
        redirect slice_url(:edit_admin_gallery, params[:language], @gallery), :message => {:notice => "Galeria została dodana. Dodaj zdjęcia do galerii."}
      else
        message[:error] = "Błąd przy dodawaniu galerii."
        render :new
      end
    end
  
    def update(id, gallery)
      @gallery = Gallery.get(id)
      raise NotFound unless @gallery
      if @gallery.update_attributes(gallery)
         @gallery.add_photos(params[:photos])
         redirect slice_url(:edit_admin_gallery, params[:language], @gallery), :message => {:notice => "Galeria została uaktualniona."}
      else
        message[:error] = "Błąd przy edycji galerii."
        display @gallery, :edit
      end
    end
  
    def destroy(id)
      @gallery = Gallery.get(id)
      raise NotFound unless @gallery
      if @gallery.destroy
        redirect slice_url(:admin_galleries), :message => { :notice => "Usunięcie powiodło się" }

      else
        raise InternalServerError
      end
    end

    def order
      only_provides :js
      #pages = params[:photo].map {|page| page.blank? ? nil : page }.compact
      position = 1
      #raise params[:photo]
      params[:photo].each do |p|
        photo = Photo.get(p)
        photo.position = position
        photo.save
        position += 1
      end

      #display nil# :layout => false
    #rescue
    end
  
  end # Galleries
end # Admin
