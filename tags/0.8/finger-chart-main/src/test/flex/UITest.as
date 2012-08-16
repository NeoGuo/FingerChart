package
{
	import com.riameeting.finger.component.*;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.events.ChartEvent;
	import com.riameeting.ui.control.Alert;
	import com.riameeting.ui.control.CheckBox;
	import com.riameeting.ui.control.Label;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * 测试类：测试UI组件
	 * @author Finger
	 * 
	 */	
	public class UITest extends Sprite
	{
		/**
		 * 构造方法
		 * 
		 */		
		public function UITest()
		{
			Alert.container = this;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(Event.ENTER_FRAME,checkStage);
		}
		/**
		 * 检查Stage是否获取了正确的宽度
		 * @param e
		 * 
		 */		
		protected function checkStage(e:Event):void {
			if(stage.stageWidth != 0) {
				init();
				removeEventListener(Event.ENTER_FRAME,checkStage);
			}
		}
		/**
		 * 初始化方法
		 * 
		 */		
		protected function init():void {
			//Label test
			var t:Label = new Label(true);
			addChild(t);
			t.text = "<b>Finger Chart UI示例</b>";
			//Label test
			var label:Label = new Label();
			addChild(label);
			label.x = 200;
			label.text = "100000";
			//check box
			var checkBox:CheckBox = new CheckBox();
			checkBox.selected = true;
			checkBox.y = 30;
			checkBox.label = "我是复选框";
			addChild(checkBox);
			//linechart
			var chartConfig1:Object = {data:"data/xml/linechart_data1.xml",skin:"skin/default_skin.swf",css:"css/default.css",plugin:"plugin/context_menu.swf"};
			var lineChart:LineChart = new LineChart(500,300);
			lineChart.chartConfig = chartConfig1;
			lineChart.x = 10;
			lineChart.y = 70;
			lineChart.loadAssets();
			addChild(lineChart);
			lineChart.addEventListener(ChartEvent.ITEM_CLICK,itemClickHandler);
			//columnchart
			var chartConfig2:Object = {data:"data/xml/columnchart_data1.xml",skin:"skin/default_skin.swf",css:"css/default.css",plugin:"plugin/context_menu.swf"};
			var columnChart:ColumnChart = new ColumnChart(500,300);
			columnChart.chartConfig = chartConfig2;
			columnChart.x = 520;
			columnChart.y = 70;
			columnChart.loadAssets();
			addChild(columnChart);
			//barchart
			var chartConfig3:Object = {data:"data/xml/barchart_data1.xml",skin:"skin/default_skin.swf",css:"css/default.css",plugin:"plugin/context_menu.swf"};
			var barChart:BarChart = new BarChart(500,300);
			barChart.chartConfig = chartConfig3;
			barChart.x = 10;
			barChart.y = 380;
			barChart.loadAssets();
			addChild(barChart);
			//piechart
			var chartConfig4:Object = {data:"data/xml/piechart_data1.xml",skin:"skin/default_skin.swf",css:"css/default.css",plugin:"plugin/context_menu.swf"};
			var pieChart:PieChart = new PieChart(500,300);
			pieChart.chartConfig = chartConfig4;
			pieChart.x = 520;
			pieChart.y = 380;
			pieChart.loadAssets();
			addChild(pieChart);
			//areachart
			var chartConfig5:Object = {data:"data/xml/linechart_data1.xml",skin:"skin/default_skin.swf",css:"css/default.css",plugin:"plugin/context_menu.swf"};
			var areaChart:AreaChart = new AreaChart(500,300);
			areaChart.chartConfig = chartConfig5;
			areaChart.x = 1020;
			areaChart.y = 70;
			areaChart.loadAssets();
			addChild(areaChart);
			//plotchart
			var chartConfig6:Object = {data:"data/xml/plotchart_data1.xml",skin:"skin/default_skin.swf",css:"css/default.css",plugin:"plugin/context_menu.swf"};
			var plotChart:PlotChart = new PlotChart(500,300);
			plotChart.chartConfig = chartConfig6;
			plotChart.x = 1020;
			plotChart.y = 380;
			plotChart.loadAssets();
			addChild(plotChart);
			//bubblechart
			var chartConfig7:Object = {data:"data/xml/plotchart_data1.xml",skin:"skin/default_skin.swf",css:"css/default.css",plugin:"plugin/context_menu.swf"};
			var bubbleChart:BubbleChart = new BubbleChart(500,300);
			bubbleChart.chartConfig = chartConfig7;
			bubbleChart.x = 10;
			bubbleChart.y = 700;
			bubbleChart.loadAssets();
			addChild(bubbleChart);
			//Alert test
			Alert.show("警告信息","hello");
		}
		
		private function itemClickHandler(e:ChartEvent):void {
			Alert.show(e.data[e.yField]);
		}
	}
}