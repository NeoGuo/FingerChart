package com.riameeting.finger.component
{
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;
	import com.riameeting.ui.control.Label;
	
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;

	/**
	 * 组件：线图
	 * @author Finger
	 * 
	 */	
	public class LineChart extends AbstractChart
	{
		/**
		 * 是否启用数据缩放，需要移动设备手势支持
		 */		
		public var enabledZoom:Boolean = false;
		/**
		 * 缩放的速度
		 */		
		public var zoomSpeed:int = 1;
		
		public function LineChart(width:uint, height:uint)
		{
			axis = new BasicAxis(this);
			chartGraphicContainer = new ChartGraphicContainer(this,LineGraphic,"LineGraphic",LineGraphic,false,new MoveIn(),new MoveOut());
			tooltipContainer = new TooltipContainer(this,Tooltip);
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