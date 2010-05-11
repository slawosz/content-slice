module ContentSlice::Admin
  class NewsPages < Base
    # provides :xml, :yaml, :js
  
    def index
      @news_pages = NewsPage.all( :order => [:created_on.desc] )
      display @news_pages
    end
  
    def show(id)
      @news_page = NewsPage.get(id)
      raise NotFound unless @news_page
      display @news_page
    end
  
    def new
      @editor = true
      only_provides :html
      @news_page = NewsPage.new
      @news_page.created_on = Time.now.strftime("%Y-%m-%d")
      display @news_page
    end
  
    def edit(id)
      @editor = true
      only_provides :html
      @news_page = NewsPage.get(id)
      raise NotFound unless @news_page
      display @news_page
    end
  
    def create(news_page)
      @news_page = NewsPage.new(news_page)
      if @news_page.save
        redirect slice_url(:admin_news_pages), :message => {:notice => "Nowa aktualność została dodana"}
      else
        message[:error] = "Błąd przy dodawaniu aktualności"
        render :new
      end
    end
  
    def update(id, news_page)
      @news_page = NewsPage.get(id)
      raise NotFound unless @news_page
      if @news_page.update_attributes(news_page)
         redirect slice_url(:admin_news_pages)
      else
        display @news_page, :edit
      end
    end
  
    def destroy(id)
      @news_page = NewsPage.get(id)
      raise NotFound unless @news_page
      if @news_page.destroy
        redirect slice_url(:admin_news_pages), :message => { :notice => "Usunięcie powiodło się" }
      else
        raise InternalServerError
      end
    end
  
  end # NewsPages
end # Admin
