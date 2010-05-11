class LocalFile
  attr_accessor :filename, :url, :size, :path, :directory

  def shorter_filename
    if filename.length > 37
      if self.directory?
        "#{filename[0..34]}(...)"
      else
        name, extension = filename.scan(/(.*)\.([^.]*)$/).flatten
        name = name[0..30]
        "#{name}(...).#{extension}"
      end
    else
      filename
    end
  end

  def wrapped_filename
    filename.scan(/.{1,40}/).join("<wbr>")
  end
  
  def initialize(filename, url)
    @filename, @url = filename, url
    @path = File.join(url, filename)
    @size = File.size(system_path)
  end
  
  def to_hash
    methods = %w{filename url size path directory classes icon public_url handler human_size shorter_filename wrapped_filename}
    hash = {}
    for method in methods
      hash.merge!(method.to_s => self.send(method))
    end
    hash
  end
  
  def to_json
    self.to_hash.to_json
  end
  
  def directory?
    File.directory?(system_path)
  end
  
  def classes
     result = []
     result << if directory?
       if @filename == '..'
         'up'
       else
         'directory'
       end
     else
       result << 'extractable' if extractable?
       'file'
     end
     
     result.join(' ')
  end
  
  def public_url
    File.join('/uploads', @path)
  end
  
  def system_path
    File.join(Merb.root, 'public/uploads', @path)
  end

  def self.system_path(path)
    File.join(Merb.root, 'public/uploads', path)
  end
  
  def self.files(url)
    url ||= '/'
    url = File.expand_path(url)
    files = []
    unless valid_url(url) == valid_url('/')
      files << LocalFile.new('..', url)
    end
    files_list(url) do |filename, i|
      file = LocalFile.new(filename, url)
      files << file
    end
    files
  end
  
  def self.files_list(url='/')
    Dir.chdir valid_url(url)

    files = Dir.glob('*')
    dirs = files.find_all do |filename|
      File.directory?(filename)
    end
    files = files - dirs
    files.sort!
    dirs.sort!
    
    (dirs + files).each_with_index do |filename, i|
        yield(filename, i)
    end
  end
  
  def self.valid_url(url)
    fileurl = File.join(Merb.root, 'public/uploads', url)
    unless File.exists? fileurl
      fileurl = File.join(Merb.root, 'public/uploads')
    end
    File.expand_path(fileurl)
  end
  
  def extractable?
    false#['application/zip'].include?(File.mime_type?(@filename))
  end
  
  # diaplay icon suitable for this file
  def icon
    if filename == '..'
      'filemanager/folderup.jpg'
    elsif directory?
      "filemanager/folder.jpg"
    else
      "filemanager/icons/#{filetype}.gif"
    end
  end
  
  def human_size
    size = @size.to_i
    if size < 1024
      "#{size} B"
    elsif size < 1024*1024
      "#{(size/1024)} KB"
    elsif size < 1024*1024*1024
      "#{(size/1024/1024)} MB"
    elsif size < 1024*1024*1024*1024
      "#{(size/1024/1024/1024)} GB"
    end
  end
  
  def to_s
    @filename
  end
  
  def filetype
    type = @filename.scan(/.*\.([a-zA-Z0-9]{2,3})$/).to_s.downcase
    case type
      when 'doc', 'rtf', 'odt'
        'doc'
      when 'rar', 'zip', 'bz2', 'tar', 'gz'
        'zip'
      when 'avi', 'mov', 'mpeg', 'mpg'
        'avi'
    else
        type
    end
  end
  
  def handler
    images = %w{jpg gif jpeg png bmp}
    if images.include?(filetype)
      "lightbox"
    end
  end
end
