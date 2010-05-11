      function getUrl(target) {
          var overlay2 = new YAHOO.widget.Dialog("overlay2", {modal: true,
                                                    fixedcenter: true,
                                                    visible:true,
                                                    iframe: false,
                                                    width:"700px", height: '500px', close: true } );
          
          overlay2.setHeader("Przeglądarka plików");
          overlay2.setBody("");
          overlay2.setFooter("");
          overlay2.render(document.body);

          var div = jQuery('<div id="rte-file-manager">');
          jQuery('#overlay2 .bd').html(div);
            
            div.fileManager({fileManagerClass: 'rte-file-manager',action: function(self, e) {
              var _target = jQuery(target);
              _target.val(jQuery(e.target).parent().attr('href'));
              self.destroy();
              overlay2.cancel();
              return false;
            }});

          return false;
      }
      
function yuiFileBrowser(rte) {
  YAHOO.log("Adding click listener", 'debug');
  rte.addListener('toolbarLoaded',function() {
    var name = rte.get('textarea').id;
    
    rte.on('afterOpenWindow', function() {
      try {
            var Dom=YAHOO.util.Dom;
            var Event = YAHOO.util.Event

          // img editor window, increase width
          if(Dom.get(name + "_insertimage_url")) {
            var panel = jQuery("#" + name + "-panel");
            panel.width(panel.width() + 100);
          }

          if(!Dom.get("insertImageBrowse-button")) {
            var url = jQuery('#' + name + '_insertimage_url'); 
            var input = jQuery('<input type="button" id="insertImageBrowse" value="Wybierz">');
            url.after('&nbsp;').after(input);

            var url = jQuery('#' + name + '_insertimage_link'); 
            var input = jQuery('<input type="button" id="insertImageLinkBrowse" value="Wybierz">');
            url.after('&nbsp;').after(input);

            Event.onAvailable('insertImageBrowse', function () {
              var insertImageBrowseButton = new YAHOO.widget.Button('insertImageBrowse');
              insertImageBrowseButton.on('click', function() {
                getUrl('#' + name + '_insertimage_url');
              });
            });

            Event.onAvailable('insertImageLinkBrowse', function () {
              var insertImageLinkBrowseButton = new YAHOO.widget.Button('insertImageLinkBrowse');
              insertImageLinkBrowseButton.on('click', function() {
                getUrl('#' + name + '_insertimage_link');
              });
            });
          }

          if(!Dom.get("createLinkBrowse-button")) {
            var url = jQuery('#' + name + '_createlink_url'); 
            var input = jQuery('<input type="button" id="createLinkBrowse" value="Wybierz">');
            url.after('&nbsp;').after(input);
        
            Event.onAvailable('createLinkBrowse', function () {
              var insertImageLinkBrowseButton = new YAHOO.widget.Button('createLinkBrowse');
              insertImageLinkBrowseButton.on('click', function() {
                getUrl('#' + name + '_createlink_url');
              });
            });
          }

      } catch ( e ) {
        YAHOO.log( e.message, 'error' );
      }
    });
  });
};

YAHOO.editors = [];
  jQuery(function() {
    var editorTextareas = jQuery('textarea.editor_area');

    var editors = []
    editorTextareas.each(function() {
      var myEditor = new YAHOO.widget.Editor(this, {
        height: '300px',
        width: '700px',
        dompath: true,
        animate: true,
        handleSubmit: true,
        ptags: false
      });

      myEditor.render();
      YAHOO.editors.push(myEditor);
    });
    
    jQuery.each(YAHOO.editors, function() {
      yuiFileBrowser(this);
    });
  
  });


(function($) {
  $.lightBoxFu.initialize({imagesPath: '/images/lightbox-fu/', stylesheetsPath: '/stylesheets/'});

  $(function() {
    $('.fileManager form').livequery(function() {
      $(this).uploadProgress({
        start:function(){
          jQuery.upload_overlay = new YAHOO.widget.Dialog("uplad-overlay", {
              modal: true,
              fixedcenter: true,
              visible:true,
              iframe: true, 
              close: false, 
              width: '270px', 
              height: '110px'
          });

          var html = '<div id="uploading"><span id="received">Rozpoczynam przesyłanie</span><span id="size"></span><br/><div id="progress" class="bar"><div id="progressbar">&nbsp;</div></div><span id="percent">0%</span></div>';
          
          jQuery.upload_overlay.setHeader("Upload");
          jQuery.upload_overlay.setBody(html);
          jQuery.upload_overlay.setFooter("");
          jQuery.upload_overlay.render(document.body);
        },
        uploading: function(upload) {
          jQuery('#received').html("Wysyłam pliki: "+parseInt(upload.received/1024)+"/");
          jQuery('#size').html(parseInt(upload.size/1024)+" kB");
          jQuery('#percent').html(upload.percents+"%");
        },
        complete: function() {
          jQuery.upload_overlay.cancel();
        },
        interval: 2000,
        preloadImages: ["/images/lightbox-fu/overlay.png", "/images/ajax-loader.gif"]
      });
    });
  });
})(jQuery);
