package com.riameeting.finger.display.axis 
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.skin.HorizontalAxisSkin;
	import com.riameeting.finger.factory.ObjectFactory;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.ui.control.Alert;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.ColorUtils;
	import com.riameeting.utils.DPIReset;
	import com.riameeting.utils.DrawTool;
	import com.riameeting.utils.NumberTool;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 横向坐标系
	 * @author 黄龙
	 */
	public class HorizontalAxis extends BasicAxis 
	{
		
		public function HorizontalAxis(chartRef:IChart, ignoreOffsetV:Boolean = false) 
		{
			super(chartRef, ignoreOffsetV);
			ChartGlobal.getSkin("skin.AxisSkin");
			ChartGlobal.skinClassDict["skin.AxisSkin"] = HorizontalAxisSkin;
		}
		
		/**
		 * 当数据传入之后，需要计算各个轴上的取值范围（最小为0，最大则需要循环计算）
		 * 
		 */
		override protected function calculateMaxValue():void {
			super.calculateMaxValue();
			maxValueY *= 1.1;
			maxValueY = NumberTool.getMaxNumberY(maxValueY, countY);
		}
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘坐标系
		 * @param w 宽度
		 * @param h 高度
		 * 
		 */	
		override public function updateDisplayList(w:uint,h:uint):void {
			super.updateDisplayList(w, h);
			//trace(style.paddingLeft);
			skin.titleB.color = style["color"];
			skin.titleB.x = 0;
			skin.titleB.y = 0;
			skin.titleL.color = style["bottomColor"];
			skin.titleL.x = (w - skin.titleL.width)/2;
			skin.titleL.y = h - skin.titleL.height;
		}
		/**
		 * 获取一个数据对象在坐标系上的坐标点（映射），包含x和y
		 * @param vo 数据对象
		 * @param yField Y轴字段
		 * @return 坐标点
		 * 
		 */	
		override public function getPoint(vo:Object,yField:String):Point {
			return super.getPoint(vo, yField);
		}
	}

}