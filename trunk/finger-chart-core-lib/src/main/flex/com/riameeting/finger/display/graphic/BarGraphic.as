package com.riameeting.finger.display.graphic
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.chart.IChart;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 柱状图图形类(横向)
	 * @author Finger
	 * 
	 */	
	public class BarGraphic extends LineGraphic
	{
		protected var columnOffset:Number = 5;
		override public function set color(value:uint):void{
			_color = value;
		}
		/**
		 * 构造方法
		 * 
		 */		
		public function BarGraphic(chartRef:IChart)
		{
			super(chartRef);
			skinName = "skin.BarGraphic";
		}
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 * 
		 */	
		override public function locate(value:Point=null, offset:uint=10):void {
			super.locate(value,offset);
			var prevIndex:int = chartRef.dataset.collection.indexOf(data)-1;
			var axis:IAxis = chartRef.axis;
			if(prevIndex != -1) {
				(parent as Sprite).graphics.clear();
			}
			var axisRect:Rectangle = axis.getAxisRect();
			var columnWidth:Number = axisRect.height/(axis.dataset.collection.length+2) - columnOffset;
			var columnItemWidth:Number = columnWidth/(axis.dataset.config["yField"].split(",").length-(axis.dataset.config["benchmark"]!=null?axis.dataset.config["benchmark"].split(",").length:0));
			var yFieldIndex:int = axis.dataset.config["yField"].split(",").indexOf(yField);
			y += -(columnWidth)/2+columnItemWidth*yFieldIndex+columnItemWidth/2;
			skin.updateDisplayList({width:columnItemWidth,height:x-axisRect.x-5,color:_color});
		}
	}
}