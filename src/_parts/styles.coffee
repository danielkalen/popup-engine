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
		left: 0;
		right: 0;
		top: 50%;
		-webkit-transform: translateY(-50%);
		-moz-transform: translateY(-50%);
		-ms-transform: translateY(-50%);
		-o-transform: translateY(-50%);
		transform: translateY(-50%);
		margin: 0 auto;
	"

	popupOverlay: "
		position: fixed;
		left: 0;
		top: 0;
		background-color: rgba(0,0,0,0.88);
	"


styles.popupStateOpen = styles.popup
	.replace 'opacity: 0', 'opacity: 1'
	.replace 'visibility: hidden', 'visibility: visible'