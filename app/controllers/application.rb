class ContentSlice::Application < Merb::Controller
  #before :get_menu  
  controller_for_slice

  #def get_menu
  #  @menu = Menu.get 1
  #end
  
end
