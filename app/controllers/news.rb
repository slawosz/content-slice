class ContentSlice::News < ContentSlice::Application

  def index
    @news = NewsPage.all( :order => [:created_on.desc] )
    display @news
  end

  def show
    @news = NewsPage.get(params[:id])
    display @news
  end
  
end
