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
	 * 气泡图图形类
	 * @author Finger
	 * 
	 */	
	public class BubbleGraphic extends LineGraphic
	{
		/**
		 * Z轴最小值
		 */		
		public static var minZValue:int = -1;
		/**
		 * Z轴最大值
		 */		
		public static var maxZValue:int = -1;
		/**
		 * 最小半径值
		 */		
		public static var minRadius:Number = 20;
		/**
		 * 最大半径值
		 */		
		public static var maxRadius:Number = 50;
		/**
		 * Z轴字段
		 */		
		protected var zField:String;
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
		 * 数据对象
		 * @return Object
		 * 
		 */
		override public function set data(value:Object):void {
			super.data = value;
			//z
			zField = chartRef.dataset.config["zField"];
			if(minZValue == -1) {
				minZValue = chartRef.dataset.collection[0][zField];
				maxZValue = chartRef.dataset.collection[0][zField];
				for each(var obj:Object in chartRef.dataset.collection) {
					if(obj[zField] < minZValue) {
						minZValue = obj[zField];
					}
					if(obj[zField] > maxZValue) {
						maxZValue = obj[zField];
					}
				}
			}
		}
		/**
		 * 构造方法
		 * 
		 */		
		public function BubbleGraphic(chartRef:IChart)
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
			var r:uint = minRadius+(maxRadius-minRadius)*((data[zField]-minZValue))/(maxZValue-minZValue);
			skin.width = skin.height = r+3;
			//tip str
			if(data["tipString"] == null) data["tipString"] = {};
			data["tipString"][yField] = "<b><font color='#"+color.toString(16)+"'>"+data.name+"</font></b><br/>";
			var xField:String = chartRef.dataset.config["xField"];
			data["tipString"][yField] += xField+"  "+data[xField]+"<br/>";
			var yTitle:String;
			yTitle = chartRef.dataset.config["yTitle"];
			data["tipString"][yField] += yField+"  "+data[yField]+"<br/>";
			data["tipString"][yField] += zField+"  "+data[zField];
			if(chartRef.dataset.config["qualifier"] != null) {
				data["tipString"][yField] += chartRef.dataset.config["qualifier"];
			}
		}
	}
}