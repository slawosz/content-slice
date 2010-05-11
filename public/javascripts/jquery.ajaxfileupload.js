(function($) {  
  $.extend($, {ajaxFileUpload: {}});
  $.extend($.ajaxFileUpload, {
    createIFrame: function () {
      if($("#uploadFrame").length == 0) {
        iframe = $('<iframe name="uploadFrame" id="uploadFrame">');
        iframe.css("display", "none");
        iframe.appendTo($("body"));
        
      }
    }
  });
  
  $.extend($.fn, {
    ajaxFileUpload: function (object){
      return this.each(function () {
        element = $(this);
        element.attr('target', 'uploadFrame');
        $.ajaxFileUpload.createIFrame();
        element.bind('submit', function() {
          $("#uploadFrame").bind('load', object.uploadFinished);
        });
      });
    }
  });
  
})(jQuery);