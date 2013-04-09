package com.riameeting.finger.parser
{
	import com.riameeting.finger.vo.DatasetVO;
	/**
	 * CSV解析器
	 * @author Finger
	 * 
	 */
	public class CSVParser
	{
		/**
		 * 将数据对象转换为CSV格式
		 * @param dataset 数据对象
		 * @return 字符串
		 * 
		 */		
		public static function encode(dataset:DatasetVO):String
		{
			var str:String = dataset.config["categoryField"];
			var yFiled:String;
			for each(yFiled in dataset.config["yField"].split(",")) {
				str += ","+yFiled;
			}
			str += "\n";
			for each(var obj:Object in dataset.collection) {
				str += obj[dataset.config["categoryField"]];
				for each(yFiled in dataset.config["yField"].split(",")) {
					str += ","+obj[yFiled];
				}
				str += "\n";
			}
			return str;
		}
	}
}