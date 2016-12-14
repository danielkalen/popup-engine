# Popup Engine
Popup creation and interaction engine.

## Installation
`npm install popup-engine`

## Example Usage
```javascript
var popupInstance = new Popup($('#popup-content'), 'optionalName');

popupInstance.open()
setTimeout(function(){
    popupInstance.close() // Close/dismiss after 5 seconds
}, 5000)
```


## API
### `new Popup(contentElement[, name][, options])`
Generates and returns a new Popup instance for the specified `contentElement`.

Arguments:
  - `contentElement` - A jQuery element or a raw DOM element which will be moved into the popup's content container.
  - `name` (optional) - Name to use for the popup instance which will be used as the popup element's ID attribute and can be used as the reference to the popup instance in `Popup.instances`.
  - `options` (optional) - a custom options object (see defaults below).


### `Popup.version`
The version of this release.

### `Popup.isOpen`
Boolean indicator of whether or not any popup instance is currently open/being displayed.

### `Popup.instances`
Object containing references to popup instances by their names.

### `Popup.defaultOptions`
  - `type` [default:'center'] - controls the placement, styling, and open/close animation of the popup element. If specified anything other than what's available the popup won't have specific styling/animations.
      - Possible options: `center`, `top`, `bottom`.
  - `closeOnEsc` [default:true] - whether or not the popup should be closed upon pressing the Esc key.
  - `forceOpen` [default:false] - whether or not the popup should open even if there is another popup instance open at the same time.
  - `closeOthers` [default:true] - if `forceOpen` is true, other popups will be forcley closed.
  - `animation` [default:300] - animation rate/speed of the open/close animations.
  - `styles` - object containing the styles map used for popup elements (see defaults below).
  - `markup` - object containing the HTML markup map used for popup elements (see defaults below).


### `popupInstance.open()`
Opens/reveals the popup element.

### `popupInstance.close()`
Closes/hides the popup element.

### `popupInstance.destroy()`
Removes the popup element from the DOM & destroys the popup instance.

### `popupInstance.replaceWith(contentElement)`
Replace the popup's content with the specified contentElement.

Arguments:
  - `contentElement` - A jQuery element or a raw DOM element which will be moved into the popup's content container.




## Default Styles
```javascript
styles = {
    popup: {
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
    },
    
    bodyWrapper : {
        whenOpen: {
            position: 'fixed',
            width: '100%',
            top: ''
        }
    },

    overlay: {
        position: 'fixed',
        zIndex: '1',
        left: '0',
        top: '0',
        width: '100vw',
        minHeight: '100vh',
        backgroundColor: 'rgba(0,0,0,0.88)'
    },
    
    content: {
        position: 'absolute',
        zIndex: '2',
        maxWidth: '100%',
        margin: '0 auto',
        transition: function(instance) {
            return "transform " + (instance.options.animation / 1000) + "s, -webkit-transform " + (instance.options.animation / 1000) + "s";
        },
        typeSpecific: {
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
        }
    }
};
```


## Default Markup
```javascript
markup = {
  popup: "<div class='Popup'></div>",
  content: "<div class='Popup-content'></div>",
  overlay: "<div class='Popup-overlay'></div>",
  close: "<div class='Popup-close'></div>",
  bodyWrapper: "<div class='bodyInnerwrap'></div>"
};
```



