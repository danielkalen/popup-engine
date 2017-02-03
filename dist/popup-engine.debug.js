// Generated by CoffeeScript 1.12.2
(function($) {
  var Popup, bodyWrapper$, defaultOptions, genName, genTransformOriginStyle, genTransformStyle, getDocumentOffset, getScrollOffset, markup, styles;
  getScrollOffset = function() {
    return window.scrollY - getDocumentOffset();
  };
  getDocumentOffset = function() {
    var ref;
    return (((ref = document.body.getBoundingClientRect()) != null ? ref.top : void 0) || 0) + window.scrollY;
  };
  genName = function() {
    return 'popup_' + Math.floor(Math.random() * 100000);
  };
  genTransformStyle = function(value, scaleValue) {
    var scale, transformString, translate;
    scale = scaleValue != null ? "scale(" + scaleValue + ")" : '';
    translate = "translate3d(" + value + ")";
    transformString = translate + " " + scale;
    return {
      webkitTransform: transformString,
      mozTransform: transformString,
      msTransform: transformString,
      oTransform: transformString,
      transform: transformString
    };
  };
  genTransformOriginStyle = function(xValue) {
    return {
      webkitTransformOrigin: xValue + " 0%",
      mozTransformOrigin: xValue + " 0%",
      msTransformOrigin: xValue + " 0%",
      oTransformOrigin: xValue + " 0%",
      transformOrigin: xValue + " 0%"
    };
  };
  styles = {};
  styles.popup = {
    position: 'absolute',
    zIndex: '3000',
    top: '0',
    left: '0',
    width: '100vw',
    minHeight: '100%',
    opacity: '0',
    visibility: 'hidden',
    overflow: 'hidden',
    height: 0,
    transition: function(instance) {
      return "all " + (instance.options.animation / 1000) + "s";
    },
    whenOpen: {
      opacity: '1',
      visibility: 'visible',
      overflow: 'visible',
      height: 'auto'
    }
  };
  styles.bodyWrapper = {
    whenOpen: {
      position: 'fixed',
      width: '100%',
      top: ''
    }
  };
  styles.content = {
    position: 'absolute',
    zIndex: '2',
    maxWidth: '100%',
    transition: function(instance) {
      return "transform " + (instance.options.animation / 1000) + "s, -webkit-transform " + (instance.options.animation / 1000) + "s";
    },
    margin: '0 auto'
  };
  styles.content.typeSpecific = {
    center: {
      left: '50%',
      transform: genTransformStyle('-50%, 0, 0'),
      margin: function(instance) {
        return instance.centerPopup(true);
      }
    },
    top: {
      top: 0,
      left: '50%',
      transform: genTransformStyle('-50%, -100%, 0'),
      whenOpen: {
        transform: genTransformStyle('-50%, 0, 0')
      }
    },
    bottom: {
      bottom: 0,
      left: '50%',
      transform: genTransformStyle('-50%, 100%, 0'),
      whenOpen: {
        transform: genTransformStyle('-50%, 0, 0')
      }
    }
  };
  styles.overlay = {
    position: 'fixed',
    zIndex: '1',
    left: '0',
    top: '0',
    width: '100vw',
    minHeight: '100vh',
    backgroundColor: 'rgba(0,0,0,0.88)'
  };
  markup = {
    popup: "<div class='Popup'></div>",
    content: "<div class='Popup-content'></div>",
    overlay: "<div class='Popup-overlay'></div>",
    close: "<div class='Popup-close'></div>",
    bodyWrapper: "<div class='bodyInnerwrap'></div>"
  };

  /**
  	 * The class used by popup instances of all kinds. This includes exit intents,
  	 * quote popups, screenshot lightboxes, etc.
  	 * 
  	 * @param {object} targetEl$  DOM/jQuery object reoresenting the dom element to be inserted into the popup.
  	 * @param {string} name       Unique name to be used as the ID of the popup.
   */
  Popup = function(targetEl, name, options) {
    var targetEl$;
    targetEl$ = $(targetEl);
    this.name = name != null ? name : name = genName();
    this.options = $.extend(true, {}, defaultOptions, options);
    this.eventCallbacks = {};
    this.isOpen = false;
    this.scrollOffset = 0;
    this.els = {};
    this.els.popup = $(markup.popup).attr('id', name);
    this.els.overlay = $(markup.overlay).appendTo(this.els.popup);
    this.els.close = $(markup.close).appendTo(this.els.popup);
    this.els.content = $(markup.content).appendTo(this.els.popup);
    this.els.target = targetEl$.first().appendTo(this.els.content);
    this.attachEvents();
    this.appendToDOM();
    return Popup.instances[this.name] = this;
  };
  Popup.version = '3.0.2';
  Popup.instances = {};
  Popup.isOpen = false;
  Popup.defaultOptions = defaultOptions = {
    'type': 'center',
    'closeOnEsc': true,
    'forceOpen': false,
    'closeOthers': true,
    'animation': 300,
    'styles': styles,
    'markup': markup
  };
  Popup.prototype.appendToDOM = function() {
    this.applyStyles(this.els.popup, this.options.styles.popup);
    this.applyStyles(this.els.content, this.options.styles.content, this.options.styles.content.typeSpecific[this.options.type]);
    this.applyStyles(this.els.overlay, this.options.styles.overlay);
    this.applyStyles(this.els.close, this.options.styles.close || {});
    return this.els.popup.prependTo(document.body);
  };
  Popup.prototype.centerPopup = function(justReturn) {
    var contentHeight, offset, windowHeight;
    contentHeight = this.els.content[0].clientHeight;
    windowHeight = window.innerHeight;
    if (contentHeight >= windowHeight - 80) {
      offset = window.innerWidth > 736 ? 100 : 60;
    } else {
      offset = (windowHeight - contentHeight) / 2;
    }
    if (justReturn) {
      return offset + "px auto";
    } else {
      return this.els.content[0].style.margin = offset + "px auto";
    }
  };
  Popup.prototype.applyStyles = function(el, styleObject, additional) {
    var key, returnedValue, target, value;
    if (additional) {
      styleObject = $.extend({}, styleObject, additional);
    }
    target = el[0] || el;
    for (key in styleObject) {
      value = styleObject[key];
      switch (typeof value) {
        case 'object':
          if (target.style[key] != null) {
            this.applyStyles(target, value);
          }
          break;
        case 'function':
          returnedValue = value(this);
          if (typeof returnedValue === 'object') {
            this.applyStyles(target, returnedValue);
          } else {
            target.style[key] = returnedValue;
          }
          break;
        default:
          target.style[key] = value;
      }
    }
    return el;
  };
  Popup.prototype.removeStyles = function(el, styleObject, stylesToReinstate) {
    var stylesToRemove;
    stylesToRemove = new function() {
      var key;
      for (key in styleObject) {
        this[key] = '';
      }
      return this;
    };
    return this.applyStyles(el, stylesToRemove, stylesToReinstate);
  };
  Popup.prototype.on = function(event, callback) {
    var base;
    if (typeof event === 'string' && typeof callback === 'function') {
      if ((base = this.eventCallbacks)[event] == null) {
        base[event] = [];
      }
      return this.eventCallbacks[event].push(callback);
    }
  };
  Popup.prototype.emit = function(event) {
    var ref;
    if (typeof event === 'string') {
      return (ref = this.eventCallbacks[event]) != null ? ref.forEach((function(_this) {
        return function(callback) {
          return callback(_this);
        };
      })(this)) : void 0;
    }
  };
  Popup.prototype.attachEvents = function() {
    this.els.close.add(this.els.overlay).on('click', (function(_this) {
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
    if (this.options.type === 'center') {
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
    this.els.overlay.off("click." + this.name);
    $(document).off("keyup." + this.name);
    return $(window).off("resize." + this.name);
  };
  Popup.prototype.close = function(preventOffsetReset) {
    var ref;
    if (this.isOpen) {
      this.emit('beforeClose');
      this.removeStyles(this.els.popup, this.options.styles.popup.whenOpen, this.options.styles.popup);
      this.removeStyles(this.els.content, this.options.styles.content.whenOpen, this.options.styles.content);
      this.removeStyles(this.els.content, (ref = this.options.styles.content.typeSpecific[this.options.type]) != null ? ref.whenOpen : void 0, this.options.styles.content.typeSpecific[this.options.type]);
      if (!preventOffsetReset) {
        setTimeout((function(_this) {
          return function() {
            _this.removeStyles(bodyWrapper$, _this.options.styles.bodyWrapper.whenOpen);
            return window.scroll(0, _this.scrollOffset + getDocumentOffset());
          };
        })(this), 400);
        $(document.body).removeClass('_popupOpen');
        Popup.isOpen = false;
      }
      this.isOpen = false;
      return this.emit('close');
    }
  };
  Popup.prototype.open = function() {
    var instance, k, ref, ref1;
    if (!Popup.isOpen || this.options.forceOpen) {
      this.emit('beforeOpen');
      if (Popup.isOpen && this.options.closeOthers) {
        ref = Popup.instances;
        for (k in ref) {
          instance = ref[k];
          if (instance.isOpen) {
            this.scrollOffset = instance.scrollOffset;
          }
          if (instance !== this) {
            instance.close(true);
          }
        }
      } else {
        this.scrollOffset = getScrollOffset();
        this.applyStyles(bodyWrapper$, this.options.styles.bodyWrapper.whenOpen, {
          'top': (0 - this.scrollOffset) + "px"
        });
      }
      this.applyStyles(this.els.popup, this.options.styles.popup.whenOpen);
      this.applyStyles(this.els.content, this.options.styles.content.whenOpen, (ref1 = this.options.styles.content.typeSpecific[this.options.type]) != null ? ref1.whenOpen : void 0);
      if (this.options.type === 'center') {
        this.centerPopup();
      }
      setTimeout(function() {
        return window.scroll(0, 0);
      });
      $(document.body).addClass('_popupOpen');
      Popup.isOpen = this.isOpen = true;
      return this.emit('open');
    }
  };
  Popup.prototype.destroy = function() {
    this.close();
    this.detachEvents();
    this.els.popup.remove();
    return delete Popup.instances[this.name];
  };
  Popup.prototype.replaceWith = function(el$) {
    return this.els.content.html(el$);
  };
  Popup.prototype.Open = Popup.prototype.open;
  Popup.prototype.Close = Popup.prototype.close;
  Popup.prototype.Destroy = Popup.prototype.destroy;
  bodyWrapper$ = $('<div></div>');
  $(function() {
    $(document.body).wrapInner(markup.bodyWrapper);
    return bodyWrapper$ = $(document.body).children('.bodyInnerwrap');
  });
  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    return module.exports = Popup;
  } else if (typeof define === 'function' && define.amd) {
    return define(['Popup'], function() {
      return Popup;
    });
  } else {
    return window.Popup = Popup;
  }
})(jQuery);
