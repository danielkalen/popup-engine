style = 
	popup: 
		position: 'absolute'
		zIndex: '3000'
		top: '0'
		left: '0'
		width: '100vw'
		minHeight: '100%'
		visibility: 'hidden'
		opacity: '0'
		transition: 'all 0.3s'

	popupContent:
		position: 'absolute'
		zIndex: '2'
		left: '50%'
		maxWidth: '100%'
		webkitTransform: 'translate3d(-50%, 0, 0)'
		mozTransform: 'translate3d(-50%, 0, 0)'
		msTransform: 'translate3d(-50%, 0, 0)'
		oTransform: 'translate3d(-50%, 0, 0)'
		transform: 'translate3d(-50%, 0, 0)'
		margin: '0 auto'

	popupOverlay:
		position: 'fixed'
		zIndex: '1'
		left: '0'
		top: '0'
		width: '100vw'
		minHeight: '100vh'
		backgroundColor: 'rgba(0,0,0,0.88)'


styleOpenState =
	popup:
		opacity: '1'
		visibility: 'visible'

	bodyWrapper:
		position: 'fixed'	
		width: '100%'
		top: ''


# style = 
# 	popup: "
# 		position: absolute;
# 		z-index: 3000;
# 		top: 0;
# 		left: 0;
# 		width: 100vw;
# 		min-height: 100%;
# 		visibility: hidden;
# 		opacity: 0;
# 		transition: all 0.3s;
# 	"

# 	popupContent: "
# 		position: absolute;
# 		left: 50%;
# 		-webkit-transform: translate3d(-50%, 0, 0);
# 		-moz-transform: translate3d(-50%, 0, 0);
# 		-ms-transform: translate3d(-50%, 0, 0);
# 		-o-transform: translate3d(-50%, 0, 0);
# 		transform: translate3d(-50%, 0, 0);
# 		margin: 0 auto;
# 	"

# 	popupOverlay: "
# 		position: fixed;
# 		left: 0;
# 		top: 0;
# 		width: 100vw;
# 		min-height: 100vh;
# 		background-color: rgba(0,0,0,0.88);
# 	"

# styleOpenState =
# 	popup: do ()->
# 		style.popup
# 			.replace 'opacity: 0', 'opacity: 1'
# 			.replace 'visibility: hidden', 'visibility: visible'
	

# 	bodyWrapper: "
# 		position: fixed;
# 		width: 100%;
# 		top: {{topOffset}}px;
# 	"

