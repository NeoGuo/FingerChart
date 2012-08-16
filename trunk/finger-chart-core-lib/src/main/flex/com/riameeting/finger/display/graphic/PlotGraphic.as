package com.riameeting.finger.display.graphic
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.chart.IChart;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 散点图图形类
	 * @author Finger
	 * 
	 */	
	public class PlotGraphic extends LineGraphic
	{
		/**
		 * 皮肤
		 * @return 
		 * 
		 */		
		override public function set skin(value:MovieClip):void {
			super.skin = value;
			value.scaleX = value.scaleY = 1.5;
		}
		/**
		 * 构造方法
		 * 
		 */		
		public function PlotGraphic(chartRef:IChart)
		{
			super(chartRef);
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
			//tip str
			if(data["tipString"] == null) data["tipString"] = {};
			data["tipString"][yField] = "<b><font color='#"+color.toString(16)+"'>"+data.name+"</font></b><br/>";
			var xField:String = chartRef.dataset.config["xField"];
			data["tipString"][yField] += xField+" : "+data[xField]+"<br/>";
			var yTitle:String;
			yTitle = chartRef.dataset.config["yTitle"];
			data["tipString"][yField] += yField+" : "+data[yField];
			if(chartRef.dataset.config["qualifier"] != null) {
				data["tipString"][yField] += chartRef.dataset.config["qualifier"];
			}
		}
	}
}