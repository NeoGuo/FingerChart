package com.riameeting.finger.display.graphic
{
	import com.riameeting.finger.display.chart.IChart;
	
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * 图形接口
	 * @author Finger
	 * 
	 */
	public interface IChartGraphic
	{
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */		
		function get chartRef():IChart;
		function set chartRef(value:IChart):void;
		/**
		 * 数据点对应的定位坐标，一般与x和y一致
		 * @return Object
		 * 
		 */		
		function get point():Point;
		function set point(value:Point):void;
		/**
		 * 数据对象
		 * @return Object
		 * 
		 */		
		function get data():Object;
		function set data(value:Object):void;
		/**
		 * Y轴字段
		 * @return 字符串
		 * 
		 */		
		function get yField():String;
		function set yField(value:String):void;
		/**
		 * 颜色
		 * @return 颜色值
		 * 
		 */		
		function get color():uint;
		function set color(value:uint):void;
		/**
		 * 样式
		 * @return 
		 * 
		 */		
		function get style():Object;
		function set style(value:Object):void;
		/**
		 * 皮肤name
		 * @return 
		 * 
		 */		
		function get skinName():String;
		function set skinName(value:String):void;
		/**
		 * 皮肤
		 * @return 
		 * 
		 */		
		function get skin():MovieClip;
		function set skin(value:MovieClip):void;
		/**
		 * 状态
		 * @return 状态字符串
		 * 
		 */		
		function get state():String;
		function set state(value:String):void;
		/**
		 * x坐标
		 * @return Number
		 * 
		 */		
		function get x():Number;
		function set x(value:Number):void;
		/**
		 * y坐标
		 * @return Number
		 * 
		 */	
		function get y():Number;
		function set y(value:Number):void;
		/**
		 * 宽度
		 * @return Number
		 * 
		 */		
		function get width():Number;
		function set width(value:Number):void;
		/**
		 * 高度
		 * @return Number
		 * 
		 */		
		function get height():Number;
		function set height(value:Number):void;
		/**
		 * 名称
		 * @return 名称
		 * 
		 */		
		function get name():String;
		function set name(value:String):void;
		/**
		 * 图形的中心点，鼠标提示将判断这个中心点来定位
		 * @return 坐标值
		 * 
		 */		
		function get center():Point;
		function set center(value:Point):void;
		/**
		 * 是否禁用
		 * @return 布尔量
		 * 
		 */		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 * 
		 */		
		function locate(value:Point=null,offset:uint=10):void;
		/**
		 * 执行清理动作
		 * 
		 */		
		function clear():void;
		
	}
}