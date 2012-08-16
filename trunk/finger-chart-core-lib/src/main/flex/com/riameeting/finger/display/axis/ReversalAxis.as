package com.riameeting.finger.display.axis
{
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.factory.ObjectFactory;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.ui.control.Alert;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.NumberTool;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 翻转坐标系
	 * @author Finger
	 * 
	 */	
	public class ReversalAxis extends BasicAxis
	{
		/**
		 * 构造方法
		 * @param chartRef
		 * @param ignoreOffsetV
		 * 
		 */		
		public function ReversalAxis(chartRef:IChart, ignoreOffsetV:Boolean=false)
		{
			super(chartRef, ignoreOffsetV);
		}
		/**
		 * 当数据传入之后，需要计算各个轴上的取值范围（最小为0，最大则需要循环计算）
		 * 
		 */
		override protected function calculateMaxValue():void {
			super.calculateMaxValue();
			var i:uint=0,j:uint=0,obj:Object;
			//x
			if(xField != null) {
				countX = (graphicArea.height-int(style["offsetV"])*2)/int(style["gridHeight"]);
			} else {
				countX = dataset.collection.length;
			}
			countY = graphicArea.width/int(style["gridHeight"]);
		}
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘坐标系
		 * @param w 宽度
		 * @param h 高度
		 * 
		 */	
		override public function updateDisplayList(w:uint,h:uint):void {
			super.updateDisplayList(w,h);
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
			var targetX:Number;
			var targetY:Number;
			var objIndex:int = dataset.collection.indexOf(vo);
			if(xField != null) {
				throw new Error("ReveralAxis doesn't support xField");
			} else {
				targetX = graphicArea.x + graphicArea.width*((vo[yField]-minValueY)/(maxValueY-minValueY));
			}
			targetY = graphicArea.y + int(style["offsetV"]) + (dataset.collection.length-objIndex-1)*realGridWidth;
			return new Point(targetX,targetY);
		}
	}
}