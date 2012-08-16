package com.riameeting.finger.display.legend
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.ui.control.CheckBox;
	import com.riameeting.ui.control.GraphicLabel;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 专用于移动设备的图例说明
	 * @author Finger
	 * 
	 */	
	public class SlideLegend extends Sprite implements ILegend
	{
		private var _dataset:DatasetVO;
		private var _style:Object = {color:0xFFFFFF,paddingTop:0,paddingLeft:0,benchmarkColor:0xCCCCCC,bgColor:0x666666,bgAlpha:100};
		/**
		 * 标签容器
		 */		
		protected var labelContainer:Sprite = new Sprite();
		private var _legendMode:String;
		private var _legendWidth:Number;
		private var _legendHeight:Number;
		
		[Embed(source="../../../../../../resources/legend_button.png")]
		private var SlideButtonClass:Class;
		private var slideImage:Bitmap;
		private var _chartRef:IChart;
		/**
		 * 控制图例显示的按钮
		 */		
		protected var slideButton:Sprite = new Sprite();
		/**
		 * 当前状态，open or close
		 */		
		protected var currentState:String;
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */	
		public function get chartRef():IChart {return _chartRef;}
		public function set chartRef(value:IChart):void {_chartRef=value;}
		/**
		 * 图表说明宽度
		 * @return 
		 * 
		 */	
		override public function get width():Number{return _legendWidth;}
		override public function set width(value:Number):void{_legendWidth = value;}
		/**
		 * 图表说明高度
		 * @return 
		 * 
		 */	
		override public function get height():Number{return _legendHeight;}
		override public function set height(value:Number):void{_legendHeight = value;}
		/**
		 * 图表说明的类型
		 * @return 
		 * 
		 */	
		public function get legendMode():String{return _legendMode;}
		public function set legendMode(value:String):void{_legendMode = value;}
		/**
		 * CSS样式定义
		 * @return 对象
		 * 
		 */
		public function get style():Object{return _style;}
		public function set style(value:Object):void{_style = value;}
		/**
		 * 对数据源的引用
		 * @return DatasetVO引用
		 * 
		 */
		public function get dataset():DatasetVO{return _dataset;}
		public function set dataset(value:DatasetVO):void{
			_dataset = value;
			createLabel();
			updateDisplayList(_legendWidth,_legendHeight);
		}
		/**
		 * 构造方法
		 * 
		 */		
		public function SlideLegend(chartRef:IChart,legendModeStr:String,w:int,h:int)
		{
			_chartRef = chartRef;
			_legendMode = legendModeStr;
			_legendWidth = w;
			_legendHeight = h;
			slideImage = new SlideButtonClass();
			slideButton.buttonMode = true;
			slideButton.addChild(slideImage);
			addChild(slideButton);
			slideButton.addEventListener(MouseEvent.MOUSE_DOWN,slideButtonHandler);
			addChild(labelContainer);
		}
		/**
		 * 创建标签
		 * 
		 */		
		public function createLabel():void
		{
			var yFiledArr:Array = dataset.config["yField"].split(",");
			var benchmarkArr:Array;
			if(dataset.config["benchmark"] != null) benchmarkArr = dataset.config["benchmark"].split(",");
			var label:GraphicLabel,checkBox:CheckBox;;
			for(var i:uint=0;i<yFiledArr.length;i++) {
				//container
				var legendItem:LegendItem = new LegendItem(width);
				legendItem.y = i*legendItem.height;
				legendItem.addEventListener(MouseEvent.CLICK,refrishChart);
				labelContainer.addChild(legendItem);
				//label
				if(benchmarkArr != null && benchmarkArr.indexOf(yFiledArr[i]) > -1) {
					label = new GraphicLabel(false,style["benchmarkColor"],"line");
				} else {
					label = new GraphicLabel(false,ChartGlobal.colorCollection[i],legendMode);
				}
				label.color = style["color"];
				label.x = 30;
				label.y = 5;
				label.text = yFiledArr[i];
				legendItem.addChild(label);
				//check box
				checkBox = new CheckBox();
				checkBox.x = 10;
				checkBox.y = 5;
				checkBox.name = yFiledArr[i];
				checkBox.selected = true;
				legendItem.addChild(checkBox);
			}
		}
		/**
		 * 点击按钮后触发的方法
		 * @param e
		 * 
		 */		
		protected function slideButtonHandler(e:MouseEvent):void {
			currentState = (currentState == "close")?"open":"close";
			if(currentState == "open") {
				x -= width;
				chartRef.width -= width;
			} else {
				x += width;
				chartRef.width += width;
			}
		}
		/**
		 * 刷新图表
		 * @param e
		 * 
		 */		
		protected function refrishChart(e:MouseEvent):void {
			var currentCheckbox:CheckBox = (e.target.getChildAt(1)) as CheckBox;
			currentCheckbox.selected = !currentCheckbox.selected;
			var currentYField:String = currentCheckbox.name;
			displayGraphics(currentCheckbox.selected,currentYField);
		}
		/**
		 * 控制去显示某个图形
		 * @param show 显示还是隐藏
		 * @param yField y轴字段
		 * 
		 */		
		protected function displayGraphics(show:Boolean,yField:String):void {
			var seriesArr:Array = chartRef.chartGraphicContainer.seriesCollection;
			var seriesMode:Object = chartRef.chartGraphicContainer.seriesMode;
			for each(var item:Sprite in seriesArr) {
				if(item.name == yField) {
					if(show) {
						seriesMode[item.name] = null;
						chartRef.chartGraphicContainer.showSeries(item.name,true);
					} else {
						seriesMode[item.name] = false;
						chartRef.chartGraphicContainer.hideSeries(item.name,true);
					}
				}
			}
		}
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘图表
		 * @param width 宽度
		 * @param height 高度
		 */
		public function updateDisplayList(w:uint, h:uint):void
		{
			//button
			currentState = "close";
			slideButton.x = -slideImage.width;
			slideButton.graphics.clear();
			slideButton.graphics.beginFill(0x000000,0);
			slideButton.graphics.drawRect(-10,0,slideButton.width+10,h);
			slideButton.graphics.endFill();
			slideImage.y = (h-slideImage.height)/2;
			//bg
			graphics.clear();
			graphics.beginFill(_style["bgColor"],_style["bgAlpha"]);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
	}
}
import flash.display.GradientType;
import flash.display.Sprite;
import flash.geom.Matrix;

class LegendItem extends Sprite {
	
	private var itemWidth:int;
	
	public function LegendItem(w:int) {
		itemWidth = w;
		this.graphics.beginFill(0x000000,0.2);
		this.graphics.drawRect(0,0,w,30);
		this.graphics.endFill();
		this.graphics.lineStyle(1,0x000000,0.3);
		this.graphics.moveTo(0,30);
		this.graphics.lineTo(w,30);
		mouseChildren = false;
		buttonMode = true;
	}
}
