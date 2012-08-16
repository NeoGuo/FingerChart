package com.riameeting.finger.vo
{
	/**
	 * 数据对象的封装
	 * @author Finger
	 * 
	 */	
	public class DatasetVO
	{
		/**
		 * 配置对象
		 */		
		public var config:Object;
		/**
		 * 数据集合
		 */		
		public var collection:Array;
		/**
		 * 构造方法
		 * @param config 配置对象
		 * @param collection 数据集合
		 * 
		 */
		public function DatasetVO(config:Object, collection:Array)
		{
			this.config = config;  
			this.collection = collection;  
			super();
		}
		/**
		 * 转换为字符串
		 * @return 
		 * 
		 */
		public function toString():String
		{
			return "DatasetVO{config:" + config + ", collection:[" + collection + "]}";
		}


	}
}