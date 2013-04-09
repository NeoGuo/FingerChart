package com.riameeting.finger.component 
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.skin.CompareDotGraphic;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;
	import com.riameeting.ui.control.Label;
	import ui.LineChartTooltipSkin;
	
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	
	/**
	 * 比较型折线图
	 * @author 黄龙
	 */
	public class CompareLineChart extends AbstractChart
	{
		/**
		 * 是否启用数据缩放，需要移动设备手势支持
		 */		
		public var enabledZoom:Boolean = false;
		/**
		 * 缩放的速度
		 */		
		public var zoomSpeed:int = 1;
		
		public function CompareLineChart(width:uint, height:uint) 
		{
			ChartGlobal.getSkin("skin.DotGraphic");
			ChartGlobal.skinClassDict["skin.DotGraphic"] = CompareDotGraphic;
			ChartGlobal.getSkin("skin.TooltipSkin");
			ChartGlobal.skinClassDict["skin.TooltipSkin"] = LineChartTooltipSkin;
			axis = new BasicAxis(this);
			chartGraphicContainer = new ChartGraphicContainer(this,CompareLineGraphic,"CompareLineGraphic",CompareLineGraphic,false,new MoveIn(),new MoveOut());
			tooltipContainer = new LineChartTooltipContainer(this,Tooltip);
			pluginContainer = new PluginContainer(this);
			super(axis, chartGraphicContainer, tooltipContainer, pluginContainer, width, height);
		}
		
		override protected function drawChart(e:Event=null):void
		{
			super.drawChart(e);
			if(enabledZoom && Multitouch.supportsGestureEvents)
			{
				if(dataRange == null)
					dataRange = [0,dataset.collectionPrototype.length-1];
				addEventListener(TransformGestureEvent.GESTURE_ZOOM,zoomHandler);
			}
		}
		
		protected function zoomHandler(event:TransformGestureEvent):void
		{
			var endIndex:int = dataRange[1];
			if(event.scaleX < 1)
				endIndex+=zoomSpeed;
			else
				endIndex-=zoomSpeed;
			if(endIndex > 0 && endIndex < dataset.collectionPrototype.length)
				dataRange = [0,endIndex];
		}
	}

}