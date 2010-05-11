if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices', :immediate => true
  Merb::Plugins.add_rakefiles "content-slice/merbtasks", "content-slice/slicetasks", "content-slice/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  use_template_engine :haml
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :content-slice
  # :mirror - which path component types to use on copy operations; defaults to all
  #Merb::Slices::config[:content_slice][:layout] = :application
  
  # All Slice code is expected to be namespaced inside a module
  module ContentSlice
    
    # Slice metadata
    self.description = "ContentSlice is a chunky Merb slice!"
    self.version = "0.0.1"
    self.author = "Engine Yard"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(ContentSlice)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :content_slice_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      scope.match('/index(.:format)').to(:controller => 'main', :action => 'index').name(:index)
      # the slice is mounted at /content-slice - note that it comes before default_routes
      scope.match('/').to(:controller => 'news', :action => 'index').name(:home)
      
      # enable slice-level default routes by default
      scope.resources(:news)
      scope.resources(:contacts)
      scope.match("/:language") do |i18n|
        i18n.namespace(:admin) do |admin|
          admin.resources(:articles) { |a| a.member :destroy, :method => :get }
          admin.resources(:news_pages){ |a| a.member :destroy, :method => :get }
          admin.resources(:languages){ |a| a.member :destroy, :method => :get }
          admin.resources(:options){ |a| a.member :destroy, :method => :get }
          admin.resources(:files) { |f| f.collection :browser, :method => :get }
          admin.resources(:menus) do |menu|
            menu.member :destroy, :method => :get
            menu.resources(:menu_elements) do |element| 
              element.member     :destroy, :method => :get
              element.collection :order  , :method => :post
            end
          end
          admin.resources(:galleries) do |gallery|
            gallery.member :destroy, :method => :get
            gallery.member :order  , :method => :post
            gallery.resources(:photos) do |photo|
             photo.member :destroy, :method => :get
             photo.member :confirm, :method => :get
           end
          end
        end
        scope.match("/:language/admin").to(:controller => 'admin/articles', :action => 'index' )
      end
      scope.match("/admin").to(:controller => 'admin/articles', :action => 'index', :language => "pl" )
      scope.match(%r[/account/([a-z]{4,6})]).to(:controller => "account", :action => "show", :id => "[1]")
      #scope.match(%r[/([0-9]+-[a-zA-Z\-0-9_]+)]).to(:controller => 'content', :action => 'show', :id => "[1]" )
      scope.match(%r[/([0-9a-zA-Z\-0-9_]+)]).to(:controller => 'content', :action => 'show', :id => "[1]" )
    end
    
  end
  
  # Setup the slice layout for ContentSlice
  #
  # Use ContentSlice.push_path and ContentSlice.push_app_path
  # to set paths to content-slice-level and app-level paths. Example:
  #
  # ContentSlice.push_path(:application, ContentSlice.root)
  # ContentSlice.push_app_path(:application, Merb.root / 'slices' / 'content-slice')
  # ...
  #
  # Any component path that hasn't been set will default to ContentSlice.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  ContentSlice.setup_default_structure!
  
  # Add dependencies for other ContentSlice classes below. Example:
  # dependency "content-slice/other"
  
end
