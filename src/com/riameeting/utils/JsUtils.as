package com.riameeting.utils 
{
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author 黄龙
	 */
	public class JsUtils 
	{
		[Embed(source = "JsUtils.js",mimeType="application/octet-stream")]
		private static var jsCode:Class;
		ExternalInterface.available && ExternalInterface.call("eval", new jsCode().toString());
		
		private static var _instance:JsUtils;
		public function JsUtils() 
		{
			
		}
		
		public function getData():void
        {
			if (!ExternalInterface.available)
			{
				return ;
			}
			ExternalInterface.call("JsUtils.getzwcData");
        }
		
		public static function getInstance():JsUtils 
		{
			if (_instance == null)
			{
				_instance = new JsUtils();
			}
			return _instance;
		}
		
	}

}