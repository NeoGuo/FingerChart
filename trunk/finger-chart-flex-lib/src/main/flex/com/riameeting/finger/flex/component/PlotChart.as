package com.riameeting.finger.flex.component
{
	import com.riameeting.finger.component.LineChart;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	/**
	 * 散点图
	 * @author NeoGuo
	 * 
	 */	
	public class PlotChart extends UIComponent
	{
		private var chart:com.riameeting.finger.component.PlotChart;
		private var _dataURL:String;
		private var dataLoaded:Boolean = false;
		
		public function get dataURL():String
		{
			return _dataURL;
		}
		public function set dataURL(value:String):void
		{
			_dataURL = value;
		}
		
		public function get chartInstance():com.riameeting.finger.component.PlotChart
		{
			return chart;
		}
		
		public function PlotChart()
		{
			super();
			minWidth = 100;
			minHeight = 100;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			chart = new com.riameeting.finger.component.PlotChart(minWidth,minHeight);
			addChild(chart);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			chart.width = unscaledWidth;
			chart.height = unscaledHeight;
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