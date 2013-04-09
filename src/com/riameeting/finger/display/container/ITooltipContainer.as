package com.riameeting.finger.display.container
{
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.effect.IEffect;
	import com.riameeting.finger.vo.DatasetVO;

	/**
	 * 鼠标提示容器接口
	 * @author Finger
	 * 
	 */
	public interface ITooltipContainer
	{
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */		
		function get chartRef():IChart;
		function set chartRef(value:IChart):void;
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘图表
		 * @param width 宽度
		 * @param height 高度
		 */
		function updateDisplayList(width:uint,height:uint):void;
		/**
		 * 对数据源的引用
		 * @return DatasetVO引用
		 * 
		 */
		function get dataset():DatasetVO;
		function set dataset(value:DatasetVO):void;
		/**
		 * 鼠标提示类
		 * @return 类
		 * 
		 */		
		function get tooltipClass():Class;
		function set tooltipClass(value:Class):void;
		/**
		 * CSS样式定义
		 * @return 对象
		 * 
		 */
		function get style():Object;
		function set style(value:Object):void;
		/**
		 * 执行清理动作
		 * 
		 */
		function clear():void;
		
	}
}