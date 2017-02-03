do ($=jQuery)->
	import _parts/helpers.coffee
	import _parts/styles.coffee
	import _parts/markup.coffee

	###*
	 * The class used by popup instances of all kinds. This includes exit intents,
	 * quote popups, screenshot lightboxes, etc.
	 * 
	 * @param {object} targetEl$  DOM/jQuery object reoresenting the dom element to be inserted into the popup.
	 * @param {string} name       Unique name to be used as the ID of the popup.
	###
	Popup = (targetEl, name, options)->
		targetEl$ = $(targetEl)
		@name = name ?= genName()
		@options = $.extend(true, {}, defaultOptions, options)
		@eventCallbacks = {}
		@isOpen = false
		@scrollOffset = 0

		@els = {}
		@els.popup = $(markup.popup).attr 'id', name
		@els.overlay = $(markup.overlay).appendTo(@els.popup)
		@els.close = $(markup.close).appendTo(@els.popup)
		@els.content = $(markup.content).appendTo(@els.popup)
		@els.target = targetEl$.first().appendTo(@els.content)

		@attachEvents()
		@appendToDOM()
		return Popup.instances[@name] = @



	Popup.version = import '../.version.coffee'
	Popup.instances = {}
	Popup.isOpen = false # Indicates that any popup instance is open
	Popup.defaultOptions = import _parts/options.coffee
	import _parts/prototype/




	bodyWrapper$ = $('<div></div>')
	
	$ ()->
		$(document.body).wrapInner(markup.bodyWrapper)
		bodyWrapper$ = $(document.body).children('.bodyInnerwrap')
	


	
	if module?.exports?
		module.exports = Popup
	else if typeof define is 'function' and define.amd
		define ['Popup'], ()-> Popup
	else
		window.Popup = Popup