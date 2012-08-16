package com.riameeting.utils
{
	/**
	 * 字符串工具类
	 */
	public class StringUtils {
		/**
		 * 删除字符串两端的空格
		 * @param str
		 * @return 
		 * 
		 */		
		public static function trim(str:String):String {
			var strRep:String = str.replace(/^\s*/, "");
			strRep = strRep.replace(/\s*$/, "");
			return strRep;
		}
		/**
		 * 将字符串转换成为标准变量命名格式，比如:bgColor
		 * @param str
		 * @return 
		 * 
		 */		
		public static function toCamelCase(str:String):String {
			str = str.replace("-", " ");
			str = toProperCase(str).replace(" ", "");
			function capsFn():String {
				return arguments[0].toLowerCase();
			}
			return str.replace(/\b\w/g, capsFn);
		}
		/**
		 * 将字符串单词的首字母转换为大写格式
		 * @param str
		 * @return 
		 * 
		 */		
		public static function toProperCase(str:String):String {
			function capsFn():String {
				return arguments[0].toUpperCase();
			}
			return str.toLowerCase().replace(/^[a-z\xE0-\xFF]|\s[a-z\xE0-\xFF]/g, capsFn); //replaces first letter of each word
		}
	}
}