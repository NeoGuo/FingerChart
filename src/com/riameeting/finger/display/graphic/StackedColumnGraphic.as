package com.riameeting.finger.display.graphic 
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.skin.StackedColumnGraphicSkin;
	import flash.utils.setTimeout;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 堆栈图图形类
	 * @author 黄龙
	 */
	public class StackedColumnGraphic extends LineGraphic 
	{
		protected var columnOffset:Number = 5;
		override public function set color(value:uint):void{
			_color = value;
		}
		public function StackedColumnGraphic(chartRef:IChart) 
		{
			super(chartRef);
			skinName = "skin.StackedColumnGraphicSkin";
			ChartGlobal.getSkin("skin.AxisSkin");
			ChartGlobal.skinClassDict["skin.StackedColumnGraphicSkin"] =StackedColumnGraphicSkin;
		}
		
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 * 
		 */	
		override public function locate(value:Point=null, offset:uint=10):void {
			super.locate(value, offset);
			if (data["tipString"] == null) data["tipString"] = { };
			var categoryField:String = chartRef.dataset.config["categoryField"];
			data["tipString"][yField] =data[categoryField]+ "<br/><b><font color='#"+color.toString(16)+"'>"+yField+"</font></b><br/>";
			//data["tipString"][yField] += "<b><font color='#"+color.toString(16)+"'>"+data[categoryField]+"</font></b><br/>";
			var yTitle:String = chartRef.dataset.config["yTitle"];
			if (yTitle != "" && yTitle != " ")
			{
				data["tipString"][yField] += yTitle + "  " + data[yField];
			}
			else
			{
				data["tipString"][yField] += data[yField];
			}
			if(chartRef.dataset.config["qualifier"] != null) {
				data["tipString"][yField] += chartRef.dataset.config["qualifier"];
			}
			var prevIndex:int = chartRef.dataset.collection.indexOf(data) - 1;
			//var style:Array = ChartGlobal.colorCollection;
			//var cIndex:int = (prevIndex+1) %style.length;
			//_color = style[cIndex];
			var axis:IAxis = chartRef.axis;
			if(prevIndex != -1) {
				(parent as Sprite).graphics.clear();
			}
			var axisRect:Rectangle = axis.getAxisRect();
			var columnWidth:Number = axisRect.width/(axis.dataset.collection.length+2) - columnOffset;
			var columnItemWidth:Number = columnWidth/(axis.dataset.config["yField"].split(",").length-(axis.dataset.config["benchmark"]!=null?axis.dataset.config["benchmark"].split(",").length:0));
			var yFieldIndex:int = axis.dataset.config["yField"].split(",").indexOf(yField);
			//x += -(columnWidth)/2+columnItemWidth*yFieldIndex+columnItemWidth/2;
			//y += (axisRect.height) * (yFieldIndex+1);
			//var len:int = axis.dataset.config["yField"].split(",").length;
			var yFieldArr:Array = axis.dataset.config["yField"].split(",");
			var len:int = yFieldArr.length;
			var heightY:Number = axisRect.y + axisRect.height - y;
			for (var i:int = 0; i < len; i++)
			{
				if (i == yFieldIndex)
				{
					break;
				}
				y -= data[yFieldArr[i]] / axis['maxValueY'] * axisRect.height;
			}
			if (chartRef['setTimeStackedFleg']==false)
			{
				setTimeout(mySetDepths, 200);
				chartRef['setTimeStackedFleg'] = true;
			}
			skin.updateDisplayList({width:columnItemWidth,height:heightY,color:_color});
		}
		
		/**
		 * 排序显示
		 */
		private function mySetDepths():void 
		{
			var len:int = chartRef.chartGraphicContainer.seriesCollection.length;
			var arr:Array = chartRef.chartGraphicContainer.seriesCollection;
			var parentF:Sprite = arr[0].parent;
			for (var i:int = 0; i < len; i++)
			{
				parentF.setChildIndex(arr[i], len-1-i);
			}
		}
		
	}

}