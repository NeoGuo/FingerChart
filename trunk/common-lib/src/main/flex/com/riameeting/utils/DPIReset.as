package com.riameeting.utils
{
	import flash.system.Capabilities;
	/**
	 * got number via DPI refect
	 * @author RIADEV
	 * 
	 */
	public class DPIReset
	{
		public static var applicationDPI:Number = 240;
		
		public static function getNumber(value:Number):Number
		{
			var dpi:Number = getRuntimeDPI();
			return value*(dpi/applicationDPI);
		}
		
		public static function getRuntimeDPI():Number
		{
			// Arbitrary mapping for Mac OS.
			if (Capabilities.os == "Mac OS 10.6.5")
				return 320;
			
			if (Capabilities.screenDPI < 200)
				return 160;
			
			if (Capabilities.screenDPI <= 280)
				return 240;
			
			return 320;
		}
		
	}
}