// JavaScript Document by Finger
function checkFrameHeight() {
	var iframeid = document.getElementById("docFrame"); //iframe id
	iframeid.height = "0px";//先给一个够小的初值,然后再长高.
	if (document.getElementById) {
		if (iframeid && !window.opera) {
			if (iframeid.contentDocument && iframeid.contentDocument.body.offsetHeight) {
				iframeid.height = iframeid.contentDocument.body.offsetHeight+100;
			} else if (iframeid.Document && iframeid.Document.body.scrollHeight) {
				iframeid.height = iframeid.Document.body.scrollHeight+100;
			}
		}
	}else{
		if(iframeid.contentWindow.document && iframeid.contentWindow.document.body.scrollHeight) {
			iframeid.height = iframeid.contentWindow.document.body.scrollHeight;//Opera
		}
	}
} 