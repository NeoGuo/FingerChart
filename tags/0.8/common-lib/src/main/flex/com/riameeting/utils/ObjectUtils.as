package com.riameeting.utils
{
	/**
	 * 对象工具类
	 * @author Finger
	 * 
	 */	
	public class ObjectUtils
	{
		/**
		 * 合并两个对象的属性到一个新对象
		 * @param obj1
		 * @param obj2
		 * @return 
		 * 
		 */		
		public static function mergePromps(obj1:Object,obj2:Object):Object {
			var newObj:Object = new Object();
			var name:String;
			for(name in obj2) {
				newObj[name] = obj2[name];
			}
			for(name in obj1) {
				newObj[name] = obj1[name];
			}
			return newObj;
		}
	}
}