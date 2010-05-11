module ContentSlice::Admin
  class Base < ContentSlice::Application
    layout :admin
    controller_for_slice

    before :ensure_authenticated if Merb::Slices::config[:content_slice][:authenticate]

		before :get_all_menus
    before :get_options
		protected

		def get_all_menus
			@_menus = Menu.all
		end

    def get_options
      @options = Hash.new
      Option.all.each do |o|
        @options[o.name.to_sym] = o.value
      end
    end
	end
end
