package com.riameeting.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
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
		
		/**
		 * 复制对象
		 *  
		 * @param obj	要复制的对象
		 * @param includeClass	是否包括自定义类，否则输出的是普通的Object
		 * @param otherClasses	复制时涉及到的其他自定义类
		 * @return 
		 * 
		 */
		public static function clone(obj:*,includeClass:Boolean = false,otherClasses:Array = null):*
		{
			if (includeClass)
				registerClassAlias(getQualifiedClassName(obj),obj["constructor"]);
			
			if (otherClasses)
			{
				for each (var cls:Class in otherClasses)
					registerClassAlias(getQualifiedClassName(cls),cls);
			}
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(obj);
			bytes.position = 0;
			return bytes.readObject();
		}
		
		/**
		 * 移除所有子对象
		 * @param container	目标
		 * 
		 */
		public static function removeAllChildren(container:DisplayObjectContainer):void
        {
            while (container.numChildren) 
                container.removeChildAt(0);
        }
	}
}