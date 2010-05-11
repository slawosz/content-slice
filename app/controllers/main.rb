class ContentSlice::Main < ContentSlice::Application
  
  def index
    render :layout => "content_slice_rte_test"
  end
  
end
