do ($=jQuery)->
	# ==== Append Popup Overlay =================================================================================
	popupOverlay$ = $('.popup-overlay')
	appendPopup = ()-> if popupOverlay$.length is 0
		popupOverlay$ = $('<div class="popup-overlay"></div>').prependTo(document.body)
	
	appendPopup()


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
		@el = $("<div class='popup' id='#{name}'><div class='popup-close'></div><div class='popup-content'></div></div>")
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
		appendPopup()
		@el.insertAfter popupOverlay$

		popup$.first().appendTo @el.find('.popup-content')




	Popup::attachEvents = ()->
		# ==== X button eixt =================================================================================
		@el.children('.popup-close').on 'click', ()=> @close()

		# ==== Overlay click exit =================================================================================
		popupOverlay$.on "click.#{@name}", ()=>
			setTimeout ()=> popupOverlay$.removeClass("show belongs_to_#{@name}")

			$('.popup.show').removeClass 'show'
			$(document.body).removeClass 'opened-popup'
			
			Popup.isOpen = false
			@close()

		
		# ==== ESC Button exit =================================================================================
		$(document).on "keyup.#{@name}", (event)=> if event.which is 27 and @isOpen and @options.closeOnEsc
			event.stopPropagation()
			event.preventDefault()
			@close()




	Popup::detachEvents = ()->
		popupOverlay$.off "click.#{@name}"
		$(document).off "keyup.#{@name}"
			





	Popup::close = ()-> if @isOpen
		@el.removeClass 'show'
			.addClass 'hiding'
		
		setTimeout ()=>
			@el.removeClass 'hiding'
		, 1000
		
		popupOverlay$.removeClass "show belongs_to_#{@name}"
		$(document.body).removeClass 'opened-popup'

		Popup.isOpen = @isOpen = false
		@el.trigger 'closed'


	



	Popup::open = ()-> if not Popup.isOpen or @isExitIntent # Only opens if no other popups are open, unless it's an exit-intent popup
		popupOverlay$.addClass("show belongs_to_#{@name}")
		
		$('.popup').removeClass('show') if @isExitIntent
		
		if @el.find('.results').hasClass 'show'
			@el.addClass 'show'
		else
			@el.addClass 'show'
				.find '.step'
				.first().addClass 'show'

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
		@el.children('.popup-content').html el$






	# ==== Aliases =================================================================================
	Popup::Open = Popup::open
	Popup::Close = Popup::close
	Popup::Reset = Popup::reset
	Popup::restart = Popup::reset
	Popup::Destroy = Popup::destroy











	window.Popup = Popup