do ($=jQuery)->
	import _parts/markup.coffee
	import _parts/styles.coffee
	import _parts/options.coffee
	import _parts/helpers.coffee
	###*
	 * The class used by popup instances of all kinds. This includes exit intents,
	 * quote popups, screenshot lightboxes, etc.
	 * 
	 * @param {object} targetEl$  jQuery object containing the form/dom element to be inserted into the popup.
	 * @param {string} name       Unique name to be used as the ID of the popup.
	###
	Popup = (targetEl$, name, options)->
		@name = name or 'popup_'+Math.floor(Math.random() * 100000)
		@form = targetEl$.data('Form') or targetEl$.children('form').data('Form')
		@options = $.extend(true, {}, defaultOptions, options)
		@isOpen = false
		@scrollOffset = 0

		@el = $(markup.popup).attr 'id', name
		@overlayEl = $(markup.popupOverlay).appendTo(@el)
		@closeEl = $(markup.popupClose).appendTo(@el)
		@contentEl = $(markup.popupContent).appendTo(@el)


		@appendToDOM(targetEl$)
		@attachEvents()

		return Popup.instances[@name] = @



	Popup.version = import '../.version.coffee'
	Popup.instances = {}
	Popup.isOpen = false # Indicates that any popup instance is open



	Popup::appendToDOM = (targetEl$)->
		applyStyles(@el, @options.style.popup)
		applyStyles(@contentEl, @options.style.popupContent)
		applyStyles(@overlayEl, @options.style.popupOverlay)
		applyStyles(@closeEl, @options.style.popupClose or {})
		@el.prependTo(document.body)

		targetEl$.first().appendTo @contentEl
	

	Popup::centerPopup = ()->
		contentHeight = @contentEl[0].clientHeight
		windowHeight = window.innerHeight
		
		if contentHeight >= windowHeight-80
			offset = if window.innerWidth > 736 then 100 else 60
		else
			offset = (windowHeight - contentHeight)/2
		
		@contentEl[0].style.margin = "#{offset}px auto"




	Popup::attachEvents = ()->
		# ==== Overlay / X-button eixt =================================================================================
		@closeEl.add(@overlayEl).on 'click', ()=> @close()

		
		# ==== ESC Button exit =================================================================================
		$(document).on "keyup.#{@name}", (event)=> if event.which is 27 and @isOpen and @options.closeOnEsc
			event.stopPropagation()
			event.preventDefault()
			@close()

		# ==== Center popup fix on resize =================================================================================
		if @options.centerPopup
			$(window).on "resize.#{@name}", ()=> @centerPopup() if @isOpen




	Popup::detachEvents = ()->
		@overlayEl.off "click.#{@name}"
		$(document).off "keyup.#{@name}"
		$(window).off "resize.#{@name}"
			





	Popup::close = ()-> if @isOpen
		@el.removeClass 'show'
			.addClass 'hiding'
		
		removeStyles(@el, @options.styleOpenState.popup, @options.style.popup)
		
		setTimeout ()=>
			@el.removeClass 'hiding'
			removeStyles(bodyWrapper$, @options.styleOpenState.bodyWrapper)

			window.scroll(0, @scrollOffset+getDocumentOffset())
		, 400
		
		$(document.body).removeClass '_popupOpen'

		Popup.isOpen = @isOpen = false
		@el.trigger 'closed'


	



	Popup::open = ()-> if not Popup.isOpen or @options.forceOpen # Only opens if no other popups are open, unless it's an exit-intent popup		
		$('.popup').removeClass('show') if @options.forceOpen
		
		if @el.find('.results').hasClass 'show'
			@el.addClass 'show'
		else
			@el.addClass 'show'
				.find '.step'
				.first().addClass 'show'

		@scrollOffset = getScrollOffset()
		applyStyles(@el, @options.styleOpenState.popup)
		applyStyles(bodyWrapper$, @options.styleOpenState.bodyWrapper, {'top': "#{0-@scrollOffset}px"})
		
		@centerPopup() if @options.centerPopup
		setTimeout ()-> window.scroll(0, 0)
	
		$(document.body).addClass('_popupOpen')
		Popup.isOpen = @isOpen = true
		@el.trigger 'opened'




	Popup::reset = ()-> # Resets all of the input fields inside any forms that are inside the popup and sets the first step of the popup to visible.
		@form.Restart(true, true) if @form
		@el.trigger 'reset'


	Popup::destroy = ()->
		@close()
		@detachEvents()
		@el.remove()
		delete Popup.instances[@name]


	Popup::replaceWith = (el$)->
		@contentEl.html el$






	# ==== Aliases =================================================================================
	Popup::Open = Popup::open
	Popup::Close = Popup::close
	Popup::Reset = Popup::reset
	Popup::restart = Popup::reset
	Popup::Destroy = Popup::destroy








	bodyWrapper$ = $('<div></div>')
	
	$ ()->
		$(document.body).wrapInner(markup.bodyWrapper)
		bodyWrapper$ = $(document.body).children('.bodyInnerwrap')
	
	window.Popup = Popup