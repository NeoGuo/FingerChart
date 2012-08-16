package com.riameeting.finger.parser
{
	import com.riameeting.finger.vo.DatasetVO;
	/**
	 * 解析器接口
	 * @author Finger
	 * 
	 */
	public interface IParser
	{
		/**
		 * 解析
		 * @param source 源格式
		 * @return 返回转换后的对象
		 * 
		 */	
		function parse(source:*):DatasetVO;
	}
}