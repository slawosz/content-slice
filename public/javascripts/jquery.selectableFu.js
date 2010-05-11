(function($) { 
  
  $.fn.extend({ 
    /*
    mySelectable: function (){
      return this.each(function () {
        $(this).each(function (i, el) {
          if(!$(el).hasClass('up'))
            $(el).bind('click', $.mySelectable.select);
        });
      });
    },
    selectElement: function (fileManager){
      $(this).addClass('selected');
      fileManager.properties();
    },
    toggleSelect: function (fileManager){
      $(this).toggleClass('selected');
      fileManager.properties();
    },
    //*/
    selectableFu: function(options) {
      var args = Array.prototype.slice.call(arguments, 1);
      
      return this.each(function() {
				if (typeof options == "string") {
					var selectable = $.data(this, "selectableFu");
          if(selectable)
            selectable[options].apply(selectable, args);

				} else if(!$.data(this, "selectableFu"))
					new $.selectableFu(this, options);
			});
    }
  });
  
  $.selectableFu = function(element, options) {
    var self = this;
		
    this.element = $(element);
    
    options = jQuery.extend({
      filter: ' > *:not(.up)', 
      onChange: function() {}
    }, options);
    
    this.onChange = options.onChange;
    this.selectedElements = [];
    
    $.data(element, "selectableFu", this);
		this.element.addClass("selectableFu");
     
    $(options.filter, this.element).each(function (i, el) {
      $(el).bind('click', self.select);
    });
  }
  
  $.extend($.selectableFu.prototype, {
    select: function(ev) {
      element = $(this);
      self = $.data(element.parent()[0], "selectableFu");
      
      if(ev.ctrlKey) {
        self.toggleSelect(this);
      } else {
        self.unselectAllElements();
        self.selectElement(this);
      }
      self.onChange();
    },
    unselectAllElements: function() {
      $('.selected', this.element).removeClass('selected');
    },
    selectElement: function(element) {
      $(element, this.element).addClass('selected');
    },
    toggleSelect: function(element) {
      $(element, this.element).toggleClass('selected');
    },
    destroy: function() {
      this.element.
        removeClass('selectableFu').
        removeData('selectableFu');
      $('.selected', this.element).removeClass('selected');
    }
  });
 
  /*
  $.extend($.mySelectable, {
    select: function (a) {
      el = $(this);
      if(a.ctrlKey) {
        el.toggleSelect();
      } else {
        $.mySelectable.unselectAllElements();
        el.selectElement();
      }
    },
    unselectAllElements: function (fileManager){
      $("#files ul li").removeClass('selected');
      fileManager.properties();
    }
  });
  //*/
  
})(jQuery);