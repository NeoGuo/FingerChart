package com.riameeting.utils
{
	import flash.system.Capabilities;
	import ghostcat.debug.Debug;
	
	/**
	 * 字符串工具类
	 */
	public class StringUtils
	{
		/**
		 * 删除字符串两端的空格
		 * @param str
		 * @return
		 *
		 */
		public static function trim(str:String):String
		{
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
		public static function toCamelCase(str:String):String
		{
			str = str.replace("-", " ");
			str = toProperCase(str).replace(" ", "");
			function capsFn():String
			{
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
		public static function toProperCase(str:String):String
		{
			function capsFn():String
			{
				return arguments[0].toUpperCase();
			}
			return str.toLowerCase().replace(/^[a-z\xE0-\xFF]|\s[a-z\xE0-\xFF]/g, capsFn); //replaces first letter of each word
		}
		
		private static var strArr:Array
		
		/**
		 * 100000->10万
		 * @param	num
		 * @return
		 */
		public static function numberToUnitString(num:Number):String
		{
			var unitString:String = getLangUnit(10000);
			var rStr:String = '';
			if (unitString != null)
			{
				if (num >= 100000000)
				{
					unitString = getLangUnit(100000000);
					rStr = num / 100000000 + unitString;
				}
				else if (num >= 10000000)
				{
					unitString = getLangUnit(10000000);
					rStr = num / 10000000 + unitString;
				}
				else if (num >= 1000000)
				{
					unitString = getLangUnit(1000000);
					rStr = num / 1000000 + unitString;
				}
				else if (num >= 10000)
				{
					unitString = getLangUnit(10000);
					rStr = num / 10000 + unitString;
				}
				else if (num >= 1000)
				{
					unitString = getLangUnit(1000);
					rStr = num / 1000 + unitString;
				}
				else
				{
					rStr = num.toString();
				}
			}
			else
			{
				rStr = num.toString();
			}
			return rStr;
		}
		
		/**
		 * 序列化数字为字符串
		 * @param	num 
		 * @return 	转换好的字符串
		 */
		public static function fomart(num:Number):String
		{
			var rStr:String = '';
			var arr:Array = String(num).split('.');
			var len:int = Math.ceil(String(arr[0]).length / 3);
			var i:int = 0;
			if (arr[0].length % 3 == 0)
			{
				for (i = 0;i < len; i++)
				{
					if (i == len - 1)
					{
						rStr += String(arr[0]).substr(arr[0].length % 3 + i * 3, 3);
						break;
					}
					rStr += String(arr[0]).substr(arr[0].length % 3 + i  * 3, 3) + ",";
				}
			}
			else
			{
				if (arr[0].length > 3)
				{
					rStr = String(arr[0]).substr(0, arr[0].length % 3)+',';
					for (i = 1;i < len; i++)
					{
						if (i == len - 1)
						{
							rStr += String(arr[0]).substr(arr[0].length % 3 + (i-1) * 3, 3);
							break;
						}
						rStr += String(arr[0]).substr(arr[0].length % 3 + (i-1)* 3, 3) + ",";
					}
				}
				else
				{
					rStr = String(arr[0]).substr(0, arr[0].length % 3);
				}
			}
			//String(arr[0]).
			if (arr.length > 1)
			{
				rStr += "."+arr[1];
			}
			return rStr;
		}
		
		/**
		 * 转换单位万和亿
		 * @param	num
		 * @return
		 */
		public static function numberToUnitString2(num:Number):String
		{
			
			var unitString:String = getLangUnit(10000);
			var rStr:String = '';
			var rNum:Number;
			if (unitString != null)
			{
				if (num >= 100000000)
				{
					unitString = getLangUnit(100000000);
					rNum = Math.floor(num / 100000000);
					rStr = Number(num / 100000000).toFixed(1) + unitString;
				}
				else if (num >= 10000)
				{
					unitString = getLangUnit(10000);
					rNum = Math.floor(num / 10000);
					rStr = Number(num / 10000).toFixed(1) + unitString;
				}
				else
				{
					rStr = num.toString();
				}
				
			}
			else
			{
				rStr = num.toString();
			}
			Debug.trace('单位转换', num, rStr);
			return rStr;
		}
		
		/**
		 * 转换单位万和亿
		 * @param	num
		 * @return
		 */
		public static function numberToUnitHtmlString2(num:Number):String
		{
			
			var unitString:String = getLangUnit(10000);
			var rStr:String = '';
			var rNum:Number;
			if (unitString != null)
			{
				if (num >= 100000000)
				{
					unitString = getLangUnit(100000000);
					rNum = Math.floor(num / 100000000);
					rStr = Math.round(Number(num / 100000000)) + "<font face='SongTi'><b>"+unitString+"</b></font>";
				}
				else if (num >= 10000)
				{
					unitString = getLangUnit(10000);
					rNum = Math.floor(num / 10000);
					rStr = Math.round(Number(num / 10000)) + "<font face='SongTi'><b>"+unitString+"</b></font>";
				}
				else
				{
					rStr = num.toString();
				}
				
			}
			else
			{
				rStr = num.toString();
			}
			Debug.trace('单位转换', num, rStr);
			return rStr;
		}
		
		private static function getLangUnit(num:Number):String
		{
			if (strArr == null)
			{
				strArr = [];
				strArr['zh-CN1000'] = "千";
				strArr['zh-CN10000'] = "万";
				strArr['zh-CN1000000'] = "百万";
				strArr['zh-CN10000000'] = "千万";
				strArr['zh-CN100000000'] = "亿";
				strArr['zh-TW1000'] = "千";
				strArr['zh-TW10000'] = "萬";
				strArr['zh-TW1000000'] = "百萬";
				strArr['zh-TW10000000'] = "千萬";
				strArr['zh-TW100000000'] = "億";
				//strArr['zh-TW10000']="萬";
			}
			return strArr[Capabilities.language + num];
		}
	}
}