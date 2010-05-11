module Merb
  module ContentSlice
    module ApplicationHelper
      
      def menu(menus)
        ret = "<ul>"
        for menu in menus
          if menu.active
            ret += "<li>"
            if menu.is_link 
              ret += link_to menu.name, "#{menu.url}"
            else
              ret += link_to menu.name, "/#{menu.id}"
            end
            ret += "</li>"
          end
        end
        ret += "</ul>"
      end

      def display_gallery(photos)
        ret = ""
        for photo in photos
          ret += "<div class=\"gallery-photo\" id=\"photo-#{photo.id}\">"
          ret += "<a href=\"#{photo.file.url(:huge)}\" rel=\"lightbox\">"
          ret += image_tag photo.file.url(:small)
          ret += "</a>"
          ret += "</div>"
        end
        ret
      end
      #
			# @return <String>
			# Links for avaible menus in app
      def avaible_menus(menus,language)
				ret = ""
				for menu in menus
					ret += "<li>" 
					ret += link_to "<b><u>#{menu.name}</u></b>", slice_url(:admin_menu_menu_elements,language,menu)
					ret += "</li>" 
				end
				ret
			end
      
      # Links for languages
      def avaible_languages(languages)
        ret = "<ul>"
        for language in languages
          ret = "<li>"
					ret += link_to "#{menu.name}", slice_url(:admin_menu_menu_elements,menu)
	        ret = "</li>"
        end
        ret = "</ul>"
      end


      
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path relative to the public directory, with added segments.
      def image_path(*segments)
        public_path_for(:image, *segments)
      end
      
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path relative to the public directory, with added segments.
      def javascript_path(*segments)
        public_path_for(:javascript, *segments)
      end
      
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path relative to the public directory, with added segments.
      def stylesheet_path(*segments)
        public_path_for(:stylesheet, *segments)
      end
      
      # Construct a path relative to the public directory
      # 
      # @param <Symbol> The type of component.
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path relative to the public directory, with added segments.
      def public_path_for(type, *segments)
        ::ContentSlice.public_path_for(type, *segments)
      end
      
      # Construct an app-level path.
      # 
      # @param <Symbol> The type of component.
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path within the host application, with added segments.
      def app_path_for(type, *segments)
        ::ContentSlice.app_path_for(type, *segments)
      end
      
      # Construct a slice-level path.
      # 
      # @param <Symbol> The type of component.
      # @param *segments<Array[#to_s]> Path segments to append.
      #
      # @return <String> 
      #  A path within the slice source (Gem), with added segments.
      def slice_path_for(type, *segments)
        ::ContentSlice.slice_path_for(type, *segments)
      end
      
    end
  end
end
