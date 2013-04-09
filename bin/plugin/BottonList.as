package
{
	
	import com.riameeting.utils.ObjectUtils;
	import flash.display.MovieClip;
	import com.riameeting.finger.plugin.IChartPlugin;
	import com.riameeting.finger.display.container.IPluginContainer;
	import flash.display.DisplayObject;
	import com.riameeting.finger.display.chart.IChart;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ghostcat.debug.Debug;
	
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.parser.CSVParser;
	import com.riameeting.finger.vo.DatasetVO;
	
	public class BottonList extends MovieClip implements IChartPlugin
	{
		
		private var Container:IPluginContainer;
		private var dataset:DatasetVO;
		private var chartRef:IChart;
		private var style:Object;
		private var btnArr:Array = [];
		private var firstFleg:Boolean = false;
		
		public function btn_List()
		{
			// constructor code
		}
		
		public function initPlugin(container:IPluginContainer):void
		{
			if (firstFleg == true)
			{
				return;
			}
			firstFleg = true;
			this.Container = container;
			chartRef = container.chartRef;
			dataset = container.dataset;
			style = chartRef['chartGlobal'].colorCollection;
			if (chartRef['chartGlobal'].baseDataSet == null)
			{
				trace("baseDataSet");
				chartRef['chartGlobal'].baseDataSet = new Object();
				chartRef['chartGlobal'].baseDataSet.config = ObjectUtils.clone(container.dataset.config);
			}
			var i:int = 0;
			var j:int = 0;
			
			trace(dataset.config.yField);
			//return;
			var yField:Array = String(dataset.config.yField).split(",", 100);
			var qualifierStr:String = String(dataset.config.qualifier);
			var bottonListView:BottonListView = new BottonListView();
			bottonListView.y = stage.stageHeight - bottonListView.height;
			if (dataset.config.compare != null)
			{
				bottonListView.setText(dataset.config.compare);
			}
			addChild(bottonListView);
			
			var buttonLength:Number = 0;
			for (i = 0; i < yField.length; i += 2)
			{
				var chartButton:ChartButton = new ChartButton();
				chartButton.txt.textColor = style[int(i / 2)];
				if (yField[i].substring(0, yField[i].length - 1) == yField[i + 1].substring(0, yField[i + 1].length - 1))
				{
					chartButton.setText('■ ' + yField[i].substring(0, yField[i].length - 1));
				}
				else if (yField[i].replace("-虚线", "") == yField[i].replace("-虚线", ""))
				{
					chartButton.setText('■ ' + yField[i].replace("-虚线", ""));
				}
				else
				{
					chartButton.setText('■' + yField[i] + ' ●' + yField[i + 1]);
				}
				btnArr.push(chartButton);
				chartButton.name = yField[i] + ',' + yField[i + 1];
				if (yField.length != 2)
				{
					chartButton.addEventListener(MouseEvent.CLICK, btn_onClick);
				}
				else
				{
					chartButton.mouseEnabled = false;
					chartButton.buttonMode = false;
				}
				buttonLength += chartButton.width + 5;
				addChild(chartButton);
			}
			var quanbuButton:ChartButton = new ChartButton();
			quanbuButton.setText('全部');
			btnArr.push(quanbuButton);
			buttonLength += quanbuButton.width + 25;
			addChild(quanbuButton);
			quanbuButton.addEventListener(MouseEvent.CLICK, btnAll_onClick);
			btnArr[0].x = stage.stageWidth - buttonLength;
			for (i = 1; i < btnArr.length; i++)
			{
				btnArr[i].x = btnArr[i - 1].x + 5 + btnArr[i - 1].width;
			}
		}
		
		private function btnAll_onClick(e:MouseEvent):void
		{
			for (var i:int = 0; i < btnArr.length; i++)
			{
				btnArr[i].selected = false;
			}
			//e.target.selected = false;
			Container.chartRef.dataset.config = ObjectUtils.clone(chartRef['chartGlobal'].baseDataSet.config);
			Container.chartRef.dataset = Container.chartRef.dataset;
		}
		
		private function btn_onClick(e:MouseEvent):void
		{
			var nameArr:Array = e.target.name.split(',', 2);
			var numSelect:int = 0;
			for (var i:int = 0; i < btnArr.length; i++)
			{
				if (btnArr[i].selected == false)
				{
					numSelect++;
				}
			}
			if (numSelect == 1)
			{
				if (e.target.selected != null)
				{
					e.target.selected = false;
				}
				return;
			}
			
			if (e.target.selected != null && e.target.selected == false)
			{
				//e.target.gotoAndStop(1);
				//container.chartRef.chartGraphicContainer.showSeries(nameArr[0]);
				//container.chartRef.chartGraphicContainer.showSeries(nameArr[1]);
				Container.chartRef.chartGraphicContainer['showAndReDraw'](nameArr[0]);
				Container.chartRef.chartGraphicContainer['showAndReDraw'](nameArr[1]);
			}
			else if (e.target.selected != null && e.target.selected == true)
			{
				//e.target.gotoAndStop(2);
				//container.chartRef.chartGraphicContainer.hideSeries(nameArr[0]);
				//container.chartRef.chartGraphicContainer.hideSeries(nameArr[1]);
				Container.chartRef.chartGraphicContainer['hideAndReDraw'](nameArr[0]);
				Container.chartRef.chartGraphicContainer['hideAndReDraw'](nameArr[1]);
			}
			Container.chartRef.dataset = Container.chartRef.dataset;
		}
		
		public function updateDisplayList(w:uint, h:uint):void
		{
		
		}
	}

}