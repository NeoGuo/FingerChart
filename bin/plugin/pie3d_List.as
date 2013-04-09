package
{
	
	import com.riameeting.finger.display.graphic.IChartGraphic;
	import com.riameeting.finger.events.ChartEvent;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.StringUtils;
	import flash.text.TextFormatAlign;
	import ghostcat.debug.Debug;
	//import com.riameeting.utils.Debug;
	import flash.display.MovieClip;
	import com.riameeting.finger.plugin.IChartPlugin;
	import com.riameeting.finger.display.container.IPluginContainer;
	import flash.display.DisplayObject;
	import com.riameeting.finger.display.chart.IChart;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.parser.CSVParser;
	import com.riameeting.finger.vo.DatasetVO;
	
	public class pie3d_List extends MovieClip implements IChartPlugin
	{
		
		private var container:IPluginContainer;
		private var dataset:DatasetVO;
		private var chartRef:IChart;
		private var style:Object;
		private var btnArr:Array = [];
		private var styleCss:Object;
		
		/**
		 * 第一次初始化标记
		 */
		private var firstFleg:Boolean = false;
		
		public function pie_List()
		{
		
		}
		
		public function initPlugin(container:IPluginContainer):void
		{
			if (firstFleg == true)
			{
				return;
			}
			firstFleg = true;
			this.container = container;
			chartRef = container.chartRef;
			dataset = container.dataset;
			style = ChartGlobal.colorCollection;
			styleCss = container.chartRef.axis.style;
			Debug.traceObject("styleCss",styleCss);
			var i:Number = 0;
			var j:Number = 0;
			var yField:Array = String(dataset.config.yField).split(",", 10);
			var danweiArr:Array = String(dataset.config.qualifier).split(",", 10);
			var allYField:Array = [];
			while (yField[j])
			{
				allYField[j] = 0;
				j++;
			}
			while (dataset.collection[i])
			{
				j = 0
				while (yField[j])
				{
					allYField[j] += Number(dataset.collection[i][yField[j]]);
					j++;
				}
				i++;
			}
			
			
			var maxTextWidth1:Number=0;
			var maxTextWidth2:Number=0;
			var maxTextWidth3:Number = 0;
			var testLabel:Label = new Label();
			for (i = 0; i < dataset.collection.length; i++)
			{
				var str1:String = '■   ' + dataset.collection[i][dataset.config.categoryField].split("\n").join("");
				var str2:String = (Number(dataset.collection[i][yField[0]]) / allYField[0] * 100).toFixed(2) + '%';
				var str3:String = '';
				if (dataset.collection[i][yField[0] + "_tooltext"])
				{
					str3 =dataset.collection[i][yField[0] + "_tooltext"];
				}
				else
				{
					str3 =StringUtils.fomart(dataset.collection[i][yField[0]])+ danweiArr[0];
				}
				testLabel.text = str1;
				if (testLabel.width > maxTextWidth1)
				{
					maxTextWidth1 = testLabel.width ;
				}
				testLabel .text = str2;
				if (testLabel.width  > maxTextWidth2)
				{
					maxTextWidth2 = testLabel.width;
				}
				testLabel.text = str3;
				if (testLabel.width  > maxTextWidth3)
				{
					maxTextWidth3 = testLabel.width;
				}
			}
			
			for (i = 0; i < dataset.collection.length; i++)
			{
				var btn:MovieClip = new ChartButton2();
				btn.bg.stop();
				if (maxTextWidth1 +maxTextWidth2 + maxTextWidth3 + 2 > 220)
				{
					btn.bg.width = maxTextWidth1 +maxTextWidth2 + maxTextWidth3 + 2;
				}
				var btnLabel1:Label = new Label();
				//btnLabel1.width = maxTextWidth1;
				//btnLabel1.height = 24;
				btnLabel1.y = 8;
				btnLabel1.x = 0;
				
				var btnLabel2:Label = new Label();
				//btnLabel2.width = maxTextWidth2;
				//btnLabel2.height = 24;
				btnLabel2.x = maxTextWidth1 + 1;
				btnLabel2.y = 8;
				
				var btnLabel3:Label = new Label();
				//btnLabel3.width = maxTextWidth3;
				//btnLabel3.height = 24;
				btnLabel3.x = maxTextWidth1 +maxTextWidth2 +2;
				btnLabel3.y = 8;
				btn.addChild(btnLabel1);
				btn.addChild(btnLabel2);
				btn.addChild(btnLabel3);
				
				btn.mouseChildren = false;
				btn.addEventListener(MouseEvent.ROLL_OVER, rool_over);
				btn.addEventListener(MouseEvent.ROLL_OUT, rool_out);
				btn.name = i.toString();
				btn.x = stage.stageWidth - btn.width;
				btn.y = i * (btn.height - 1) + styleCss.paddingTop;
				
				btnLabel1.color = style[i];
				btnLabel1.text = '■   ' + dataset.collection[i][dataset.config.categoryField].split("\n").join("");
				btnLabel2.color = 0x5A5A5A;
				btnLabel2.text = (Number(dataset.collection[i][yField[0]]) / allYField[0] * 100).toFixed(2) + '%';
				//btnLabel3.color = 0xFF0000;
				//btnLabel3.htmlMode = true;
				btnLabel3.setPadding(TextFormatAlign.RIGHT);
				if (dataset.collection[i][yField[0] + "_tooltext"])
				{
					btnLabel3.text = dataset.collection[i][yField[0] + "_tooltext"];
				}
				else
				{
					if (danweiArr[0] == "元")
					{
						btnLabel3.color = 0xD83333;
					}
					btnLabel3.text =StringUtils.fomart(dataset.collection[i][yField[0]]) + danweiArr[0];
				}
				
				if (btnLabel3.text == "")
				{
					btnLabel2.setPadding(TextFormatAlign.RIGHT);
					btnLabel2.setWidth(maxTextWidth2);
				}
				btnLabel3.setWidth(maxTextWidth3);
				stage.addChild(btn);
				btnArr.push(btn);
			}
			if ( (maxTextWidth1 +maxTextWidth2 + maxTextWidth3 + 2)<= 220)
			{
				
			}
			else
			{
				chartRef.width = stage.stageWidth - (maxTextWidth1 +maxTextWidth2 + maxTextWidth3 + 2);
				chartRef.updateDisplayList();
			}
		}
		
		private function btnAll_onClick(e:MouseEvent):void
		{
			for (var i:Number = 0; i < btnArr.length; i++)
			{
				btnArr[i].bg.gotoAndStop(1);
				btnArr[i].slected = false;
				container.chartRef.chartGraphicContainer.showSeries(btnArr[i].name);
			}
		}
		
		private function btn_onClick(e:MouseEvent):void
		{
			if (e.target.slected != null && e.target.slected == true)
			{
				e.target.bg.gotoAndStop(1);
				e.target.slected = false;
				container.chartRef.chartGraphicContainer.showSeries(e.target.name);
			}
			else
			{
				e.target.bg.gotoAndStop(3);
				e.target.slected = true;
				container.chartRef.chartGraphicContainer.hideSeries(e.target.name);
			}
		}
		
		private function rool_out(e:MouseEvent):void
		{
			if (e.target.slected && e.target.slected == true)
			{
				
			}
			else
			{
				e.target.bg.gotoAndStop(1);
				var g:IChartGraphic = chartRef.chartGraphicContainer.graphicsCollection[Number(e.target.name)];
				g.state = MouseEvent.MOUSE_OUT;
			}
		
		}
		
		private function rool_over(e:MouseEvent):void
		{
			if (e.target.slected && e.target.slected == true)
			{
				
			}
			else
			{
				e.target.bg.gotoAndStop(2);
				var g:IChartGraphic = chartRef.chartGraphicContainer.graphicsCollection[Number(e.target.name)];
				chartRef.tooltipContainer["showToolTip"](g);
				g.state = MouseEvent.MOUSE_OVER;
			}
		}
		
		public function updateDisplayList(w:uint, h:uint):void
		{
		
		}
	}

}
