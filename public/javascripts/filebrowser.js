(function($) {
$('#file-manager').livequery(function() {
    $('#file-manager').fileManager({fileManagerClass: 'rte-file-manager',action: function(self, e, element) {
      var url = $(element).attr('href');
      var win = tinyMCEPopup.getWindowArg("window");

      win.document.getElementById(tinyMCEPopup.getWindowArg("input")).value = url;

      if (win.ImageDialog.getImageData) win.ImageDialog.getImageData();
      if (win.ImageDialog.showPreviewImage) win.ImageDialog.showPreviewImage(URL);

      tinyMCEPopup.close();

    }});
  });
})(jQuery);

