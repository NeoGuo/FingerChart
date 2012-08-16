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
		 * 数据集合原数据（完整集合，跟过滤无关）
		 */		
		public var collectionPrototype:Array;
		/**
		 * 数据集合，如果设置了dataRange，则会执行过滤
		 */		
		public var collection:Array;
		/**
		 * 构造方法
		 * @param config 配置对象
		 * @param collection 数据集合
		 * 
		 */
		public function DatasetVO(config:Object, collectionPrototype:Array, collection:Array)
		{
			this.config = config;  
			this.collectionPrototype = collectionPrototype;
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

		/**
		 * 根据数值区间限制过滤数据
		 * @param dataRange
		 * 
		 */		
		public function filterByRange(dataRange:Array):void
		{
			var startIndex:int = 0;
			var endIndex:int = collectionPrototype.length-1;
			if(dataRange != null && dataRange[0] >= 0 && dataRange[1] < collectionPrototype.length && dataRange[1]>dataRange[0])
			{
				startIndex = dataRange[0];
				endIndex = dataRange[1];
			}
			collection = [];
			for (; startIndex <= endIndex; startIndex++) 
			{
				collection.push(collectionPrototype[startIndex]);
			}
		}

	}
}