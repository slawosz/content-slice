module ContentSlice::Admin
  class Files < Base

    controller_for_slice

    provides :js, :json, :html

    def browser
      render :layout => 'filebrowser'
    end
    
    def index
      @files, @dir = LocalFile.files(params[:fileurl]), params[:fileurl]
      @editor = true 
      case content_type
      when :json
        display({:files => @files, :dir => @dir})
      when :html
        render
        #render :layout => 'filebrowser'
      else
        render :layout => false
      end
    end
    
    def create
      params[:file].to_a.each do |id, uploaded_file|
        next unless uploaded_file[:filename]
        File.open(File.join(Merb.root, 'public/uploads', params[:path], uploaded_file[:filename]), "w") do |file|
          file.write(uploaded_file[:tempfile].read())
        end
      end
      render :nothing => 200
    end
    
    def new
      FileUtils.mkdir(LocalFile.system_path(File.join(params[:fileurl], params[:new_directory])))
      render :nothing => 200
    end
    
    def update
      if !params[:from].blank? && !params[:to].blank? 
        params[:from].each do |id, from|
          from = LocalFile.system_path(from)
          if File.exists?(from) 
            FileUtils.move(from, LocalFile.system_path(params[:to]))
          end
        end
      end
      
      render :nothing => 200
    end
    
    def rename
      if !params[:from].blank? && !params[:to].blank? 
          from = LocalFile.system_path(params[:from])
          if File.exists?(from) 
            FileUtils.move(from, LocalFile.system_path(params[:to]))
          end
      end
      render :nothing => 200
    end
    
    def destroy
      if params[:file]
        if File.exists?(LocalFile.system_path(params[:file])) 
            FileUtils.rm_rf(LocalFile.system_path(params[:file]))
          end
      else
        params[:files].each do |id, path|
          if File.exists?(LocalFile.system_path(path)) 
            FileUtils.rm_rf(LocalFile.system_path(path))
          end
        end
      end
      render :nothing => 200
    end
    
    #def extract
    #  if params[:path]
    #    extract_file(path(params[:path]))
    #  end
    #  @files = get_files(File.dirname(params[:path]))
    #  respond_to do |format|
    #    format.js { render :action => 'index', :layout => 'jquery' }
    #  end
    #end
    
  private
    #def extract_file path
    #  if File.mime_type?(path) == 'application/zip'
    #    filename = File.basename(path)
    #    dir = File.join(File.dirname(path), filename[0, filename.rindex('.').to_i])
    #    `unzip #{path} -d #{dir}`
    #  end
    #end
  end
end
