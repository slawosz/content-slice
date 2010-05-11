module ContentSlice::Admin
  class News < Base
    # provides :xml, :yaml, :js
  
    def index
      @news = New.all
      display @news
    end
  
    def show(id)
      @news = New.get(id)
      raise NotFound unless @news
      display @news
    end
  
    def new
      @editor = true
      only_provides :html
      @news = New.new
      display @news
    end
  
    def edit(id)
      @editor = true
      only_provides :html
      @news = New.get(id)
      raise NotFound unless @news
      display @news
    end
  
    def create(news)
      @news = New.new(news)
      if @news.save
        redirect "/admin/news", :message => {:notice => "Aktualność została dodana"}
      else
        message[:error] = "News failed to be created"
        render :new
      end
    end
  
    def update(id, news)
      @news = New.get(id)
      raise NotFound unless @news
      if @news.update_attributes(news)
         redirect "/admin/news", :message => { :notice => "Aktualność została zmieniona" }
      else
        display @news, :edit
      end
    end
  
    def destroy(id)
      @news = New.get(id)
      raise NotFound unless @news
      if @news.destroy
        redirect resource(:news)
      else
        raise InternalServerError
      end
    end
  
  end # News
end # Admin
