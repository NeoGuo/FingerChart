package com.riameeting.finger.display.axis
{
	import com.riameeting.finger.display.chart.IChart;
	
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * 用于饼图的坐标系
	 * @author Finger
	 * 
	 */	
	public class PieAxis extends BasicAxis
	{
		/**
		 * 起始角度
		 */		
		protected var beginAngle:Number = -90;
		/**
		 * 当前数据项计算所得的角度
		 */		
		protected var currentAngle:Number = 0;
		/**
		 * Pie无需Skin
		 * @param value
		 * 
		 */		
		override public function set skin(value:MovieClip):void {}
		/**
		 * 构造方法
		 * @param chartRef
		 * @param ignoreOffsetV
		 * 
		 */		
		public function PieAxis(chartRef:IChart, ignoreOffsetV:Boolean=false)
		{
			super(chartRef, ignoreOffsetV);
			//titleB.visible = false;
		}
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘坐标系
		 * @param w 宽度
		 * @param h 高度
		 * 
		 */	
		override public function updateDisplayList(w:uint, h:uint):void
		{
			axisWidth = w;
			axisHeight = h;
			style["paddingLeft"] = style["paddingTop"] = style["paddingRight"] = style["paddingBottom"] = 0;
			graphicArea.x = int(style["paddingLeft"]);
			graphicArea.y = int(style["paddingTop"]);
			graphicArea.width = w - int(style["paddingLeft"]) - int(style["paddingRight"]);
			graphicArea.height = h - int(style["paddingTop"]) - int(style["paddingBottom"]);
		}
		/**
		 * 获取一个数据对象在坐标系上的坐标点（映射），包含x和y
		 * @param vo 数据对象
		 * @param yField Y轴字段
		 * @return 坐标点
		 * 
		 */	
		override public function getPoint(vo:Object, yField:String):Point
		{
			return new Point(axisWidth/2,axisHeight/2);
		}
		/**
		 * 获取一个数据对象在坐标系上的角度（映射），饼图专用
		 * @param vo 数据对象
		 * @param yField Y轴字段
		 * @return 角度值
		 * 
		 */			
		override public function getAngle(vo:Object,yField:String):Object {
			var count:Number = 0;
			for each(var item:Object in dataset.collection) {
				count += Number(item[yField]);
			}
			var proportion:Number = Number(vo[yField])/count;
			currentAngle = proportion*360;
			var obj:Object = {beginAngle:beginAngle,angle:currentAngle};
			beginAngle += currentAngle;
			return obj;
		}
	}
}