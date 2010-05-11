module ContentSlice::Admin
  class Options < Base
    # provides :xml, :yaml, :js
  
    def index
      @options = Option.all
      display @options
    end
  
    def show(id)
      @option = Option.get(id)
      raise NotFound unless @option
      display @option
    end
  
    def new
      only_provides :html
      @option = Option.new
      display @option
    end
  
    def edit(id)
      only_provides :html
      @option = Option.get(id)
      raise NotFound unless @option
      display @option
    end
  
    def create(option)
      @option = Option.new(option)
      if @option.save
        redirect slice_url(:admin_options), :message => {:notice => "Option was successfully created"}
      else
        message[:error] = "Option failed to be created"
        render :new
      end
    end
  
    def update(id, option)
      @option = Option.get(id)
      raise NotFound unless @option
      if @option.update_attributes(option)
         redirect slice_url(:admin_options)
      else
        display @option, :edit
      end
    end
  
    def destroy(id)
      @option = Option.get(id)
      raise NotFound unless @option
      if @option.destroy
        redirect slice_url(:admin_options)
      else
        raise InternalServerError
      end
    end
  
  end # Options
end # Admin
