getScrollOffset = ()->
	window.scrollY - getDocumentOffset()

getDocumentOffset = ()->
	(document.body.getBoundingClientRect()?.top or 0) + window.scrollY


genName = ()->
	'popup_'+Math.floor(Math.random() * 100000)




genTransformStyle = (value, scaleValue)->
	scale = if scaleValue? then "scale(#{scaleValue})" else ''
	translate = "translate3d(#{value})"
	transformString = "#{translate} #{scale}"

	webkitTransform: transformString
	mozTransform: transformString
	msTransform: transformString
	oTransform: transformString
	transform: transformString



genTransformOriginStyle = (xValue)->
	webkitTransformOrigin: "#{xValue} 0%"
	mozTransformOrigin: "#{xValue} 0%"
	msTransformOrigin: "#{xValue} 0%"
	oTransformOrigin: "#{xValue} 0%"
	transformOrigin: "#{xValue} 0%"


