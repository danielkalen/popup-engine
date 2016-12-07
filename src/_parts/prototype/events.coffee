Popup::on = (event, callback)-> if typeof event is 'string' and typeof callback is 'function'
	@eventCallbacks[event] ?= []
	@eventCallbacks[event].push(callback)

Popup::emit = (event)-> if typeof event is 'string'
	@eventCallbacks[event]?.forEach (callback)=> callback(@)



Popup::attachEvents = ()->
	# ==== Overlay / X-button eixt =================================================================================
	@els.close.add(@els.overlay).on 'click', ()=> @close()

	
	# ==== ESC Button exit =================================================================================
	$(document).on "keyup.#{@name}", (event)=> if event.which is 27 and @isOpen and @options.closeOnEsc
		event.stopPropagation()
		event.preventDefault()
		@close()

	# ==== Center popup fix on resize =================================================================================
	if @options.type is 'center'
		$(window).on "resize.#{@name}", ()=> @centerPopup() if @isOpen




Popup::detachEvents = ()->
	@els.overlay.off "click.#{@name}"
	$(document).off "keyup.#{@name}"
	$(window).off "resize.#{@name}"