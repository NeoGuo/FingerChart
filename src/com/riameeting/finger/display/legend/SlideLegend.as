package com.riameeting.finger.display.legend
{
	import com.adobe.lighthouse.controls.DraggableVerticalContainer;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.ui.control.CheckBox;
	import com.riameeting.ui.control.GraphicLabel;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.charts.LegendItem;

	/**
	 * 专用于移动设备的图例说明
	 * @author Finger
	 *
	 */
	public class SlideLegend extends Sprite implements ILegend
	{
		private var _dataset:DatasetVO;
		private var _style:Object={color: 0xFFFFFF, paddingTop: 0, paddingLeft: 0, benchmarkColor: 0xCCCCCC, bgColor: 0x000000, bgAlpha: 80};
		/**
		 * 标签容器
		 */
		protected var labelContainer:Sprite=new Sprite();
		protected var draggableContainer:DraggableVerticalContainer;
		private var _legendMode:String;

		[Embed(source="legend_button.png")]
		private var SlideButtonClass:Class;
		[Embed(source="close.png")]
		private var CloseButtonClass:Class;
		private var slideImage:Bitmap;
		private var closeImage:Bitmap;
		private var _chartRef:IChart;
		/**
		 * 控制图例显示的按钮
		 */
		protected var slideButton:Sprite=new Sprite();
		/**
		 * 控制图例关闭的按钮
		 */
		protected var closeButton:Sprite=new Sprite();
		/**
		 * 当前状态，open or close
		 */
		protected var currentState:String;

		/**
		 * 对Chart的 引用
		 * @return
		 *
		 */
		public function get chartRef():IChart
		{
			return _chartRef;
		}

		public function set chartRef(value:IChart):void
		{
			_chartRef=value;
		}

		/**
		 * 图表说明宽度
		 * @return
		 *
		 */
		override public function get width():Number
		{
			return 0;
		}

		override public function set width(value:Number):void
		{
			//
		}

		/**
		 * 图表说明高度
		 * @return
		 *
		 */
		override public function get height():Number
		{
			return 0;
		}

		override public function set height(value:Number):void
		{
			
		}

		/**
		 * 图表说明的类型
		 * @return
		 *
		 */
		public function get legendMode():String
		{
			return _legendMode;
		}

		public function set legendMode(value:String):void
		{
			_legendMode=value;
		}

		/**
		 * CSS样式定义
		 * @return 对象
		 *
		 */
		public function get style():Object
		{
			return _style;
		}

		public function set style(value:Object):void
		{
			_style=value;
		}

		/**
		 * 对数据源的引用
		 * @return DatasetVO引用
		 *
		 */
		public function get dataset():DatasetVO
		{
			return _dataset;
		}

		public function set dataset(value:DatasetVO):void
		{
			_dataset=value;
			createLabel();
			updateDisplayList(_chartRef.width, _chartRef.height);
		}

		/**
		 * 构造方法
		 *
		 */
		public function SlideLegend(chartRef:IChart, legendModeStr:String, w:int, h:int)
		{
			_chartRef=chartRef;
			_legendMode=legendModeStr;
			slideImage=new SlideButtonClass();
			slideButton.buttonMode=true;
			slideButton.addChild(slideImage);
			addChild(slideButton);
			closeImage=new CloseButtonClass();
			closeButton.graphics.beginFill(0xFF0000,0);
			closeButton.graphics.drawCircle(15,15,30);
			closeButton.graphics.endFill();
			closeButton.buttonMode=true;
			closeButton.addChild(closeImage);
			slideButton.addEventListener(MouseEvent.MOUSE_DOWN, slideButtonHandler);
			closeButton.addEventListener(MouseEvent.MOUSE_DOWN,closeButtonHandler);
			//
			draggableContainer = new DraggableVerticalContainer(0,0x333333,false,0,0,0,0);
			draggableContainer.addChild(labelContainer);
		}

		/**
		 * 创建标签
		 *
		 */
		public function createLabel():void
		{
			var yFiledArr:Array=dataset.config["yField"].split(",");
			var benchmarkArr:Array;
			if (dataset.config["benchmark"] != null)
				benchmarkArr=dataset.config["benchmark"].split(",");
			var label:GraphicLabel, checkBox:CheckBox;
			for (var i:uint=0; i < yFiledArr.length; i++)
			{
				//container
				var legendItem:LegendItem=new LegendItem(100,64);
				legendItem.y=i * legendItem.height;
				legendItem.addEventListener(MouseEvent.CLICK, refrishChart);
				labelContainer.addChild(legendItem);
				//label
				if (benchmarkArr != null && benchmarkArr.indexOf(yFiledArr[i]) > -1)
				{
					label=new GraphicLabel(false, style["benchmarkColor"], "line");
				}
				else
				{
					label=new GraphicLabel(false, ChartGlobal.colorCollection[i], legendMode);
				}
				label.color=style["color"];
				label.x=50;
				label.y=24;
				label.text=yFiledArr[i];
				legendItem.addChild(label);
				//check box
				checkBox=new CheckBox();
				checkBox.x=10;
				checkBox.y=24;
				checkBox.name=yFiledArr[i];
				checkBox.selected=true;
				legendItem.addChild(checkBox);
			}
		}

		/**
		 * 点击按钮后触发的方法
		 * @param e
		 *
		 */
		protected function slideButtonHandler(e:MouseEvent):void
		{
			currentState = "open";
			_chartRef.addChild(draggableContainer);
			updateDisplayList(_chartRef.width, _chartRef.height);
		}
		
		/**
		 * 点击关闭按钮后触发的方法
		 * @param e
		 *
		 */
		protected function closeButtonHandler(e:MouseEvent):void
		{
			currentState = "close";
			_chartRef.removeChild(draggableContainer);
			_chartRef.removeChild(closeButton);
			updateDisplayList(_chartRef.width, _chartRef.height);
		}

		/**
		 * 刷新图表
		 * @param e
		 *
		 */
		protected function refrishChart(e:MouseEvent):void
		{
			var currentCheckbox:CheckBox=(e.target.getChildAt(1)) as CheckBox;
			currentCheckbox.selected=!currentCheckbox.selected;
			var currentYField:String=currentCheckbox.name;
			displayGraphics(currentCheckbox.selected, currentYField);
		}

		/**
		 * 控制去显示某个图形
		 * @param show 显示还是隐藏
		 * @param yField y轴字段
		 *
		 */
		protected function displayGraphics(show:Boolean, yField:String):void
		{
			var seriesArr:Array=chartRef.chartGraphicContainer.seriesCollection;
			var seriesMode:Object=chartRef.chartGraphicContainer.seriesMode;
			for each (var item:Sprite in seriesArr)
			{
				if (item.name == yField)
				{
					if (show)
					{
						seriesMode[item.name]=null;
						chartRef.chartGraphicContainer.showSeries(item.name, true);
					}
					else
					{
						seriesMode[item.name]=false;
						chartRef.chartGraphicContainer.hideSeries(item.name, true);
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
			var pupedWidth:Number = w - 40;
			var pupedHeight:Number = h - 40;
			if(currentState == "open")
			{
				labelContainer.graphics.clear();
				labelContainer.graphics.beginFill(0x000000,0);
				labelContainer.graphics.drawRect(0,0,pupedWidth,pupedHeight+1);
				labelContainer.graphics.endFill();
				draggableContainer.x = 20;
				draggableContainer.y = 20;
				draggableContainer.width = pupedWidth;
				draggableContainer.height = pupedHeight;
				draggableContainer.refreshView(false);
				for (var i:int = 0; i < labelContainer.numChildren; i++) 
				{
					var legendItem:LegendItem = labelContainer.getChildAt(i) as LegendItem;
					legendItem.width = pupedWidth;
				}
				_chartRef.addChild(closeButton);
				closeButton.x = w - 60;
				closeButton.y = 30;
			}
			slideButton.x=-slideImage.width;
			slideButton.graphics.clear();
			slideButton.graphics.beginFill(0x000000, 0);
			slideButton.graphics.drawRect(-10, 0, slideButton.width + 10, h);
			slideButton.graphics.endFill();
			slideImage.y=(h - slideImage.height) / 2;
		}
	}
}
import flash.display.GradientType;
import flash.display.Sprite;
import flash.geom.Matrix;

class LegendItem extends Sprite
{
	private var __width:Number = 0;
	private var __height:Number = 0;
	
	override public function get width():Number
	{
		return __width;
	}
	
	override public function set width(value:Number):void
	{
		__width = value;
		updateDisplayList(__width,__height);
	}
	
	override public function get height():Number
	{
		return __height;
	}
	
	override public function set height(value:Number):void
	{
		__height = value;
		updateDisplayList(__width,__height);
	}

	public function LegendItem(w:int,h:int)
	{
		__width = w;
		__height = h;
		updateDisplayList(w,h);
	}
	
	private function updateDisplayList(w:int,h:int):void
	{
		if(w == 0 || h == 0)
			return;
		this.graphics.clear();
		this.graphics.beginFill(0x000000, 1);
		this.graphics.drawRect(0, 0, w, h);
		this.graphics.endFill();
		this.graphics.lineStyle(2, 0xFFFFFF, 0.2);
		this.graphics.moveTo(0, h);
		this.graphics.lineTo(w, h);
		mouseChildren=false;
		buttonMode=true;
	}
	
}
