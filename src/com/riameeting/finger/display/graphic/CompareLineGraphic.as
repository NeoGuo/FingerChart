package com.riameeting.finger.display.graphic 
{
	import com.cartogrammar.drawing.CubicBezier;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.container.IChartGraphicContainer;
	import com.riameeting.finger.events.ChartEvent;
	import com.riameeting.utils.ColorUtils;
	import com.riameeting.utils.DrawTool;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	/**
	 * 比较型线条图形类
	 * @author 黄龙
	 */
	public class CompareLineGraphic extends LineGraphic 
	{
		
		public function CompareLineGraphic(chartRef:IChart) 
		{
			super(chartRef);
		}
		
		override public function locate(value:Point = null, offset:uint = 10):void 
		{
			if(value != null) point = value;
			x = point.x;
			y = point.y;
			var linecolor:uint = color;
			var index:int = chartRef.chartGraphicContainer.yFields.indexOf(this.yField);
			//if(this.yField)
			if (ChartGlobal.colorDict[this.yField + 'compare'] == null)
			{
				linecolor = ChartGlobal.colorCollection[Math.floor((index) * 0.5)];
				ChartGlobal.colorDict[this.yField + 'compare'] = linecolor;
			}
			else
			{
				linecolor = ChartGlobal.colorDict[this.yField + 'compare'];
			}
			var prevIndex:int = chartRef.dataset.collection.indexOf(data)-1;
			if(style["lineMode"] == "line") {
				if(prevIndex != -1) {
					var prevObject:Object = chartRef.dataset.collection[prevIndex];
					if (prevObject.enabled) {
						var prevPoint:Point = chartRef.axis.getPoint(prevObject, yField);
						(parent as Sprite).graphics.lineStyle(style["lineWidth"], linecolor);
						if (index%2 == 0)
						{
							(parent as Sprite).graphics.moveTo(x-0.5,y);
							(parent as Sprite).graphics.lineTo(prevPoint.x, prevPoint.y);
						}
						else
						{
							DrawTool.dotLineTo((parent as Sprite).graphics, x - 0.5, y, prevPoint.x, prevPoint.y);
						}
						//(parent as Sprite).graphics.lineStyle(2,0xFFFFFF);
						//(parent as Sprite).graphics.moveTo(x-0.5,y-(style["lineWidth"]));
						//(parent as Sprite).graphics.lineTo(prevPoint.x, prevPoint.y - (style["lineWidth"]));
						//(parent as Sprite).graphics.moveTo(x-0.5,y+(style["lineWidth"]));
						//(parent as Sprite).graphics.lineTo(prevPoint.x,prevPoint.y+(style["lineWidth"]));
					}
				}
			} else {
				if(prevIndex == chartRef.dataset.collection.length-2) {
					var points:Array = [];
					var i:uint = 0;
					for(;i<chartRef.dataset.collection.length;i++) {
						prevObject = chartRef.dataset.collection[i];
						var currentPoint:Point = chartRef.axis.getPoint(prevObject,yField);
						points.push(currentPoint);
					}
					(parent as Sprite).graphics.lineStyle(style["lineWidth"],linecolor);
					CubicBezier.curveThroughPoints((parent as Sprite).graphics,points,0.5,0.2);
				}
			}
			//tip str
			if (data["tipString"] == null) data["tipString"] = { };
			//yField.substring
			if (Number(yField.substring(yField.length - 1, yField.length )))
			{
				data["tipString"][yField] = "<b><font color='#" + linecolor.toString(16) + "'>" + yField.substring(0, yField.length - 1) + "</font></b><br/>";
			}
			else
			{
				data["tipString"][yField] = "<b><font color='#" + linecolor.toString(16) + "'>" + yField + "</font></b><br/>";
			}
			var categoryField:String = chartRef.dataset.config["categoryField"];
			if (String(data[categoryField]).search(',')!= -1)
			{
				var indexNum:int = chartRef.dataset.config.yField.split(',', 10).indexOf(yField);
				if (indexNum % 2 == 1)
				{
					data["tipString"][yField] += categoryField + "  " + String(data[categoryField]).split(',',10)[0] + "<br/>";
				}
				else
				{
					data["tipString"][yField] += categoryField + "  " + String(data[categoryField]).split(',',10)[1] + "<br/>";
				}
			}
			else
			{
				data["tipString"][yField] += categoryField + "  " + data[categoryField] + "<br/>";
			}
			var yTitle:String = chartRef.dataset.config["yTitle"];
			data["tipString"][yField] += yTitle+"  "+data[yField];
			if(chartRef.dataset.config["qualifier"] != null) {
				data["tipString"][yField] += chartRef.dataset.config["qualifier"];
			}
		}
	}

}