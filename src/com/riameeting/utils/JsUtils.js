/**
 * ...
 * @author 黄龙
 */
var JsUtils={
function getzwcData() {
	var data=getData();
	//alert("getzwcData");
	if(data!=null)
	{
		alert(data);
		var swf =  thisMovie("chart");
		swf.setJSONData(data);
	}
	else
	{
		setTimeout("getzwcData()",1000);
	}
}

function thisMovie(movieName) {
   if (/MSIE/.test(navigator.userAgent)) {
      return document.getElementById(movieName);
    }else {
      return document.embeds[movieName];
   }
 }
}