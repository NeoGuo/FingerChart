package com.riameeting.finger.display.legend
{
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.vo.DatasetVO;

	/**
	 * 图表说明接口
	 * @author Finger
	 * 
	 */
	public interface ILegend
	{
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */		
		function get chartRef():IChart;
		function set chartRef(value:IChart):void;
		/**
		 * 名称
		 * @return 字符串
		 * 
		 */		
		function get name():String;
		function set name(value:String):void;
		/**
		 * x坐标值
		 * @return 
		 * 
		 */		
		function get x():Number;
		function set x(value:Number):void;
		/**
		 * y坐标值
		 * @return 
		 * 
		 */		
		function get y():Number;
		function set y(value:Number):void;
		/**
		 * 对数据源的引用
		 * @return DatasetVO引用
		 * 
		 */	
		function get dataset():DatasetVO;
		function set dataset(value:DatasetVO):void;
		/**
		 * CSS样式定义
		 * @return 对象
		 * 
		 */
		function get style():Object;
		function set style(value:Object):void;
		/**
		 * 图表说明的类型
		 * @return 
		 * 
		 */		
		function get legendMode():String;
		function set legendMode(value:String):void;
		/**
		 * 图表说明宽度
		 * @return 
		 * 
		 */		
		function get width():Number;
		function set width(value:Number):void;
		/**
		 * 图表说明高度
		 * @return 
		 * 
		 */		
		function get height():Number;
		function set height(value:Number):void;
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘图表
		 * @param width 宽度
		 * @param height 高度
		 */
		function updateDisplayList(w:uint,h:uint):void;
		
	}
}