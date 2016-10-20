styles = 
	popup: "
		position: absolute;
		z-index: 3000;
		top: 0;
		left: 0;
		width: 100vw;
		min-height: 100%;
		visibility: hidden;
		opacity: 0;
		transition: all 0.4s;
	"

	popupContent: "
		position: absolute;
		left: 50%;
		top: 50%;
		-webkit-transform: translate3d(-50%, -50%, 0);
		-moz-transform: translate3d(-50%, -50%, 0);
		-ms-transform: translate3d(-50%, -50%, 0);
		-o-transform: translate3d(-50%, -50%, 0);
		transform: translate3d(-50%, -50%, 0);
		margin: 0 auto;
	"

	popupOverlay: "
		position: fixed;
		left: 0;
		top: 0;
		width: 100vw;
		min-height: 100vh;
		background-color: rgba(0,0,0,0.88);
	"


styles.popupStateOpen = styles.popup
	.replace 'opacity: 0', 'opacity: 1'
	.replace 'visibility: hidden', 'visibility: visible'