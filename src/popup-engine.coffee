do ($=jQuery)->
	import _parts/styles.coffee
	import _parts/markup.coffee
	###*
	 * The class used by popup instances of all kinds. This includes exit intents,
	 * quote popups, screenshot lightboxes, etc.
	 * 
	 * @param {object} popup$ jQuery object containing the form/dom element to be inserted into the popup.
	 * @param {string} name  Unique name to be used as the ID of the popup.
	###
	Popup = (popup$, name)->
		@name = name or 'popup_'+Math.floor(Math.random() * 100000)
		@form = popup$.data('Form') or popup$.children('form').data('Form')
		@el = $(markup.popup).attr 'id', name
		@overlayEl = $(markup.popupOverlay).appendTo(@el)
		@closeEl = $(markup.popupClose).appendTo(@el)
		@contentEl = $(markup.popupContent).appendTo(@el)
		@options = 'closeOnEsc':true
		@isExitIntent = name.includes 'exit-intent'
		@isOpen = false


		@appendToDOM(popup$)
		@attachEvents()

		return Popup.instances[@name] = @



	Popup.version = import '../.version.coffee'
	Popup.instances = {}
	Popup.isOpen = false # Indicates that any popup instance is open



	Popup::appendToDOM = (popup$)->
		@el.prependTo(document.body)

		popup$.first().appendTo @contentEl




	Popup::attachEvents = ()->
		# ==== Overlay / X-button eixt =================================================================================
		@closeEl.add(@overlayEl).on 'click', ()=> @close()

		
		# ==== ESC Button exit =================================================================================
		$(document).on "keyup.#{@name}", (event)=> if event.which is 27 and @isOpen and @options.closeOnEsc
			event.stopPropagation()
			event.preventDefault()
			@close()




	Popup::detachEvents = ()->
		@overlayEl.off "click.#{@name}"
		$(document).off "keyup.#{@name}"
			





	Popup::close = ()-> if @isOpen
		@el.removeClass 'show'
			.addClass 'hiding'
			[0].style = styles.popup
		
		setTimeout ()=>
			@el.removeClass 'hiding'
		, 1000
		
		$(document.body).removeClass 'opened-popup'

		Popup.isOpen = @isOpen = false
		@el.trigger 'closed'


	



	Popup::open = ()-> if not Popup.isOpen or @isExitIntent # Only opens if no other popups are open, unless it's an exit-intent popup		
		$('.popup').removeClass('show') if @isExitIntent
		
		if @el.find('.results').hasClass 'show'
			@el.addClass 'show'
		else
			@el.addClass 'show'
				.find '.step'
				.first().addClass 'show'

		@el[0].style = styles.popupStateOpen
		$(document.body).addClass('opened-popup')
	
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











	window.Popup = Popup