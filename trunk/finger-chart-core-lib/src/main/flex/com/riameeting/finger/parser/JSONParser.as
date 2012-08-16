package com.riameeting.finger.parser
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.utils.ArrayUtils;

	/**
	 * JSON解析器
	 * @author Finger
	 * 
	 */	
	public class JSONParser implements IParser
	{
		private var jsonObj:Object;
		/**
		 * 构造方法
		 * 
		 */	
		public function JSONParser()
		{
		}
		/**
		 * 解析
		 * @param source 源格式
		 * @return 返回转换后的对象
		 * 
		 */	
		public function parse(source:*):DatasetVO
		{
			var headerObj:Object = {};
			var arr:Array = [];
			jsonObj = new JSONDecoder(source).getValue();
			headerObj = jsonObj.config;
			arr = jsonObj.dataset;
			var arrPrototype:Array = ArrayUtils.clone(arr);
			return new DatasetVO(headerObj,arrPrototype,arr);
		}
	}
}