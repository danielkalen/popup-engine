// Generated by CoffeeScript 1.10.0
(function($) {
  var Popup, appendPopup, popupOverlay$;
  popupOverlay$ = $('.popup-overlay');
  appendPopup = function() {
    if (popupOverlay$.length === 0) {
      return popupOverlay$ = $('<div class="popup-overlay"></div>').prependTo(document.body);
    }
  };
  appendPopup();

  /**
  	 * The class used by popup instances of all kinds. This includes exit intents,
  	 * quote popups, screenshot lightboxes, etc.
  	 * 
  	 * @param {object} popup$ jQuery object containing the form/dom element to be inserted into the popup.
  	 * @param {string} name  Unique name to be used as the ID of the popup.
   */
  Popup = function(popup$, name) {
    this.name = name || 'popup_' + Math.floor(Math.random() * 100000);
    this.form = popup$.data('Form') || popup$.children('form').data('Form');
    this.el = $("<div class='popup' id='" + name + "'><div class='popup-close'></div><div class='popup-content'></div></div>");
    this.options = {
      'closeOnEsc': true
    };
    this.isExitIntent = name.includes('exit-intent');
    this.isOpen = false;
    this.appendToDOM(popup$);
    this.attachEvents();
    return Popup.instances[this.name] = this;
  };
  Popup.version = '2.1.1';
  Popup.instances = {};
  Popup.isOpen = false;
  Popup.prototype.appendToDOM = function(popup$) {
    appendPopup();
    this.el.insertAfter(popupOverlay$);
    return popup$.first().appendTo(this.el.find('.popup-content'));
  };
  Popup.prototype.attachEvents = function() {
    this.el.children('.popup-close').on('click', (function(_this) {
      return function() {
        return _this.close();
      };
    })(this));
    popupOverlay$.on("click." + this.name, (function(_this) {
      return function() {
        setTimeout(function() {
          return popupOverlay$.removeClass("show belongs_to_" + _this.name);
        });
        $('.popup.show').removeClass('show');
        $(document.body).removeClass('opened-popup');
        Popup.isOpen = false;
        return _this.close();
      };
    })(this));
    return $(document).on("keyup." + this.name, (function(_this) {
      return function(event) {
        if (event.which === 27 && _this.isOpen && _this.options.closeOnEsc) {
          event.stopPropagation();
          event.preventDefault();
          return _this.close();
        }
      };
    })(this));
  };
  Popup.prototype.detachEvents = function() {
    popupOverlay$.off("click." + this.name);
    return $(document).off("keyup." + this.name);
  };
  Popup.prototype.close = function() {
    if (this.isOpen) {
      this.el.removeClass('show').addClass('hiding');
      setTimeout((function(_this) {
        return function() {
          return _this.el.removeClass('hiding');
        };
      })(this), 1000);
      popupOverlay$.removeClass("show belongs_to_" + this.name);
      $(document.body).removeClass('opened-popup');
      Popup.isOpen = this.isOpen = false;
      return this.el.trigger('closed');
    }
  };
  Popup.prototype.open = function() {
    if (!Popup.isOpen || this.isExitIntent) {
      popupOverlay$.addClass("show belongs_to_" + this.name);
      if (this.isExitIntent) {
        $('.popup').removeClass('show');
      }
      if (this.el.find('.results').hasClass('show')) {
        this.el.addClass('show');
      } else {
        this.el.addClass('show').find('.step').first().addClass('show');
      }
      $(document.body).addClass('opened-popup');
      Popup.isOpen = this.isOpen = true;
      return this.el.trigger('opened');
    }
  };
  Popup.prototype.reset = function() {
    if (this.form) {
      this.form.Restart(true, true);
    }
    return this.el.trigger('reset');
  };
  Popup.prototype.destroy = function() {
    this.close();
    this.detachEvents();
    this.el.remove();
    return delete Popup.instances[this.name];
  };
  Popup.prototype.replaceWith = function(el$) {
    return this.el.children('.popup-content').html(el$);
  };
  Popup.prototype.Open = Popup.prototype.open;
  Popup.prototype.Close = Popup.prototype.close;
  Popup.prototype.Reset = Popup.prototype.reset;
  Popup.prototype.restart = Popup.prototype.reset;
  Popup.prototype.Destroy = Popup.prototype.destroy;
  return window.Popup = Popup;
})(jQuery);
