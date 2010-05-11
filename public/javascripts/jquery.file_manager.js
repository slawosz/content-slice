(function($) {  
  $.fileManager = function(element, options) {
    var self = this;

    this.element = $(element);
    
    this.options = $.extend({}, options);
    var o = this.options;
    $.extend(o, {
      fileManagerClass: this.options.fileManagerClass || "fileManagerClass"
    });
     
    $.data(element, "fileManager", this);
		this.element.addClass("fileManager").addClass(o.fileManagerClass);
    
    $.rjsAjax('/admin/files.json', {
        type: 'GET', 
        requestHeader: "application/json",
        dataType: 'json',
        success: function(data) {
            var filesTemplate =  TrimPath.parseTemplate(self.templates.files);
            var files = filesTemplate.process({files: data.files});
            var template = TrimPath.parseTemplate(self.templates.index);
            var result  = template.process({dir: '/', files: files});
            self.element.html(result);
            
            $('.file-element:even').addClass('even');

            $('.form', element).ajaxFileUpload({uploadFinished: function () {
              self.getFiles();
              $('.remove_file').trigger('click');
            }});
            self.initialize();
            self.initDragDrop();
            $('.multifile').MultiFile();
            $(".path", self.element).val(data.dir);
          }
    });
  };
  
  $.extend($.fileManager.prototype, {
    initialize: function () {
      self = this;
      self.setAction();
      $(".rename", this.element).livequery('click', function () {
        var li = $(this).parents().filter('li');
        filename = window.prompt('Podaj nową nazwę pliku', li.find('input.filename').val());
        if(filename) {
          old_name = li.find('input.path').val();
          new_name = li.find('input.url').val() + '/' +filename;
          $.rjsAjax('/admin/files/rename', 
            {data: {
                from: old_name, to: new_name, id: li.attr('id'), 
                fileurl: li.find('input.url').val()
              },
              complete: function() {self.getFiles();}
            });
          
        }
        return false;
      });
      $(".name", this.element).livequery(function() {
        $(this).tooltip({
          extraClass: "filename-tooltip",
          bodyHandler: function() {
            return $(this).parents().filter("li").find('input.wrapped_filename').val();
          }
        });
      });
      $(".remove_element", this.element).livequery('click', function () {
        if(confirm("Na pewno chcesz skasować ten plik?")) {
          li = $(this).parents().filter('li');
          path = li.find('input.path').val();
          $.rjsAjax('/admin/files/0', 
            {type: 'DELETE', data: {fileurl: li.find('input.url').val(), file: path},
              complete: function() {self.getFiles();}});
        }
        return false;
      });
      
      $('.new_directory', this.element).livequery('click', function() {
        filename = window.prompt('Podaj nową nazwę dla nowego folderu');
        if(filename) {
          //filename = $("#path").val() + '/' + filename;
          $.rjsAjax('/admin/files/new', {type: 'GET', 
            data: {new_directory: filename, fileurl: $(".form input.path", this.element).val()},
              complete: function() {self.getFiles();}
          });
        }
        return false;
      });

      $('.files ul li.directory a, .files ul li.up a', this.element).
        livequery('click', 
          (function(self) {
            return function() {        
              url = $(this).parents().filter('li').find('input.path').val();
              self.getFiles(url);
              return false;
            }
          })(this)
        );
    },
    initDragDrop: function() {
      $(".files ul li.file, .files ul li.directory", this.element).draggable({revert: true, helper: 'clone', 
        start: function(e, ui) {
          if(!$(this).hasClass("selected")) {
            //$.mySelectable.unselectAllElements(self);
          }
          test = ui;
          $(ui.helper).addClass('dragging');
        },
        stop: function() {
          $(this).removeClass('dragging');
        }
      });
      $(".files ul li.directory, .files ul li.up", this.element).droppable({
        accept: ".files ul li.directory, .files ul li.file",
        hoverClass: 'directory_hover',
        drop: (
          function (self) {
            return function(ev, ui) {
              self.move($(ui.draggable), $(ui.element));
            }
          })(this)
      });
      $('.files ul', this.element).selectableFu({onChange: function(self) {
        return function() {
          self.properties();
        }
      }(this)});
    },
    destroy: function() {
      this.removeDragDrop();
      $(".rename", this.element).expire();
      $('.new_directory', this.element).expire();
      $('.files ul li.directory span.name a, .files ul li.up span.name a', this.element).expire();
      this.element
				.removeClass("fileManager")
				.removeData("fileManager");
         
    },
    removeDragDrop: function () {
      $(".files ul li.directory, .files ul li.up", this.element).droppable('destroy');
      $(".files ul li", this.element).draggable('destroy');
      $('.files ul', this.element).selectableFu('destroy');
    },
    move: function (file, target) {
      var self = this;
      if($(file).hasClass("selected")) {
        data = {}
        $('.files ul li.selected').each(function (i, el) {
          el = $(el);
          eval("$.extend(data, {" +
            "'from["+el.attr('id')+"]': $(el).find('input.path').val()});");
        });
      } else {
        eval("data = {'from["+file.attr('id')+"]': file.find('input.path').val()};");
      }
      $.extend(data, {'to': target.find('input.path').val(),
        _method: 'put',
        fileurl: $('.files ul li.selected').find('input.url').val()});
      $.rjsAjax('/admin/files/'+file.attr('id').split('_')[1], {type: 'PUT', data: data,
              complete: function() {self.getFiles();}});
    },
    properties: function (el) {
      $(".remove_elements", this.element).unbind('click');
      props = $('.file_properties');
      selected = $('.selected');
      
      if(selected.length == 0 ) {
        props.html('');
      } else if(selected.length == 1) {
        filename = selected.find('input.filename').val();
        size = selected.find('input.size').val();
        path = selected.find('input.path').val();
        extractable = '';
        if(selected.hasClass('extractable'))
          extractable = '<a href="#" class="extract_element">Rozpakuj</a><br/>';
        
        props.html('').append('<p>'+filename+'</p>').append('<p>Size: '+size+'</p>')
        .append(extractable+'<a href="#" class="remove_elements">Usuń</a><br/>');
        
        $(".extract_element").unbind('click')
          .bind('click', {'path': path}, function () {
            $.rjsAjax('/admin/files/extract', {data: {path: path}});
            return false;
          });
      } else {
        props.html('').append('<p>Liczba zaznaczonych plików: '+selected.length+'</p>')
        .append('<a href="#" class="remove_elements">Usuń</a><br/>');
      }
      data = {fileurl: $(el).find('input.url').val()};
      $('.files ul li.selected').each(function (i, el) {
          el = $(el);
          eval("$.extend(data, {" +
            "'files["+el.attr('id')+"]': $(el).find('input.path').val()});");
        });
      //$.extend(data, {path: path});
     var self = this;
      $(".remove_elements", this.element)
        .bind('click', {data: data, self: self}, function () {
          if(confirm("Na pewno chcesz skasować te pliki?")) {
            $.rjsAjax('/admin/files/0', {type: 'DELETE', data: data});
            self.getFiles();
          }
          return false;
        });
      
    }, 
    setAction: function() {
      var self = this;
      if(this.options.action) {
        $('.files ul li.file a.label', this.element).bind('click', 
          function(e) {
              self.options.action(self, e, this);
              return false;
          });
      } else {
        $('a[@rel=lightbox]', self.element).lightBox();
        $('.files ul li.file a.label', self.element).attr('target', "_blank");
      }
    },
    getFiles: function(url) {
      var self = this;
      $.rjsAjax('/admin/files.json', {
          type: 'GET', 
          data: {fileurl: 
            url || 
            $(".form input.path", self.element).val()
          },
          requestHeader: "application/json",
          dataType: 'json',
          success: function(data) {
            var filesTemplate =  TrimPath.parseTemplate(self.templates.files);
            var files = filesTemplate.process({files: data.files});
            self.removeDragDrop();
            $('.files ul', self.element).html(files);
            self.initDragDrop();
            self.setAction();
            $(".form input.path", self.element).val(data.dir);
            $('.file-element:even').addClass('even');
          }
      });
    },
    templates: {}
  });
  
  $.extend($.fileManager.prototype.templates, {
    index:   
              '<div id="file_upload_box">'+
                '<form class="form" enctype="multipart/form-data" '+
                'action="/admin/files" method="POST">'+ 
                  '<input type="file" name="file" class="multifile" /><br/>'+
                  '<input type="hidden" name="path" class="path" value="${dir}"/>'+
                  '<input type="submit" value="Wgraj na serwer" id="file_upload_button"/>'+
                '</form>'+
              '</div>'+
              '<div id="under_file_upload_box"><div id="new_folder_button"><a href="#" class="new_directory">Dodaj nowy katalog</a></div></div>'+    
              
              '<div class="files">'+
                '<div id="files_header">'+
                  '<span id="header_move"></span>'+
                  '<span id="header_name">Nazwa pliku</span>'+
                  '<span id="header_change_name">Zmień nazwę</span>'+
                  '<span id="header_size">Rozmiar</span>'+
                  '<span id="header_delete">Usuń</span>'+
                '</div>'+
                '<ul>'+
                  '${files}'+
                '</ul>'+
                '<div class="clear"></div>'+
              '</div>'+
              '<div class="file_properties"></div>'+
              '<div class="clear"></div>',
              
    files:  '{for file in files}'+
              '<li id="file_${file_index}" class="${file.classes} file-element">'+
                '<span class="move"><img src="/images/admin/move.png" alt=""/></span>'+
                '<a href="${file.public_url}" class="label" rel="${file.handler}"><span class="icon"><img src="/images/${file.icon}" alt=""/></span>'+
                '<span class="name">${file.shorter_filename}</span></a>'+
                '<span style="display: none; line-height: 0; margin: 0; padding: 0;">'+
                  '<input type="hidden" class="wrapped_filename" value="${file.wrapped_filename}"/>'+
                  '<input type="hidden" class="filename" value="${file.filename}" />'+
                  '<input type="hidden" class="url" value="${file.url}" />'+
                  '<input type="hidden" class="path" value="${file.path}" />'+
                  '<input type="hidden" class="size" value="${file.size}" />'+
                '</span>'+
                '<span class="change_name"><a href="#" class="rename"></a></span>'+
                '<span class="size">${file.human_size}</span>'+
                '<span class="delete"><a href="#" class="remove_element"><img src="/images/admin/delete.png"></a></span>'+
              '</li>'+
            '{/for}'
         
  });
  $.extend($.fn, { 
    fileManager: function(options) {
      var args = Array.prototype.slice.call(arguments, 1);
      
      return this.each(function() {
				if (typeof options == "string") {
					var fileManager = $.data(this, "fileManager");
          if(fileManager)
            fileManager[options].apply(fileManager, args);

				} else if(!$.data(this, "fileManager"))
					new $.fileManager(this, options);
			});
    }
  });
  
  
})(jQuery);
