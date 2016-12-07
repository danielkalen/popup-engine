Popup::close = (preventOffsetReset)-> if @isOpen
	@emit('beforeClose')
	@removeStyles(@els.popup, @options.styles.popup.whenOpen, @options.styles.popup)
	@removeStyles(@els.content, @options.styles.content.whenOpen, @options.styles.content)
	@removeStyles(@els.content, @options.styles.content.typeSpecific[@options.type]?.whenOpen, @options.styles.content.typeSpecific[@options.type])
	
	unless preventOffsetReset
		setTimeout ()=>
			@removeStyles(bodyWrapper$, @options.styles.bodyWrapper.whenOpen)
			window.scroll(0, @scrollOffset+getDocumentOffset())
		, 400
	
		$(document.body).removeClass '_popupOpen'
		Popup.isOpen = false

	@isOpen = false
	@emit('close')



Popup::open = ()-> if not Popup.isOpen or @options.forceOpen # Only opens if no other popups are open, unless it's an exit-intent popup
	@emit('beforeOpen')

	if Popup.isOpen and @options.closeOthers
		for k,instance of Popup.instances
			@scrollOffset = instance.scrollOffset if instance.isOpen
			instance.close(true) unless instance is @
	else
		@scrollOffset = getScrollOffset()
		@applyStyles(bodyWrapper$, @options.styles.bodyWrapper.whenOpen, {'top': "#{0-@scrollOffset}px"})

	@applyStyles(@els.popup, @options.styles.popup.whenOpen)
	@applyStyles(@els.content, @options.styles.content.whenOpen, @options.styles.content.typeSpecific[@options.type]?.whenOpen)
	
	@centerPopup() if @options.type is 'center'
	setTimeout ()-> window.scroll(0, 0)

	$(document.body).addClass('_popupOpen')
	Popup.isOpen = @isOpen = true
	@emit('open')




Popup::destroy = ()->
	@close()
	@detachEvents()
	@els.popup.remove()
	delete Popup.instances[@name]



Popup::replaceWith = (el$)->
	@els.content.html el$
