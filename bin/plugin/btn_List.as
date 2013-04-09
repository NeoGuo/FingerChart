package  {
	
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.ObjectUtils;
	import com.riameeting.utils.StringUtils;
	import flash.display.MovieClip;
	import com.riameeting.finger.plugin.IChartPlugin;
	import com.riameeting.finger.display.container.IPluginContainer;
	import flash.display.DisplayObject;
	import com.riameeting.finger.display.chart.IChart;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	import ghostcat.debug.Debug;
	import ghostcat.operation.TimeoutOper;
	
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.parser.CSVParser;
	import com.riameeting.finger.vo.DatasetVO;
	
	
	public class btn_List extends MovieClip implements IChartPlugin{
		
		private var container:IPluginContainer;
		private var dataset:DatasetVO;
		private var chartRef:IChart;
		private var style:Object;
		private var btnArr:Array = [];
		private var styleCss:Object;
		private var firstFleg:Boolean = false;
		private var showYField:String = '';
		public function btn_List() {
			// constructor code
		}
		
		public function initPlugin(container:IPluginContainer):void {
			
			if (firstFleg == true)
			{
				return;
			}
			//this.parent.parent.setChildIndex(this.parent, 0);
			firstFleg = true;
			this.container = container;
			chartRef = container.chartRef;
			dataset = container.dataset;
			style = ChartGlobal.colorCollection;
			styleCss = container.chartRef.axis.style;
			if (chartRef['chartGlobal'].baseDataSet == null)
			{
				trace("baseDataSet");
				chartRef['chartGlobal'].baseDataSet = new Object();
				chartRef['chartGlobal'].baseDataSet.config = ObjectUtils.clone(container.dataset.config);
			}
			var i:Number = 0;
			var j:Number = 0;
			
			var showItemTotal:String="";
			var itemtotals:String = "";
			var itemtotalsArr:Array = [];
			if (dataset.config.showItemTotal != null)
			{ 
				showItemTotal = dataset.config.showItemTotal;
			}
			if (dataset.config.itemtotals!=null)
			{
				itemtotals = dataset.config.itemtotals;
				itemtotalsArr=itemtotals.split(",", 100);
			}
			if (dataset.config.showYField)
			{
				showYField = dataset.config.showYField;
			}
			var yField:Array = String(dataset.config.yField).split(",", 100);
			var qualifierStr:String
			if (dataset.config.qualifier != null)
			{
				qualifierStr = String(dataset.config.qualifier);
			}
			else
			{
				qualifierStr = '';
			}
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
					//Debug.trace("Number", Number(dataset.collection[i][yField[j]]));
					allYField[j] =Math.floor(add(allYField[j],Number(dataset.collection[i][yField[j]]))*100)/100;
					//Debug.trace("NumberAll", allYField[j]);
					j++;
				}
				i++;
			}
			Debug.trace("总和", allYField);
			var maxTextWidth1:Number=0;
			var maxTextWidth2:Number=0;
			var maxTextWidth3:Number = 0;
			var testLabel:Label = new Label();
			for (i = 0; i < dataset.collection.length; i++)
			{
				var str1:String = '    ■   ' + yField[i]+' ';
				var infoStr1:String = "";
				if (showItemTotal == "" || showItemTotal == "1")
				{
					infoStr1=allYField[i] + qualifierStr;
					//btn.txt.text = '■   ' + yField[i];
				}
				else if (showItemTotal == "2")
				{
					infoStr1 = '';
				}
				else if (showItemTotal == "3")
				{
					if (itemtotalsArr.length > i)
					{
						infoStr1=itemtotalsArr[i]+ qualifierStr;
					}
				}
				
				var str2:String = infoStr1+' ';
				var str3:String = '';
				
				if (dataset.collection[0].info != null)
				{
					str3 =dataset.collection[0].info+' ';
				}
				else if (dataset.collection[i][yField[0] + "_tooltext"])
				{
					str3 =dataset.collection[i][yField[0] + "_tooltext"]+' ';
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
			ChartButton2.prototype.label1 = new Sprite();
			ChartButton2.prototype.label2 = new Sprite();
			ChartButton2.prototype.label3 = new Sprite();
			for (i = 0; i < yField.length; i++)
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
				btn.label1 = btnLabel1;
				btn.label2 = btnLabel2;
				btn.label3 = btnLabel3;
				btn.mouseChildren = false;
				btn.addEventListener(MouseEvent.ROLL_OVER, rool_over);
				btn.addEventListener(MouseEvent.ROLL_OUT, rool_out);
				btn.buttonMode = true;
				btn.name = yField[i];
				if (yField.length!= 1)
				{
					btn.addEventListener(MouseEvent.CLICK, btn_onClick);
				}
				else
				{
					btn.buttonMode = false;
					btn.mouseEnabled = false;
				}
				btn.x = stage.stageWidth - btn.width;
				btn.y = i * (btn.height - 1)+styleCss.paddingTop;
				btnLabel1.color = style[i];
				btnLabel1.lastColor = btnLabel1.color;
				var infoStr:String = "";
				if (showItemTotal == "" || showItemTotal == "1")
				{
					infoStr= '' +StringUtils.fomart(allYField[i]) + qualifierStr;
					btnLabel1.text = '    ■   ' + yField[i];
				}
				else if (showItemTotal == "2")
				{
					infoStr = '';
				}
				else if (showItemTotal == "3")
				{
					if (itemtotalsArr.length > i)
					{
						infoStr= '' + itemtotalsArr[i];
					}
				}
				btnLabel1.text = '    ■   ' + yField[i];
				if (qualifierStr == "元")
				{
					btnLabel2.color = 0xFF0000;
				}
				else
				{
					btnLabel2.color = 0x5A5A5A;
				}
				btnLabel2.text = infoStr;
				btnLabel2.lastColor = btnLabel2.color;
				//btn.txt.setTextFormat(new TextFormat(null, null, 0xFF0000), String(btn.txt.text).length - infoStr.length, String(btn.txt.text).length);
				btnLabel3.setPadding(TextFormatAlign.RIGHT);
				if (dataset.collection[0].info != null)
				{
					btnLabel3.color = style[i];
					btnLabel3.text= dataset.collection[0].info;
				}
				else
				{
					btnLabel2.setPadding(TextFormatAlign.RIGHT);
					btnLabel2.setWidth(maxTextWidth2);
				}
				btnLabel3.setWidth(maxTextWidth3);
				btnLabel3.lastColor = btnLabel3.color;
				addChild(btn);
				btnArr.push(btn);
			}
			if (yField.length > 1)
			{
				var btnAll:MovieClip = new ChartButton3();
				btnAll.bg.stop();
				if (maxTextWidth1 +maxTextWidth2 + maxTextWidth3 + 2 > 220)
				{
					btnAll.bg.width = maxTextWidth1 +maxTextWidth2 + maxTextWidth3 + 2;
				}
				btnAll.mouseChildren = false;
				btnAll.addEventListener(MouseEvent.ROLL_OVER, rool_over);
				btnAll.addEventListener(MouseEvent.ROLL_OUT, rool_out);
				btnAll.addEventListener(MouseEvent.CLICK, btnAll_onClick);
				btnAll.buttonMode = true;
				btnAll.x = btnArr[0].x;
				btnAll.y = i * (btn.height - 1) + styleCss.paddingTop;
				var btnAllLabel:Label = new Label();
				btnAllLabel.color = 0x5A5A5A;
				btnAllLabel.text = '    全部';
				btnAllLabel.y = 8;
				btnAll.addChild(btnAllLabel);
				addChild(btnAll);
			}
			if ( (maxTextWidth1 +maxTextWidth2 + maxTextWidth3 + 2)<= 220)
			{
				
			}
			else
			{
				chartRef.width = stage.stageWidth -(maxTextWidth1 +maxTextWidth2 + maxTextWidth3 + 2);
				container.chartRef.dataset.config = ObjectUtils.clone(chartRef['chartGlobal'].baseDataSet.config);
				container.chartRef.dataset = container.chartRef.dataset;
			}
			setTimeout(checkShowYField, 200);
		}
		
		private function checkShowYField():void
		{
			if (showYField == '' || showYField == 'undefined')
			{
				return;
			}
			var showYFieldArr:Array = [];
			showYFieldArr = showYField.split(",", 100);
			trace(showYFieldArr);
			var showBtnArr:Array = [];
			
			var notShowArr:Array = [];
			
			for (var i:int = 0; i < btnArr.length; i++)
			{
				for (var j:int = 0; j < showYFieldArr.length; j++)
				{
					if (btnArr[i].name == showYFieldArr[j])
					{
						showBtnArr.push(btnArr[i]);
					}
				}
			}
			
			//trace(showYFieldArr);
			
			for (i = 0;i < btnArr.length; i++ )
			{
				if (showBtnArr.indexOf(btnArr[i]) == -1)
				{
					notShowArr.push(btnArr[i]);
				}
			}
			//trace(showYFieldArr);
			for (j = 0; j < notShowArr.length; j++)
			{
				trace(notShowArr[j].name);
				notShowArr[j].bg.gotoAndStop(3);
				notShowArr[j].label1.lastColor = notShowArr[j].label1.color;
				notShowArr[j].label2.lastColor = notShowArr[j].label2.color;
				notShowArr[j].label3.lastColor = notShowArr[j].label3.color;
				notShowArr[j].label1.color = 0xAAAAAA;
				notShowArr[j].label2.color = 0xAAAAAA;
				notShowArr[j].label3.color = 0xAAAAAA;
				notShowArr[j].slected = true;
				container.chartRef.chartGraphicContainer['hideAndReDraw'](notShowArr[j].name);
			}
			container.chartRef.dataset = container.chartRef.dataset;
		}
		
		private function btnAll_onClick(e:MouseEvent):void 
		{
			for (var i:Number = 0; i < btnArr.length; i++)
			{
				btnArr[i].label1.color = btnArr[i].label1.lastColor;
				btnArr[i].label2.color = btnArr[i].label2.lastColor;
				btnArr[i].label3.color = btnArr[i].label3.lastColor;
				btnArr[i].bg.gotoAndStop(1);
				btnArr[i].slected = false;
			}
			container.chartRef.dataset.config = ObjectUtils.clone(chartRef['chartGlobal'].baseDataSet.config);
			container.chartRef.dataset = container.chartRef.dataset;
		}
		
		public function add(a:Number, b:Number):Number
		{
			var aStr:String = a.toString();
			var bStr:String = b.toString();
			var aArr:Array = aStr.split(".", 2);
			var bArr:Array = bStr.split(".", 2);
			if (aArr.length == 2 && bArr.length == 2)
			{
				var maxLen:int = 0;
				if (aArr[1].length > bArr[1].length)
				{
					maxLen = aArr[1].length;
				}
				else
				{
					maxLen = bArr[1].length;
				}
				var num:Number = Math.pow(10, maxLen);
				return (a*num+b*num)*Math.pow(10, -maxLen);
			}
			else
			{
				return a + b;
			}
		}
		
		private function btn_onClick(e:MouseEvent):void
		{
			if (e.target.slected!=null&&e.target.slected == true)
			{
				(e.target as ChartButton2).label1.color = (e.target as ChartButton2).label1.lastColor;
				(e.target as ChartButton2).label2.color = (e.target as ChartButton2).label2.lastColor;
				(e.target as ChartButton2).label3.color = (e.target as ChartButton2).label3.lastColor;
				e.target.bg.gotoAndStop(1);
				e.target.slected = false;
				container.chartRef.chartGraphicContainer['showAndReDraw'](e.target.name);
				//container.chartRef.chartGraphicContainer.showSeries(e.target.name);
			}
			else
			{
				var selectNum:Number = 0;
				for (var i:Number = 0; i < btnArr.length; i++)
				{
					if (btnArr[i].slected != null && btnArr[i].slected == true)
					{
						selectNum++;
					}
				}
				if (selectNum >= btnArr.length - 1)
				{
					return;
				}
				(e.target as ChartButton2).label1.lastColor = (e.target as ChartButton2).label1.color;
				(e.target as ChartButton2).label2.lastColor = (e.target as ChartButton2).label2.color;
				(e.target as ChartButton2).label3.lastColor = (e.target as ChartButton2).label3.color;
				(e.target as ChartButton2).label1.color = 0xAAAAAA;
				(e.target as ChartButton2).label2.color = 0xAAAAAA;
				(e.target as ChartButton2).label3.color = 0xAAAAAA;
				e.target.bg.gotoAndStop(3);
				e.target.slected = true;
				container.chartRef.chartGraphicContainer['hideAndReDraw'](e.target.name);
				//container.chartRef.chartGraphicContainer.hideSeries(e.target.name);
			}
			container.chartRef.dataset = container.chartRef.dataset;
		}
		
		private function rool_out(e:MouseEvent):void 
		{
			if (e.target.slected && e.target.slected == true)
			{
				
			}
			else
			{
				e.target.bg.gotoAndStop(1);
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
			}
		}
		
		public function updateDisplayList(w:uint,h:uint):void {
			
		}
	}
	
}
