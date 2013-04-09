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
	 * 比较型柱状图图形类
	 * @author 黄龙
	 */
	public class CompareColumnGraphic extends LineGraphic 
	{
		protected var columnOffset:Number = 5;
		override public function set color(value:uint):void{
			_color = value;
		}
		
		public function CompareColumnGraphic(chartRef:IChart) 
		{
			super(chartRef);
			skinName = "skin.ColumnGraphic";
		}
		
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 * 
		 */	
		override public function locate(value:Point = null, offset:uint = 10):void {
			super.locate(value,offset);
			var prevIndex:int = chartRef.dataset.collection.indexOf(data)-1;
			var axis:IAxis = chartRef.axis;
			if(prevIndex != -1) {
				(parent as Sprite).graphics.clear();
			}
			var yFeildArr:Array  = axis.dataset.config["yField"].split(",");
			var len:int = yFeildArr.length;
			var axisRect:Rectangle = axis.getAxisRect();
			var columnWidth:Number = axisRect.width / (axis.dataset.collection.length + 2) - columnOffset;
			var columnItemWidth:Number = columnWidth / len * 1;
			//columnWidth=columnWidth>25?25:columnWidth;
			//Debug.trace("柱子", columnWidth, columnItemWidth);
			var yFieldIndex:int = yFeildArr.indexOf(yField);
			//trace(yFieldIndex);
			//trace(x);
			//x += -(columnWidth) / 2 + columnItemWidth * yFieldIndex + columnItemWidth / 2;
			x+= -(columnWidth)/2+columnItemWidth*yFieldIndex+columnItemWidth / 2;
			skin.updateDisplayList({width:columnItemWidth,height:axisRect.y+axisRect.height-y,color:_color});
		}
	}

}