module ContentSlice::Admin
  class Menus < Base
    # provides :xml, :yaml, :js
  
    def index
      @menus = Menu.all
      display @menus
    end
  
    def show(id)
      @menu = Menu.get(id)
      raise NotFound unless @menu
      display @menu
    end
  
    def new
      only_provides :html
      @menu = Menu.new
      display @menu
    end
  
    def edit(id)
      only_provides :html
      @menu = Menu.get(id)
      raise NotFound unless @menu
      display @menu
    end
  
    def create(menu)
      @menu = Menu.new(menu)
      if @menu.save
        redirect slice_url(:admin_menus), :message => {:notice => "Menu was successfully created"}
      else
        message[:error] = "Menu failed to be created"
        render :new
      end
    end
  
    def update(id, menu)
      @menu = Menu.get(id)
      raise NotFound unless @menu
      if @menu.update_attributes(menu)
         redirect slice_url(:admin_menus)
      else
        display @menu, :edit
      end
    end
  
    def destroy(id)
      @menu = Menu.get(id)
      raise NotFound unless @menu
      if @menu.destroy
        redirect slice_url(:admin_menus)
      else
        raise InternalServerError
      end
    end
  
  end # Menus
end # Admin
