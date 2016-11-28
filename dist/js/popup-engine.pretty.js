// Generated by CoffeeScript 1.11.1
(function($) {
  var Popup, applyStyles, bodyWrapper$, defaultOptions, getDocumentOffset, getScrollOffset, markup, removeStyles, style, styleOpenState;
  markup = {
    popup: "<div class='Popup'></div>",
    popupContent: "<div class='Popup-content'></div>",
    popupOverlay: "<div class='Popup-overlay'></div>",
    popupClose: "<div class='Popup-close'></div>",
    bodyWrapper: "<div class='bodyInnerwrap'></div>"
  };
  style = {
    popup: {
      position: 'absolute',
      zIndex: '3000',
      top: '0',
      left: '0',
      width: '100vw',
      minHeight: '100%',
      visibility: 'hidden',
      opacity: '0',
      transition: 'all 0.3s'
    },
    popupContent: {
      position: 'absolute',
      zIndex: '2',
      left: '50%',
      maxWidth: '100%',
      webkitTransform: 'translate3d(-50%, 0, 0)',
      mozTransform: 'translate3d(-50%, 0, 0)',
      msTransform: 'translate3d(-50%, 0, 0)',
      oTransform: 'translate3d(-50%, 0, 0)',
      transform: 'translate3d(-50%, 0, 0)',
      margin: '0 auto'
    },
    popupOverlay: {
      position: 'fixed',
      zIndex: '1',
      left: '0',
      top: '0',
      width: '100vw',
      minHeight: '100vh',
      backgroundColor: 'rgba(0,0,0,0.88)'
    }
  };
  styleOpenState = {
    popup: {
      opacity: '1',
      visibility: 'visible'
    },
    bodyWrapper: {
      position: 'fixed',
      width: '100%',
      top: ''
    }
  };
  defaultOptions = {
    'closeOnEsc': true,
    'centerPopup': true,
    'forceOpen': false,
    'style': style,
    'styleOpenState': styleOpenState
  };
  getScrollOffset = function() {
    return window.scrollY - getDocumentOffset();
  };
  getDocumentOffset = function() {
    var ref;
    return (((ref = document.body.getBoundingClientRect()) != null ? ref.top : void 0) || 0) + window.scrollY;
  };
  applyStyles = function(el, styleObject, additional) {
    var key, value;
    if (additional) {
      styleObject = $.extend({}, styleObject, additional);
    }
    for (key in styleObject) {
      value = styleObject[key];
      (el[0] || el).style[key] = value;
    }
    return el;
  };
  removeStyles = function(el, styleObject, stylesToReinstate) {
    var key;
    for (key in styleObject) {
      (el[0] || el).style[key] = '';
    }
    if (stylesToReinstate) {
      applyStyles(el, stylesToReinstate);
    }
    return el;
  };

  /**
  	 * The class used by popup instances of all kinds. This includes exit intents,
  	 * quote popups, screenshot lightboxes, etc.
  	 * 
  	 * @param {object} targetEl$  jQuery object containing the form/dom element to be inserted into the popup.
  	 * @param {string} name       Unique name to be used as the ID of the popup.
   */
  Popup = function(targetEl$, name, options) {
    this.name = name || 'popup_' + Math.floor(Math.random() * 100000);
    this.form = targetEl$.data('Form') || targetEl$.children('form').data('Form');
    this.options = $.extend(true, {}, defaultOptions, options);
    this.isOpen = false;
    this.scrollOffset = 0;
    this.el = $(markup.popup).attr('id', name);
    this.overlayEl = $(markup.popupOverlay).appendTo(this.el);
    this.closeEl = $(markup.popupClose).appendTo(this.el);
    this.contentEl = $(markup.popupContent).appendTo(this.el);
    this.appendToDOM(targetEl$);
    this.attachEvents();
    return Popup.instances[this.name] = this;
  };
  Popup.version = '2.2.3';
  Popup.instances = {};
  Popup.isOpen = false;
  Popup.prototype.appendToDOM = function(targetEl$) {
    applyStyles(this.el, this.options.style.popup);
    applyStyles(this.contentEl, this.options.style.popupContent);
    applyStyles(this.overlayEl, this.options.style.popupOverlay);
    applyStyles(this.closeEl, this.options.style.popupClose || {});
    this.el.prependTo(document.body);
    return targetEl$.first().appendTo(this.contentEl);
  };
  Popup.prototype.centerPopup = function() {
    var contentHeight, offset, windowHeight;
    contentHeight = this.contentEl[0].clientHeight;
    windowHeight = window.innerHeight;
    if (contentHeight >= windowHeight - 80) {
      offset = window.innerWidth > 736 ? 100 : 60;
    } else {
      offset = (windowHeight - contentHeight) / 2;
    }
    return this.contentEl[0].style.margin = offset + "px auto";
  };
  Popup.prototype.attachEvents = function() {
    this.closeEl.add(this.overlayEl).on('click', (function(_this) {
      return function() {
        return _this.close();
      };
    })(this));
    $(document).on("keyup." + this.name, (function(_this) {
      return function(event) {
        if (event.which === 27 && _this.isOpen && _this.options.closeOnEsc) {
          event.stopPropagation();
          event.preventDefault();
          return _this.close();
        }
      };
    })(this));
    if (this.options.centerPopup) {
      return $(window).on("resize." + this.name, (function(_this) {
        return function() {
          if (_this.isOpen) {
            return _this.centerPopup();
          }
        };
      })(this));
    }
  };
  Popup.prototype.detachEvents = function() {
    this.overlayEl.off("click." + this.name);
    $(document).off("keyup." + this.name);
    return $(window).off("resize." + this.name);
  };
  Popup.prototype.close = function() {
    if (this.isOpen) {
      this.el.removeClass('show').addClass('hiding');
      removeStyles(this.el, this.options.styleOpenState.popup, this.options.style.popup);
      setTimeout((function(_this) {
        return function() {
          _this.el.removeClass('hiding');
          removeStyles(bodyWrapper$, _this.options.styleOpenState.bodyWrapper);
          return window.scroll(0, _this.scrollOffset + getDocumentOffset());
        };
      })(this), 400);
      $(document.body).removeClass('_popupOpen');
      Popup.isOpen = this.isOpen = false;
      return this.el.trigger('closed');
    }
  };
  Popup.prototype.open = function() {
    if (!Popup.isOpen || this.options.forceOpen) {
      if (this.options.forceOpen) {
        $('.popup').removeClass('show');
      }
      if (this.el.find('.results').hasClass('show')) {
        this.el.addClass('show');
      } else {
        this.el.addClass('show').find('.step').first().addClass('show');
      }
      this.scrollOffset = getScrollOffset();
      applyStyles(this.el, this.options.styleOpenState.popup);
      applyStyles(bodyWrapper$, this.options.styleOpenState.bodyWrapper, {
        'top': (0 - this.scrollOffset) + "px"
      });
      if (this.options.centerPopup) {
        this.centerPopup();
      }
      setTimeout(function() {
        return window.scroll(0, 0);
      });
      $(document.body).addClass('_popupOpen');
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
    return this.contentEl.html(el$);
  };
  Popup.prototype.Open = Popup.prototype.open;
  Popup.prototype.Close = Popup.prototype.close;
  Popup.prototype.Reset = Popup.prototype.reset;
  Popup.prototype.restart = Popup.prototype.reset;
  Popup.prototype.Destroy = Popup.prototype.destroy;
  bodyWrapper$ = $('<div></div>');
  $(function() {
    $(document.body).wrapInner(markup.bodyWrapper);
    return bodyWrapper$ = $(document.body).children('.bodyInnerwrap');
  });
  return window.Popup = Popup;
})(jQuery);
