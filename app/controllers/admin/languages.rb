module ContentSlice::Admin
  class Languages < Base
    # provides :xml, :yaml, :js
  
    def index
      @languages = Language.all
      display @languages
    end
  
    def show(id)
      @language = Language.get(id)
      raise NotFound unless @language
      display @language
    end
  
    def new
      only_provides :html
      @language = Language.new
      display @language
    end
  
    def edit(id)
      only_provides :html
      @language = Language.get(id)
      raise NotFound unless @language
      display @language
    end
  
    def create(language)
      @language = Language.new(language)
      if @language.save
        redirect slice_url(:admin_languages), :message => {:notice => "Language was successfully created"}
      else
        message[:error] = "Language failed to be created"
        render :new
      end
    end
  
    def update(id, language)
      @language = Language.get(id)
      raise NotFound unless @language
      if @language.update_attributes(language)
         redirect slice_url(:admin_languages)
      else
        display @language, :edit
      end
    end
  
    def destroy(id)
      @language = Language.get(id)
      raise NotFound unless @language
      if @language.destroy
        redirect slice_url(:admin_languages)
      else
        raise InternalServerError
      end
    end
  
  end # Languages
end # Admin
