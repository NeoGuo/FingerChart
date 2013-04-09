package com.riameeting.finger.factory
{
	import flash.utils.Dictionary;
	/**
	 * 对象工厂
	 * @author Finger
	 * 
	 */
	public class ObjectFactory
	{
		/**
		 * 对象哈希表
		 */		
		private static var cacheDic:Dictionary = new Dictionary();
		/**
		 * 生产对象，如果有缓存则直接提供，否则创建
		 * @param clazz 类
		 * @return 对象
		 * 
		 */		
		public static function produce(clazz:Class,key:String,parms:Array=null):* {
			if(cacheDic[key] == null) cacheDic[key] = [];
			var object:Object;
			if(cacheDic[key].length>0) {
				object = cacheDic[key].shift();
			} else {
				if(parms == null) {
					object = new clazz();
				} else {
					//FIXME:这是一个临时策略，需要修改为完全支持参数传递的方式
					switch(parms.length) {
						case 1:
							object = new clazz(parms[0]);
							break;
						case 2:
							object = new clazz(parms[0],parms[1]);
							break;
						case 3:
							object = new clazz(parms[0],parms[1],parms[2]);
							break;
						case 4:
							object = new clazz(parms[0],parms[1],parms[2],parms[3]);
							break;
						case 5:
							object = new clazz(parms[0],parms[1],parms[2],parms[3],parms[4]);
							break;
						case 6:
							object = new clazz(parms[0],parms[1],parms[2],parms[3],parms[4],parms[5]);
							break;
					}
				}
			}
			return object;
		}
		/**
		 * 回收对象
		 * @param clazz 类
		 * @param object 对象
		 * 
		 */		
		public static function reclaim(clazz:Class,object:*,key:String):void {
			if(cacheDic[key] == null) return;
			cacheDic[key].push(object);
		}
		
	}
}