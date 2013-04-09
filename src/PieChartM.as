package 
{
	import com.riameeting.finger.component.*;
	import com.riameeting.finger.config.*;
	import com.riameeting.finger.display.axis.StackedAxis;
	import com.riameeting.finger.display.chart.*;
	import com.riameeting.finger.display.skin.*;
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	[Frame(factoryClass="Preloader2")]
	public class PieChartM extends Sprite 
	{
		//private var btnArr:Array = [];
		private var typeDic:Dictionary = new Dictionary();
		private var pluginDic:Dictionary = new Dictionary();
		private var areaChart:AbstractChart;
		private var chartConfig1:Object;
		private var baseUrl:String = '';
		public function PieChartM():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//chartConfig1 = {data:"data/xml/piechart_data1.xml",css:"css/default.css",type:"PieChart3D"};
			chartConfig1 = { };
			var h:Number = stage.stageHeight;
			var w:Number = stage.stageWidth;
			//stage.scaleMode = StageScaleMode.SHOW_ALL;
			//stage.addEventListener(Event.RESIZE, resize);
			stage.align = StageAlign.TOP;
			if (loaderInfo.parameters != null&&ExternalInterface.available==true)
			{
				chartConfig1 = loaderInfo.parameters;
			}
			
			if (chartConfig1.baseUrl != null)
			{
				baseUrl = chartConfig1.baseUrl;
			}
			
			if (chartConfig1.type == null)
			{
				chartConfig1.type = 'PieChart3D';
			}
			
			if (chartConfig1.css == null)
			{
				chartConfig1.css = baseUrl+'css/default.css';
			}
			
			if (chartConfig1.type == 'CompareLineChart')
			{
				h -= 50;
				w += 250;
			}
			
			//typeDic['HorizontalColumnChart'] = HorizontalColumnChart;
			//typeDic['AreaChart'] = AreaChart;
			//typeDic['BubbleChart'] = BubbleChart;
			//typeDic['ColumnChart'] = ColumnChart;
			//typeDic['LineChart'] = LineChart;
			//typeDic['MyColumnChart'] = MyColumnChart;
			//typeDic['PieChart'] = PieChart;
			typeDic['PieChart3D'] = PieChart3D;
			//typeDic['PlotChart'] = PlotChart;
			//typeDic['StackedColumnChart'] = StackedColumnChart;
			//typeDic['CompareLineChart'] = CompareLineChart;
			//areaChart
			//FlashConnect.trace('宽度' + h );
			//this.loaderInfo.
			areaChart= new typeDic[chartConfig1.type](w, h);
			areaChart.chartConfig = chartConfig1;
			//areaChart.x = 0;
			//areaChart.y = 0;
			areaChart.loadAssets();
			addChild(areaChart);
			if (chartConfig1.type == "AreaChart")
			{
				ChartGlobal.getSkin("skin.AxisSkin");
				ChartGlobal.skinClassDict["skin.AxisSkin"] = MyAxisSkin;
			}
			else if(chartConfig1.type == "LineChart"||chartConfig1.type=="CompareLineChart")
			{
				ChartGlobal.getSkin("skin.AxisSkin");
				ChartGlobal.skinClassDict["skin.AxisSkin"] = CompareAxisSkin;
			}
			else if (chartConfig1.type == "MyColumnChart"||chartConfig1.type == "ColumnChart"||chartConfig1.type == "StackedColumnChart")
			{
				ChartGlobal.getSkin("skin.AxisSkin");
				ChartGlobal.skinClassDict["skin.AxisSkin"] = MyColumnAxisSkin;
			}
			ChartGlobal.chartConfig = chartConfig1;
			areaChart['chartGlobal'] = ChartGlobal;
		}
		
	}
	
}