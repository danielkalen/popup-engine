getScrollOffset = ()->
	window.scrollY - getDocumentOffset()

getDocumentOffset = ()->
	(document.body.getBoundingClientRect()?.top or 0) + window.scrollY

applyStyles = (el, styleObject, additional)->
	styleObject = $.extend {}, styleObject, additional if additional
	
	for key,value of styleObject
		(el[0] or el).style[key] = value

	return el


removeStyles = (el, styleObject, stylesToReinstate)->
	for key of styleObject
		(el[0] or el).style[key] = ''

	applyStyles(el, stylesToReinstate) if stylesToReinstate

	return el