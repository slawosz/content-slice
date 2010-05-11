module ContentSlice::Admin
  class Base < ContentSlice::Application
    layout :admin
    controller_for_slice

		before :get_all_menus
		protected

		def get_all_menus
			@_menus = Menu.all
		end
	end
end
