package com.riameeting.finger.display.chart
{
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.container.IChartGraphicContainer;
	import com.riameeting.finger.display.container.IPluginContainer;
	import com.riameeting.finger.display.container.ITooltipContainer;
	import com.riameeting.finger.display.legend.ILegend;
	import com.riameeting.finger.effect.IEffect;
	import com.riameeting.finger.vo.DatasetVO;
	
	import flash.display.MovieClip;

	/**
	 * 图表接口
	 * @author Finger
	 * 
	 */	
	public interface IChart
	{
		/**
		 * 图表的配置
		 * @return 
		 * 
		 */		
		function get chartConfig():Object;
		function set chartConfig(value:Object):void;
		/**
		 * 宽度
		 * @return 
		 * 
		 */		
		function get width():Number;
		function set width(value:Number):void;
		/**
		 * 高度
		 * @return 
		 * 
		 */		
		function get height():Number;
		function set height(value:Number):void;
		/**		 * 图表的4个显示层级之一：坐标系		 * @return 坐标系		 * 		 */				function get axis():IAxis;
		function set axis(value:IAxis):void;
		/**
		 * 图表的4个显示层级之一：图形容器
		 * @return 图形容器
		 * 
		 */	
		function get chartGraphicContainer():IChartGraphicContainer;
		function set chartGraphicContainer(value:IChartGraphicContainer):void;
		/**
		 * 图表的4个显示层级之一：鼠标提示容器
		 * @return 鼠标提示容器
		 * 
		 */
		function get tooltipContainer():ITooltipContainer;
		function set tooltipContainer(value:ITooltipContainer):void;
		/**
		 * 图表的4个显示层级之一：插件容器
		 * @return 插件容器
		 * 
		 */
		function get pluginContainer():IPluginContainer;
		function set pluginContainer(value:IPluginContainer):void;
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
		 * Skin
		 * @return 对象
		 * 
		 */	
		function get skin():MovieClip;
		function set skin(value:MovieClip):void;
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘图表
		 * 
		 */		
		function updateDisplayList():void;
		/**
		 * 加载资源
		 * 
		 */		
		function loadAssets(chartConfigObj:Object = null):void;
		/**
		 * 绑定到图例说明
		 * @param legend
		 * 
		 */		
		function bindLegend(legend:ILegend):void;
		/**
		 * 添加数据
		 * @param data
		 * @param policy 策略，可选：add, replace
		 * 
		 */		
		function addData(data:Object,policy:String="add"):void;
	}
}