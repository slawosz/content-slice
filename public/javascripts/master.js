function set_lightbox() {
    if(is_defined('lightbox_color')) {
          var color = lightbox_color;
    } else {
      var color = 'white';
    }
     
    $('a[@rel=lightbox], a[@target=_lightbox]').lightBox({
      imageBtnPrev: '/images/lightbox/lightbox-btn-prev-'+color+'.gif',
      imageBtnNext:     '/images/lightbox/lightbox-btn-next-'+color+'.gif',
      imageBtnClose:      '/images/lightbox/lightbox-btn-close-'+color+'.gif',
      imageLoading:     '/images/lightbox/lightbox-ico-loading-'+color+'.gif',
      color: color
    });
}

function is_defined(variable) {
  return (typeof(window[variable]) != "undefined");
}

function is_defined(variable) {
  return (typeof(window[variable]) != "undefined");
}

jQuery.extend(jQuery, {
  rjsAjax: function (url, options) {
    options = options || {};
    url = url.replace(/http:\/\/[^\/]*/, '');
    options.type = options.type || "POST";
    options.data = options.data || {};
    options.dataType = options.dataType || "script";
    beforeSend = options.beforeSend || function() {};
    complete = options.complete || function() {};
    error = options.error || function() {};
    delete options.beforeSend;
    delete options.complete;
    delete options.error;
    if(options.type == "DELETE") {
      options.type = "POST";
      if(typeof options.data == "string") {
        options.data += "&_method=delete";
      } else {
        $.extend(options.data, {_method: 'delete'});
      }
    } else if(options.type == "PUT") {
      options.type = "POST";
      if(typeof options.data == "string") {
        options.data += "&_method=put";
      } else {
        $.extend(options.data, {_method: 'put'});
      }
    }

    requestHeader = options.requestHeader || "text/javascript";
/*
      if(typeof options.data == "string") {
        options.data += "&authenticity_token="+AUTHENTICITY_TOKEN;
      } else {
        $.extend(options.data, {authenticity_token: AUTHENTICITY_TOKEN});
      }*/
    ajaxOptions = {
      url: url,
      dataType: options.dataType,
      beforeSend: function(xhr) {
        beforeSend();
        $('#loading').show();
        xhr.setRequestHeader("Accept", requestHeader);
      },
      error: function(){
        error();
      },
      complete: function (xhr, status) {
        complete(xhr, status);
        $('#loading').hide();
      }
    };
    jQuery.extend(ajaxOptions, options)
    $.ajax(ajaxOptions);
  }
});

$(function(){ 
  $('.multifile').MultiFile();
  set_lightbox;
  $("#show-photos-form").click(function() {
    $("#photos-form").show();
    return false;
  });
  $('.delete-admin-resource').click(function(){
    return window.confirm("Kontynuować usuwanie?");
  });

  $('table.table').tableDnD({
    scrollAmount: 0, 
    dragHandle: "handle",
    onDrop: function(table, row) {
      //alert($.tableDnD.serialize());
      url = '/pl/admin/menus/' + $('table.table').metadata().menu_id  + '/menu_elements/order';
      //alert(url);
      $.post( url , $.tableDnD.serialize() );
    }
  });

  $('#news_page_created_on').datepicker($.datepicker.regional['pl'], {dateFormat: "yy-mm-dd" });
  $("#photos").sortable({
    handle: $('#photos .photo .handle'),
    update: function(e,ui) {
      var params = $("#photos").sortable('serialize');
      url = '/pl/admin/galleries/' + $('#photos').metadata().gallery_id  + '/order';
      //alert(url);
      $.post( url , params );
    }
  });
  $('#menu_element_is_link_container').click(function(){
    $('#menu_element_url_container').toggle();
    alert("zuo");
  });
});


function myFileBrowser (field_name, url, type, win) {
  cmsURL = "/pl/admin/files/browser";
  tinyMCE.activeEditor.windowManager.open({
      file : cmsURL,
      title : 'Pliki',
      width : 700,  // Your dimensions may differ - toy around with them!
      height : 600,
      resizable : "yes",
      inline : "yes",  // This parameter only has an effect if you use the inlinepopups plugin!
      close_previous : "no"
  }, {
      window : win,
      input : field_name
  });
  return false;
}


tinyMCE.init({
  mode : "textareas",
  content_css : "/stylesheets/editor.css",
//  height: "600",
  theme : "advanced",
  theme_advanced_toolbar_location : "top",
  theme_advanced_toolbar_align : "left",
  theme_advanced_statusbar_location : "bottom",
  theme_advanced_resizing : true,
  file_browser_callback : 'myFileBrowser'
});
