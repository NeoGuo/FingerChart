package com.riameeting.finger.flex.component
{
	import com.riameeting.finger.component.LineChart;
	import com.riameeting.finger.display.legend.SlideLegend;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	/**
	 * 线图
	 * @author NeoGuo
	 * 
	 */	
	public class LineChart extends UIComponent
	{
		private var chart:com.riameeting.finger.component.LineChart;
		private var _dataURL:String;
		private var dataLoaded:Boolean = false;
		
		protected var legend:SlideLegend;
		
		public var enabledZoom:Boolean = false;
		
		public function get dataURL():String
		{
			return _dataURL;
		}
		public function set dataURL(value:String):void
		{
			_dataURL = value;
		}
		
		public function get chartInstance():com.riameeting.finger.component.LineChart
		{
			return chart;
		}
		
		public function LineChart()
		{
			super();
			minWidth = 100;
			minHeight = 100;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			chart = new com.riameeting.finger.component.LineChart(minWidth,minHeight);
			addChild(chart);
			legend = new SlideLegend(chart,"line",0,0);
			addChild(legend);
			legend.x = chart.width;
			chart.bindLegend(legend);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			chart.enabledZoom = enabledZoom;
			chart.width = unscaledWidth;
			chart.height = unscaledHeight;
			legend.x = chart.width;
			legend.updateDisplayList(unscaledWidth,unscaledHeight);
			if(!dataLoaded)
			{
				chart.loadAssets({data:dataURL});
				chart.addEventListener(Event.COMPLETE,dataCompleteHandler);
			}
		}
		
		protected function dataCompleteHandler(event:Event):void
		{
			dataLoaded = true;
		}
		
	}
}