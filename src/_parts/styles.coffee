styles = {}
styles.popup =
	position: 'absolute'
	zIndex: '3000'
	top: '0'
	left: '0'
	width: '100vw'
	minHeight: '100%'
	opacity: '0'
	visibility: 'hidden'
	overflow: 'hidden'
	height: 0
	transition: (instance)-> "all #{instance.options.animation/1000}s"

	whenOpen:
		opacity: '1'
		visibility: 'visible'
		overflow: 'visible'
		height: 'auto'


styles.bodyWrapper = 
	whenOpen:
		position: 'fixed'	
		width: '100%'
		top: ''


styles.content =
	position: 'absolute'
	zIndex: '2'
	maxWidth: '100%'
	transition: (instance)-> "transform #{instance.options.animation/1000}s, -webkit-transform #{instance.options.animation/1000}s"
	margin: '0 auto'

styles.content.typeSpecific = 
	center:
		left: '50%'
		transform: genTransformStyle('-50%, 0, 0')
		margin: (instance)-> instance.centerPopup(true)

	top:
		top: 0
		left: '50%'
		transform: genTransformStyle('-50%, -100%, 0')
		whenOpen:
			transform: genTransformStyle('-50%, 0, 0')

	bottom:
		bottom: 0
		left: '50%'
		transform: genTransformStyle('-50%, 100%, 0')
		whenOpen:
			transform: genTransformStyle('-50%, 0, 0')


styles.overlay =
	position: 'fixed'
	zIndex: '1'
	left: '0'
	top: '0'
	width: '100vw'
	minHeight: '100vh'
	backgroundColor: 'rgba(0,0,0,0.88)'