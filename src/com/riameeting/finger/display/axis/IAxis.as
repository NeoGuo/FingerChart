/**
 * 此包下面是坐标系相关的接口和实现类
 */
package com.riameeting.finger.display.axis
{
	import com.riameeting.finger.vo.DatasetVO;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 定义坐标系的接口
	 * @author Finger
	 * 
	 */
	public interface IAxis
	{
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘坐标系
		 * @param width 图表宽度
		 * @param height 图表高度
		 * 
		 */		
		function updateDisplayList(width:uint,height:uint):void;
		/**
		 * 坐标系中对数据源的引用
		 * @return DatasetVO引用
		 * 
		 */		
		function get dataset():DatasetVO;
		function set dataset(value:DatasetVO):void;
		/**
		 * 坐标系的CSS样式定义
		 * @return 对象
		 * 
		 */		
		function get style():Object;
		function set style(value:Object):void;
		/**
		 * 坐标系的SKIN定义
		 * @return 对象
		 * 
		 */		
		function get skin():MovieClip;
		function set skin(value:MovieClip):void;
		/**
		 * width
		 * @return 
		 * 
		 */		
		function get width():Number;
		function set width(value:Number):void;
		/**
		 * height
		 * @return 
		 * 
		 */		
		function get height():Number;
		function set height(value:Number):void;
		/**
		 * 当需要清理坐标系的时候，调用此方法
		 * 
		 */		
		function clear():void;
		/**
		 * 获取一个数据对象在坐标系上的坐标点（映射），包含x和y
		 * @param vo 数据对象
		 * @param yField Y轴字段
		 * @return 坐标点
		 * 
		 */		
		function getPoint(vo:Object,yField:String):Point;
		/**
		 * 获取一个数据对象在坐标系上的角度（映射），饼图专用
		 * @param vo 数据对象
		 * @param yField Y轴字段
		 * @return 角度值
		 * 
		 */		
		function getAngle(vo:Object,yField:String):Object;
		/**
		 * 获取坐标系可见区域的范围
		 * @return 矩形区域
		 * 
		 */		
		function getAxisRect():Rectangle;
		
	}
}