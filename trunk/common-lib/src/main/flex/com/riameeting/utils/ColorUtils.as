package com.riameeting.utils
{
	
	/**
	 * 颜色工具
	 */
	public final class ColorUtils {
		
		/**
		 * 合并色值
		 */
		public static function fadeColor(startColor:uint, endColor:uint, position:Number):uint {
			var r:uint = startColor >> 16;
			var g:uint = startColor >> 8 & 0xFF;
			var b:uint = startColor & 0xFF;
			r += ((endColor >> 16) - r) * position;
			g += ((endColor >> 8 & 0xFF) - g) * position;
			b += ((endColor & 0xFF) - b) * position;
			return (r << 16 | g << 8 | b);
		}
		/**
		 * 将色值转换为WEB色值
		 * @param color
		 * @return 
		 * 
		 */		
		public static function toWebColor(color:uint):String {
			var colorStr:String = color.toString(16);
			return "#"+colorStr;
		}
		
	}
	
}