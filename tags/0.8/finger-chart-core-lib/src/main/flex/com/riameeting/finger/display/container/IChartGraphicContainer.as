package com.riameeting.finger.display.container
{
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.graphic.IChartGraphic;
	import com.riameeting.finger.effect.IEffect;
	import com.riameeting.finger.vo.DatasetVO;

	/**
	 * 图形容器接口
	 * @author Finger
	 * 
	 */
	public interface IChartGraphicContainer
	{
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */		
		function get chartRef():IChart;
		function set chartRef(value:IChart):void;
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法进行重绘
		 * @param width 宽度
		 * @param height 高度
		 * 
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
		 * 图形类
		 * @return 类
		 * 
		 */		
		function get graphicClass():Class;
		function set graphicClass(value:Class):void;
		/**
		 * 参考线类
		 * @return 类
		 * 
		 */		
		function get benchmarkClass():Class;
		function set benchmarkClass(value:Class):void;
		/**
		 * Y轴定义的数据显示字段，可以为1个或多个
		 * @return 数组
		 * 
		 */		
		function get yFields():Array;
		function set yFields(value:Array):void;
		/**
		 * Y轴定义的参考线显示字段，可以为1个或多个
		 * @return 数组
		 * 
		 */		
		function get benchmark():Array;
		function set benchmark(value:Array):void;
		/**
		 * 是否开启多色彩模式（每个图形使用单独的色彩）
		 * @return 布尔量
		 * 
		 */		
		function get differentColors():Boolean;
		function set differentColors(value:Boolean):void;
		/**
		 * CSS样式定义
		 * @return 对象
		 * 
		 */	
		function get style():Object;
		function set style(value:Object):void;
		/**
		 * 一个包含了所有图形的数组
		 * @return 数组
		 * 
		 */		
		function get graphicsCollection():Array;
		/**
		 * 如果yFields是多个，则将数据分为N个series，series放置到这个数组
		 * @return 数组
		 * 
		 */		
		function get seriesCollection():Array;
		/**
		 * 与seriesCollection对应，存储状态
		 * @return Object
		 * 
		 */		
		function get seriesMode():Object;
		/**
		 * 图形显示的特效
		 * @return 
		 * 
		 */		
		function get graphicShowEffect():IEffect;
		function set graphicShowEffect(value:IEffect):void;
		/**
		 * 图形隐藏的特效
		 * @return 
		 * 
		 */		
		function get graphicHideEffect():IEffect;
		function set graphicHideEffect(value:IEffect):void;
		/**
		 * 获取容器中的图形
		 * @param data 数据对象
		 * @param yField Y轴字段
		 * @return IChartGraphic
		 * 
		 */		
		function getGraphic(data:Object,yField:String):IChartGraphic;
		/**
		 * 显示series（适用于多组数据，比如多条折线）
		 * @param seriesName 名称
		 * 
		 */		
		function showSeries(seriesName:String,animation:Boolean=false):void;
		/**
		 * 隐藏series（适用于多组数据，比如多条折线）
		 * @param seriesName 名称
		 * 
		 */		
		function hideSeries(seriesName:String,animation:Boolean=false):void;
		/**
		 * 显示图形
		 * @param graphicName 名称
		 * 
		 */		
		function showGraphic(graphicName:String,animation:Boolean=false):void;
		/**
		 * 隐藏图形
		 * @param graphicName 名称
		 * 
		 */		
		function hideGraphic(graphicName:String,animation:Boolean=false):void;
		/**
		 * 执行清理动作
		 * 
		 */		
		function clear():void;
		
	}
}