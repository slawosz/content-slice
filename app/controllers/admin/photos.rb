module ContentSlice::Admin
  class Photos < Base
    # provides :xml, :yaml, :js
  
    def index
      @photos = Photo.all
      display @photos
    end
  
    def show(id)
      @photo = Photo.get(id)
      raise NotFound unless @photo
      display @photo
    end
  
    def new
      only_provides :html
      @photo = Photo.new
      display @photo
    end
  
    def edit(id)
      only_provides :html
      @photo = Photo.get(id)
      @gallery = Gallery.get(params[:gallery_id])
      @photo.title = @photo.get_description(params[:language])
      raise NotFound unless @photo
      display @photo
    end
  
    def create(photo)
      @photo = Photo.new(photo)
      p photo.inspect
      p "\nzuo"
      if @photo.save
        @photo.edit_description(params[:language], @photo.title)
        redirect resource(@photo), :message => {:notice => "Photo was successfully created"}
      else
        message[:error] = "Photo failed to be created"
        render :new
      end
    end
  
    def update(id, photo)
      @photo = Photo.get(id)
      raise NotFound unless @photo
      if @photo.update_attributes(photo)
        @photo.edit_description(params[:language], @photo.title)
        redirect slice_url(:edit_admin_gallery, params[:language], @photo.gallery), :message => { :notice => "Informacje o zdjęciu zostały zapisane" }
      else
        display @photo, :edit
      end
    end
  
    def destroy(id)
      @photo = Photo.get(id)
      gallery = Gallery.get(params[:gallery_id])
      raise NotFound unless @photo
      if @photo.destroy
        redirect slice_url(:edit_admin_gallery, params[:language], gallery), :message => { :notice => "Zdjęcie zostało usunięte" }
      else
        raise InternalServerError
      end
    end
  
  end # Photos
end # Admin
