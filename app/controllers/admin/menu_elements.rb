module ContentSlice::Admin
  class MenuElements < Base
    # provides :xml, :yaml, :js
  
    def index
      @menu = Menu.get(params[:menu_id])
      @menu_elements = @menu.menu_elements.all( :order => [:position.asc])
      display @menu_elements
    end
  
    def show(id)
      @menu_element = MenuElement.get(id)
      raise NotFound unless @menu_element
      display @menu_element
    end
  
    def new
      only_provides :html
      @menu = Menu.get params[:menu_id]
      @menu_element = MenuElement.new
      @menu_element.menu_id = params[:menu_id]
      display @menu_element
    end
  
    def edit(id)
      only_provides :html
      @articles = Article.all
      @galleries = Gallery.all
      @menu = Menu.get params[:menu_id]
      @menu_element = MenuElement.get(id)
      raise NotFound unless @menu_element
      display @menu_element
    end
  
    def create(menu_element)
      @menu = Menu.get params[:menu_id]
      @menu_element = MenuElement.new(menu_element)
      position = @menu.menu_elements.length + 1
      @menu_element.position = position
      if @menu_element.save
        redirect slice_url(:admin_menu_menu_elements, params[:language], @menu.id), :message => {:notice => "Nowy element menu został dodany"}
      else
        message[:error] = "Błąd przy dodawaniu elementu menu"
        render :new
      end
    end
  
    def update(id, menu_element)
      @menu = Menu.get params[:menu_id]
      @menu_element = MenuElement.get(id)
      raise NotFound unless @menu_element
      if @menu_element.update_attributes(menu_element)
         redirect slice_url(:admin_menu_menu_elements, params[:language], @menu.id)
      else
        display @menu_element, :edit
      end
    end
  
    def destroy(id)
      @menu = Menu.get params[:menu_id]
      @menu_element = MenuElement.get(id)
      raise NotFound unless @menu_element
      if @menu_element.destroy
        redirect slice_url(:admin_menu_menu_elements, params[:language], @menu), :message => { :notice => "Usunięcie powiodło się" }

      else
        raise InternalServerError
      end
    end
    def order
      pages = params[:menu_elements].map {|page| page.blank? ? nil : page.to_i}.compact
      position = 1
      pages.each do |p|
        menu = MenuElement.get(p)
        menu.position = position
        menu.save
        position += 1
      end
      
      render :nothing
    end

  
  end # MenuElements
end # Admin
