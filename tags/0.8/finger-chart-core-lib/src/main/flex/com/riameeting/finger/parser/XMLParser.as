package com.riameeting.finger.parser
{
	import com.riameeting.finger.vo.DatasetVO;
	/**
	 * XML解析器
	 * @author Finger
	 * 
	 */	
	public class XMLParser implements IParser
	{
		private var xmlSource:XML;
		/**
		 * 构造方法
		 * 
		 */		
		public function XMLParser()
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
			xmlSource = new XML(source);
			var header:XML = xmlSource.config[0];
			var dt:String,dd:String,node:XML,nodeAtt:XML;
			for each(node in header.attributes()) {
				dt = node.localName().toString();
				dd = node.toString();
				headerObj[dt] = dd;
			}
			var nodes:XMLList = xmlSource.dataset.node;
			for each(node in nodes) {
				var valueObj:Object = {};
				for each(nodeAtt in node.attributes()) {
					dt = nodeAtt.localName().toString();
					dd = nodeAtt.toString();
					valueObj[dt] = dd;
				}
				arr.push(valueObj);
			}
			return new DatasetVO(headerObj,arr);
		}
	}
}