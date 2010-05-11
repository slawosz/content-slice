jQuery.fn.nginxUploadProgress = function(settings) {
	return this.each(function(){
		jQuery(this).submit(function() {
      jQuery.lightBoxFu.open('<div id="uploading"><span id="received"></span><span id="size"></span><br/><div id="progress" class="bar"><div id="progressbar">&nbsp;</div></div><span id="percent"></span></div>', {width: 250});
			settings = jQuery.extend({
				interval: 2000,
				progress_bar_id: "progressbar",
				nginx_progress_url: "/progress"
			}, settings);
		
			/* generate random progress-id */
			var uuid = "";
			for (i = 0; i < 32; i++) { uuid += Math.floor(Math.random() * 16).toString(16); }
			/* patch the form-action tag to include the progress-id */
			jQuery(this).attr("action", jQuery(this).attr("action") + "?X-Progress-ID=" + uuid);
		
			this.timer = window.setInterval(function() { jQuery.nginxUploadProgress(this, settings['nginx_progress_url'], settings['progress_bar_id'], uuid) }, settings['interval']);
		});
	});
};

jQuery.nginxUploadProgress = function(e, nginx_progress_url, progress_bar_id, uuid) {
	jQuery.ajax({
		type: "GET",
		url: nginx_progress_url,
		dataType: "json",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("X-Progress-ID", uuid);
		},
		success: function(upload) {
			/* change the width if the inner progress-bar */
			if (upload.state == 'uploading') {
                                jQuery('#received').html("Uploading: "+parseInt(upload.received/1024)+"/");
                                jQuery('#size').html(parseInt(upload.size/1024)+" kB");
				bar = jQuery('#'+progress_bar_id);
				w = Math.floor((upload.received / upload.size)*1000)/10;
                                jQuery('#percent').html(w+"%");
				bar.width(Math.floor(w) + '%');
			}
			/* we are done, stop the interval */
			if (upload.state == 'done') {
				window.clearTimeout(e.timer);
			}
		}
	});
};