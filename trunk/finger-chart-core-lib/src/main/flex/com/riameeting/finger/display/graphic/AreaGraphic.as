package com.riameeting.finger.display.graphic
{
	import com.cartogrammar.drawing.CubicBezier;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.utils.ColorUtils;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * 区域图图形
	 * @author Finger
	 * 
	 */	
	public class AreaGraphic extends LineGraphic
	{
		/**
		 * 构造方法
		 * @param chartRef
		 * 
		 */		
		public function AreaGraphic(chartRef:IChart)
		{
			super(chartRef);
		}
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 * 
		 */	
		override public function locate(value:Point=null,offset:uint=10):void {
			super.locate(value,offset);
			var prevIndex:int = chartRef.dataset.collection.indexOf(data)-1;
			var axisRectHeight:uint = chartRef.axis.getAxisRect().y + chartRef.axis.getAxisRect().height;
			var prevObject:Object,prevPoint:Point;
			var points:Array = [];
			var i:uint = 0;
			var matix:Matrix =new Matrix();
			if(prevIndex != -1) {
				prevObject = chartRef.dataset.collection[prevIndex];
				prevPoint = chartRef.axis.getPoint(prevObject,yField);
				if(style["lineMode"] == "line") {
					if(prevObject.enabled) {
						(parent as Sprite).graphics.lineStyle();
						matix.createGradientBox(x-prevPoint.x, axisRectHeight, Math.PI/2, 0, 0);
						(parent as Sprite).graphics.beginGradientFill(GradientType.LINEAR,[ColorUtils.fadeColor(color,0xFFFFFF,0.2),color],[1,1],[0x00,0xFF],matix);
						(parent as Sprite).graphics.moveTo(x+1,y-style.lineWidth);
						(parent as Sprite).graphics.lineTo(prevPoint.x,prevPoint.y-style.lineWidth);
						(parent as Sprite).graphics.lineTo(prevPoint.x,axisRectHeight);
						(parent as Sprite).graphics.lineTo(x+1,axisRectHeight);
						(parent as Sprite).graphics.lineTo(x+1,y-style.lineWidth);
						(parent as Sprite).graphics.endFill();
					}
				} else {
					if(prevIndex == chartRef.dataset.collection.length-2) {
						for(;i<chartRef.dataset.collection.length;i++) {
							prevObject = chartRef.dataset.collection[i];
							var currentPoint:Point = chartRef.axis.getPoint(prevObject,yField);
							points.push(currentPoint);
						}
						(parent as Sprite).graphics.lineStyle();
						matix.createGradientBox(x-prevPoint.x, axisRectHeight, Math.PI/2, 0, 0);
						(parent as Sprite).graphics.beginGradientFill(GradientType.LINEAR,[ColorUtils.fadeColor(color,0x000000,.5),color],[1,1],[0x00,0xFF],matix);
						CubicBezier.curveThroughPoints((parent as Sprite).graphics,points,0.5,0.2);
						(parent as Sprite).graphics.lineTo(points[points.length-1].x,axisRectHeight);
						(parent as Sprite).graphics.lineTo(points[0].x-2,axisRectHeight);
						(parent as Sprite).graphics.lineTo(points[0].x-2,points[0].y);
						(parent as Sprite).graphics.endFill();
					}
				}
			}
		}
	}
}