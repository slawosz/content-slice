module ContentSlice::Admin
  class Articles < Base
    # provides :xml, :yaml, :js
  
    def index
      @articles = Article.all
      display @articles
    end
  
    def show(id)
      @article = Article.get(id)
      raise NotFound unless @article
      display @article
    end
  
    def new
      @editor = true
      only_provides :html
      @article = Article.new
      display @article
    end
  
    def edit(id)
      @editor = true
      only_provides :html
      @article = Article.get(id)
      raise NotFound unless @article
      display @article
    end
  
    def create(article)
      @article = Article.new(article)
      if @article.save
        redirect slice_url(:admin_articles), :message => {:notice => "Artykuł został dodany"}
      else
        message[:error] = "Artykuł nie mógł zostać dodany"
        render :new
      end
    end
  
    def update(id, article)
      @article = Article.get(id)
      raise NotFound unless @article
      if @article.update_attributes(article)
         redirect slice_url(:admin_articles)
      else
        display @article, :edit
      end
    end
  
    def destroy(id)
      @article = Article.get(id)
      raise NotFound unless @article
      if @article.destroy
        redirect slice_url(:admin_articles), :message => { :notice => "Artykuł został usunięty" }
      else
        raise InternalServerError
      end
    end
  
  end # Articles
end # Admin
