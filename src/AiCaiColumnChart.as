package 
{
	import com.riameeting.finger.component.*;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.skin.MyAxisSkin;
	import com.riameeting.finger.display.skin.MyColumnAxisSkin;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class AiCaiColumnChart extends Sprite 
	{
		//private var btnArr:Array = [];
		public function AiCaiColumnChart():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			//stage.quality = StageQuality.LOW;skin:"skin/cartoon_skin.swf"
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP;
			var chartConfig1:Object = { data:"data/xml/columnchart_data1.xml", css:"css/default.css", plugin:"plugin/pie_List.swf" };
			var h:Number = stage.stageHeight;
			if (loaderInfo.parameters != null&&loaderInfo.parameters.data!=null)
			{
				chartConfig1 = loaderInfo.parameters;
			}
			/*var lineChart:LineChart = new LineChart(500,300);
			lineChart.chartConfig = chartConfig1;
			lineChart.x = 10;
			lineChart.y = 70;
			lineChart.loadAssets();
			addChild(lineChart);*/
			
			//areaChart
			var areaChart:MyColumnChart = new MyColumnChart(500, h);
			areaChart.chartConfig = chartConfig1;
			areaChart.x = 0;
			areaChart.y = 0;
			areaChart.loadAssets();
			addChild(areaChart);
			ChartGlobal.getSkin("skin.AxisSkin");
			ChartGlobal.skinClassDict["skin.AxisSkin"] = MyColumnAxisSkin;
			
		}
		
	}
	
}