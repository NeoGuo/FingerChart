package
{
	import com.as3long.fonts.FontLibrary;
	import com.riameeting.finger.component.*;
	import com.riameeting.finger.config.*;
	import com.riameeting.finger.display.axis.StackedAxis;
	import com.riameeting.finger.display.chart.*;
	import com.riameeting.utils.NumberTool;
	// import com.riameeting.finger.display.legend.*;
	import com.riameeting.finger.display.skin.*;
	import flash.text.Font;
	import ghostcat.debug.Debug;
	//import com.riameeting.utils.Debug;
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.utils.*;
	import ghostcat.debug.DebugPanel;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	[Frame(factoryClass = "Preloader")]
	public class AiCaiChart extends Sprite
	{
		//private var btnArr:Array = [];
		private var typeDic:Dictionary = new Dictionary();
		private var pluginDic:Dictionary = new Dictionary();
		private var areaChart:AbstractChart;
		private var chartConfig1:Object;
		private var baseUrl:String = '';
		
		public function AiCaiChart():void
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		//private var dcon:developerconsole;
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			//stage.quality = StageQuality.LOW;skin:"skin/cartoon_skin.swf"
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//new DebugPanel(stage);
			new FontLibrary();
			Debug.DEBUG = false;
			Debug.traceAll(Font.enumerateFonts());
			chartConfig1 = { };
			//chartConfig1 = { data: "data/json/myColumnchart.txt", css: "css/default.css", type: "MyColumnChart" };
			//chartConfig1 = {data: "data/json/pie3d_json_error2.txt", css: "css/default.css", type: "PieChart3D"};
			ChartGlobal.version = 'v2013031301';
			var h:Number = stage.stageHeight;
			var w:Number = stage.stageWidth;
			ChartGlobal.width = w;
			ChartGlobal.height = h;
			//stage.scaleMode = StageScaleMode.SHOW_ALL;
			//stage.addEventListener(Event.RESIZE, resize);
			stage.align = StageAlign.TOP;
			if (loaderInfo.parameters != null && ExternalInterface.available == true)
			{
				chartConfig1 = loaderInfo.parameters;
			}
			
			if (chartConfig1.baseUrl != null)
			{
				baseUrl = chartConfig1.baseUrl;
			}
			
			if (chartConfig1.type == null)
			{
				chartConfig1.type = 'AreaChart';
			}
			
			if (chartConfig1.css == null)
			{
				chartConfig1.css = baseUrl + 'css/default.css';
			}
			
			pluginDic['AreaChart'] = baseUrl + 'plugin/btn_List.swf';
			pluginDic['MyColumnChart'] = baseUrl + 'plugin/MyColumnChart_list.swf';
			pluginDic['PieChart3D'] = baseUrl + 'plugin/pie3d_List.swf';
			pluginDic['PieChart'] = baseUrl + 'plugin/pie_List.swf';
			pluginDic['StackedColumnChart'] = baseUrl + 'plugin/stackedColumn_List.swf';
			pluginDic['CompareLineChart'] = baseUrl + "plugin/bottonList.swf";
			pluginDic['ColumnChart'] = baseUrl + "plugin/CompareColumnChart_list.swf";
			if (chartConfig1.plugin == null)
			{
				chartConfig1.plugin = pluginDic[chartConfig1.type];
			}
			
			if (chartConfig1.plugin == null)
			{
				w += 200;
			}
			
			if (chartConfig1.type == 'CompareLineChart' || chartConfig1.type == 'ColumnChart')
			{
				h -= 50;
				w += 200;
			}
			
			typeDic['HorizontalColumnChart'] = HorizontalColumnChart;
			typeDic['AreaChart'] = AreaChart;
			typeDic['BubbleChart'] = BubbleChart;
			typeDic['ColumnChart'] = CompareColumnChart;
			typeDic['LineChart'] = LineChart;
			typeDic['MyColumnChart'] = MyColumnChart;
			typeDic['PieChart'] = PieChart;
			typeDic['PieChart3D'] = PieChart3D;
			typeDic['PlotChart'] = PlotChart;
			typeDic['StackedColumnChart'] = StackedColumnChart;
			typeDic['CompareLineChart'] = CompareLineChart;
			//areaChart
			//FlashConnect.trace('宽度' + h );
			Debug.trace("宽度", h);
			//this.loaderInfo.
			areaChart = new typeDic[chartConfig1.type](w - 250, h);
			areaChart.chartConfig = chartConfig1;
			//areaChart.x = 0;
			//areaChart.y = 0;
			areaChart.loadAssets();
			addChild(areaChart);
			Debug.traceObject("chartConfig", chartConfig1);
			/*var legend:SimpleLegend = new SimpleLegend(areaChart, "number", 220, stage.height);
			addChild(legend);
			legend.x = areaChart.width;
			areaChart.bindLegend(legend);*/
			if (chartConfig1.type == "AreaChart")
			{
				ChartGlobal.getSkin("skin.AxisSkin");
				ChartGlobal.skinClassDict["skin.AxisSkin"] = MyAxisSkin;
			}
			else if (chartConfig1.type == "LineChart" || chartConfig1.type == "CompareLineChart")
			{
				ChartGlobal.getSkin("skin.AxisSkin");
				ChartGlobal.skinClassDict["skin.AxisSkin"] = CompareAxisSkin;
			}
			else if (chartConfig1.type == "MyColumnChart" || chartConfig1.type == "StackedColumnChart")
			{
				ChartGlobal.getSkin("skin.AxisSkin");
				ChartGlobal.skinClassDict["skin.AxisSkin"] = MyColumnAxisSkin;
				
			}
			else if (chartConfig1.type == "ColumnChart")
			{
				ChartGlobal.getSkin("skin.AxisSkin");
				ChartGlobal.skinClassDict["skin.AxisSkin"] = MyColumnAxisSkin;
				ChartGlobal.skinClassDict["skin.ColumnGraphic"] = CompareColumnGraphicSkin;
			}
			ChartGlobal.chartConfig = chartConfig1;
			areaChart['chartGlobal'] = ChartGlobal;
			//dcon = new developerconsole(this);
			//addChild(dcon);
			//dcon.open();
		}
	
	}

}