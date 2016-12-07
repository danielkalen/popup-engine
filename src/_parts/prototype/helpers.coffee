Popup::appendToDOM = ()->
	@applyStyles(@els.popup, @options.styles.popup)
	@applyStyles(@els.content, @options.styles.content, @options.styles.content.typeSpecific[@options.type])
	@applyStyles(@els.overlay, @options.styles.overlay)
	@applyStyles(@els.close, @options.styles.close or {})
	
	@els.popup.prependTo(document.body)



Popup::centerPopup = (justReturn)->
	contentHeight = @els.content[0].clientHeight
	windowHeight = window.innerHeight
	
	if contentHeight >= windowHeight-80
		offset = if window.innerWidth > 736 then 100 else 60
	else
		offset = (windowHeight - contentHeight)/2
	
	if justReturn
		return "#{offset}px auto"
	else
		@els.content[0].style.margin = "#{offset}px auto"




Popup::applyStyles = (el, styleObject, additional)->
	styleObject = $.extend {}, styleObject, additional if additional
	target = (el[0] or el)
	
	for key,value of styleObject
		switch typeof value
			when 'object'
				@applyStyles(target, value) if target.style[key]?

			when 'function'
				returnedValue = value(@)
				if typeof returnedValue is 'object'
					@applyStyles(target, returnedValue)
				else
					target.style[key] = returnedValue
			
			else
				target.style[key] = value

	return el


Popup::removeStyles = (el, styleObject, stylesToReinstate)->
	stylesToRemove = new ()-> @[key]='' for key of styleObject; @

	@applyStyles(el, stylesToRemove, stylesToReinstate)