package com.riameeting.finger.display.graphic
{
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.DrawTool;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 饼图图形
	 * @author Finger
	 * 
	 */	
	public class PieGraphic extends LineGraphic
	{
		/**
		 * 定位坐标点
		 */		
		protected var locatePoint:Point;
		/**
		 * 文本显示标签
		 */		
		protected var label:Label = new Label(false);
		/**
		 * Pie无需Skin
		 * @param value
		 * 
		 */		
		override public function set skin(value:MovieClip):void {}
		/**
		 * 设置颜色
		 * @param value
		 * 
		 */		
		override public function set color(value:uint):void{_color = value}
		/**
		 * 状态
		 * @return 状态字符串
		 * 
		 */	
		override public function set state(value:String):void{
			super.state = value;
			if(value == MouseEvent.MOUSE_OVER) {
				//x+=center.x/10;
				//y+=center.y/10;
			} else if(value == MouseEvent.MOUSE_OUT) {
				filters = null;
				//x = locatePoint.x;
				//y = locatePoint.y;
			}
		}
		/**
		 * 构造方法
		 * @param chartRef
		 * 
		 */		
		public function PieGraphic(chartRef:IChart)
		{
			super(chartRef);
			addChild(label);
		}
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 * 
		 */	
		override public function locate(value:Point=null,offset:uint=0):void
		{
			if(value != null) point = value;
			x = point.x;
			y = point.y;
			locatePoint = value;
			var axis:IAxis = chartRef.axis;
			var axisRect:Rectangle = chartRef.axis.getAxisRect();
			//sector
			var angleObj:Object = axis.getAngle(data,yField);
			var r:Number = (axisRect.width<axisRect.height)?(axisRect.width/2-30+offset):(axisRect.height/2-30+offset);
			center = DrawTool.drawSector(graphics,new Point(0,0),r,angleObj.beginAngle,angleObj.angle,0xFFFFFF,1,0,color,0);
			//tip str
			if(data["tipString"] == null) data["tipString"] = {};
			data["tipString"][yField] = "";
			var categoryField:String = chartRef.dataset.config["categoryField"];
			data["tipString"][yField] += "<b><font color='#"+color.toString(16)+"'>"+data[categoryField]+"</font></b><br/>";
			var yTitle:String = chartRef.dataset.config["yTitle"];
			data["tipString"][yField] += yTitle + "  " + ((angleObj.angle / 360) * 100).toFixed(2) + "%";
			if (data[yField + "_tooltext"])
			{
				data["tipString"][yField] += "\n"+data[yField + "_tooltext"];
			}
			if(chartRef.chartConfig["graphicLabel"] != "hidden") {
				if(chartRef.chartConfig["graphicLabel"] == "first" && chartRef.dataset.collection.indexOf(data) != 0) {
					return;
				}
				graphics.lineStyle(1,0x000000,1);
				graphics.moveTo(center.x*2,center.y*2);
				graphics.lineTo(center.x*2.1,center.y*2.1);
				label.x = center.x*2.1;
				label.y = center.y*2.1 - label.height;
				label.text = data[categoryField];
				label.visible = true;
				if(center.x > 0) {
					graphics.lineTo(center.x*2.1+label.width,center.y*2.1);
				} else {
					label.x -= label.width;
					graphics.lineTo(center.x*2.1-label.width,center.y*2.1);
				}
			}
		}
	}
}