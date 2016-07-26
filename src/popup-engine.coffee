do ($=jQuery)->
	# ==== Append Popup Overlay =================================================================================
	window.popupOpen = false
	window.appendPopup = ()->
		$(document.body).prepend('<div class="popup-overlay"></div>') if $('.popup-overlay').length is 0
	
	appendPopup()
	$popupOverlay = $('.popup-overlay')


	###*
	 * The class used by popup instances of all kinds. This includes exit intents,
	 * quote popups, screenshot lightboxes, etc.
	 * 
	 * @param {object} $popup jQuery object containing the form/dom element to be inserted into the popup.
	 * @param {string} name  Unique name to be used as the ID of the popup.
	###
	@Popup = ($popup, name)->
		@name = name or 'popup_'+Math.floor(Math.random() * 100000)
		@form = $popup.data('Form') or $popup.children('form').data('Form')
		@el = $("<div class='popup' id='#{name}'><div class='popup-close'></div><div class='popup-content'></div></div>")
		@Popup = @el # alias for dependents using the older API

		isExitIntent = name.includes('exit-intent')
		
		@el.insertAfter $popupOverlay



		###*
		 * Closes the popup on demand and hides the overlay that belongs to @ instance.
		###
		@close = ()->
			@el.addClass('hiding').removeClass('show');
			setTimeout ()=>
				@el.removeClass('hiding');
			, 1000
			
			$popupOverlay.removeClass("show belongs_to_#{@name}");
			$(document.body).removeClass('opened-popup');
			popupOpen = false;

			@el.trigger('closed');



		###*
		 * Opens the popup on demand only if no other popup is open (unless an exit intent needs to open).
		###
		@open = ()->
			if !popupOpen or isExitIntent
				$popupOverlay.addClass("show belongs_to_#{@name}")
				
				$('.popup').removeClass('show') if isExitIntent
				
				if @el.find('.results').hasClass 'show'
					@el.addClass('show');
				else
					@el.addClass('show')
						.find('.step').first()
							.addClass('show')

				$(document.body).addClass('opened-popup');

			if popupOpen and !isExitIntent then log('Another popup is open.')
			
			disableExitIntents?()
			popupOpen = true
			
			@el.trigger('opened')




		###*
		 * Resets all of the input fields inside any forms that are inside the popup and sets the
		 * first step of the popup to visible.
		###
		@reset = ()->
			@form.Restart true, true
			@el.trigger('reset')

		@restart = @reset



		###*
		 * Detroys the popup instance.
		###
		@destroy = ()-> @el.remove()


		@replaceWith = ($el)-> @el.children('.popup-content').html $el














		# ==== Move form into new popup =================================================================================
		$popup.first().appendTo @el.find('.popup-content')

			


		# ==== Event attachment =================================================================================
		@el.children('.popup-close').on 'click', ()=> @close()

		$popupOverlay.on 'click', ()->
			setTimeout ()=>
				$(@).removeClass("show belongs_to_#{name}")
			, 0

			$('.popup.show').removeClass('show')
			$(document.body).removeClass('opened-popup')
			
			popupOpen = false
			





		# ==== Method aliases =================================================================================
		@Close = @close
		@Open = @open
		@Reset = @reset
		@Destroy = @destroy




		return @

