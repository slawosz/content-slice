class ContentSlice::Content < ContentSlice::Application


  def show
    menu_element = MenuElement.get(params[:id].to_i)
    @article = menu_element.article
    
    @title = menu_element.name 
    @gallery = menu_element.gallery
    unless @gallery.blank?
      @photos = @gallery.photos.all( :order => [:position.asc] )
    end
    @description = menu_element.description
    render
  end
  
end
