package com.riameeting.finger.display.container
{
	import com.greensock.TweenLite;
	import com.riameeting.controler.EventBus;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.graphic.IChartGraphic;
	import com.riameeting.finger.display.tooltip.ITooltip;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.utils.NumberTool;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 鼠标提示容器类
	 * @author NeoGuo
	 * 
	 */	
	public class TooltipContainer extends Sprite implements ITooltipContainer
	{
		private var _dataset:DatasetVO;
		private var _tooltipClass:Class;
		
		private var tooltip:ITooltip;
		private var axisRect:Rectangle;
		private var graphicsCollection:Array;
		private var _style:Object = {color:0x000000,tipbgColor:0xFFFFFF,tipbgAlpha:100,borderWidth:3,borderColor:0x000000,borderAlpha:20};
		private var _chartRef:IChart;
		/**
		 * 监测规则
		 */		
		protected var checkType:String;
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */	
		public function get chartRef():IChart {return _chartRef;}
		public function set chartRef(value:IChart):void {_chartRef=value;}
		/**
		 * CSS样式定义
		 * @return 对象
		 * 
		 */
		public function get style():Object{return _style;}
		public function set style(value:Object):void{_style = value;}
		/**
		 * 鼠标提示类
		 * @return 类
		 * 
		 */
		public function get tooltipClass():Class{return _tooltipClass;}
		public function set tooltipClass(value:Class):void{_tooltipClass = value;}
		/**
		 * 对数据源的引用
		 * @return DatasetVO引用
		 * 
		 */
		public function get dataset():DatasetVO{return _dataset;}
		public function set dataset(value:DatasetVO):void
		{
			_dataset = value;
			tooltip.style = style;
			tooltip.skin = ChartGlobal.getSkin("skin.TooltipSkin");
			(chartRef as DisplayObjectContainer).addEventListener(MouseEvent.MOUSE_MOVE,containerMouseHandler);
			if(stage!=null) stage.addEventListener(Event.MOUSE_LEAVE,function(e:Event):void {clear()});
		}
		/**
		 * 构造方法
		 * @param tooltipClass 鼠标提示类
		 * @param unity 是否组合提示字符串
		 * @param checkType 可选byx或byy
		 */		
		public function TooltipContainer(chartRef:IChart,tooltipClass:Class,checkType:String = "byx")
		{
			_chartRef = chartRef;
			_tooltipClass = tooltipClass;
			this.checkType = checkType;
			tooltip = new tooltipClass() as ITooltip;
			addChild(tooltip as DisplayObject);
			tooltip.hide();
			mouseChildren = false;
			mouseEnabled = false;
		}
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘图表
		 * @param width 宽度
		 * @param height 高度
		 */
		public function updateDisplayList(width:uint,height:uint):void {
			axisRect = chartRef.axis.getAxisRect();
			graphicsCollection = chartRef.chartGraphicContainer.graphicsCollection;
		}
		/**
		 * 容器鼠标事件的回调方法
		 * @param e 鼠标事件
		 * 
		 */		
		protected function containerMouseHandler(e:MouseEvent):void {
			if(mouseX < axisRect.x || mouseX > (axisRect.x+axisRect.width) || mouseY < axisRect.y || mouseY > (axisRect.y+axisRect.height)) {
				tooltip.hide();
				clear();
				return;
			}
			clear();
			if(checkType == "byp") {
				checkValueByPoint();
				return;
			}
			var i:uint=0,hindex:int = 0;
			var seriel:Sprite = chartRef.chartGraphicContainer.seriesCollection[0];
			var nearlyGraphic:IChartGraphic = seriel.getChildAt(0) as IChartGraphic;
			var nextGraphic:IChartGraphic,mousePoint:Point = new Point(),targetPoint:Point = new Point(),prevPoint:Point = new Point();
			prevPoint.x = nearlyGraphic.x + nearlyGraphic.center.x;
			prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
			mousePoint.x = mouseX;
			mousePoint.y = mouseY;
			for(i=0;i<seriel.numChildren;i++) {
				nextGraphic = seriel.getChildAt(i) as IChartGraphic;
				targetPoint.x = nextGraphic.x + nextGraphic.center.x;
				targetPoint.y = nextGraphic.y + nextGraphic.center.y;
				if(checkType == "byx") {
					if(Math.abs(mousePoint.x - targetPoint.x) < Math.abs(mousePoint.x - prevPoint.x)) {
						nearlyGraphic = nextGraphic;
						prevPoint.x = nearlyGraphic.x + nearlyGraphic.center.x;
						prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
						hindex = i;
					}
				} else if(checkType == "byy") {
					if(Math.abs(mousePoint.y - targetPoint.y) < Math.abs(mousePoint.y - prevPoint.y)) {
						nearlyGraphic = nextGraphic;
						prevPoint.x = nearlyGraphic.x + nearlyGraphic.center.x;
						prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
						hindex = i;
					}
				}
			}
			for(i=0;i<chartRef.chartGraphicContainer.seriesCollection.length;i++) {
				nextGraphic = chartRef.chartGraphicContainer.seriesCollection[i].getChildByName(nearlyGraphic.name) as IChartGraphic;
				targetPoint.x = nextGraphic.x + nextGraphic.center.x;
				targetPoint.y = nextGraphic.y + nextGraphic.center.y;
				if(checkType == "byx") {
					if(Math.abs(mousePoint.y - targetPoint.y) < Math.abs(mousePoint.y - prevPoint.y)) {
						nearlyGraphic = nextGraphic;
						prevPoint.x = nearlyGraphic.x + nearlyGraphic.center.x;
						prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
					}
				} else if(checkType == "byy") {
					if(Math.abs(mousePoint.x - targetPoint.x) < Math.abs(mousePoint.x - prevPoint.x)) {
						nearlyGraphic = nextGraphic;
						prevPoint.x = nearlyGraphic.x + nearlyGraphic.center.x;
						prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
					}
				}
			}
			nearlyGraphic.state = MouseEvent.MOUSE_OVER;
			seriel = (nearlyGraphic as DisplayObject).parent as Sprite;
			seriel.swapChildren(nearlyGraphic as DisplayObject,seriel.getChildAt(seriel.numChildren-1));
			var tipStr:String = nearlyGraphic.data.tipString[nearlyGraphic.yField];
			tooltip.show(tipStr);
			locateTooltip(nearlyGraphic.x + nearlyGraphic.center.x,nearlyGraphic.y + nearlyGraphic.center.y);
		}
		/**
		 * 如果设置类型是byp，则调用此方法监测坐标
		 * 
		 */		
		protected function checkValueByPoint():void {
			var nearlyGraphic:IChartGraphic = graphicsCollection[0];
			var nextGraphic:IChartGraphic,mousePoint:Point = new Point(),targetPoint:Point = new Point(),prevPoint:Point = new Point();
			prevPoint.x = nearlyGraphic.x + nearlyGraphic.center.x;
			prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
			for each(nextGraphic in graphicsCollection) {
				nextGraphic.state = MouseEvent.MOUSE_OUT;
				mousePoint.x = mouseX;
				mousePoint.y = mouseY;
				targetPoint.x = nextGraphic.x + nextGraphic.center.x;
				targetPoint.y = nextGraphic.y + nextGraphic.center.y;
				if(NumberTool.getPointDistance(mousePoint,targetPoint)  < NumberTool.getPointDistance(mousePoint,prevPoint)) {
					nearlyGraphic = nextGraphic;
					prevPoint.x = nearlyGraphic.x + nearlyGraphic.center.x;
					prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
				}
			}
			nearlyGraphic.state = MouseEvent.MOUSE_OVER;
			var seriel:Sprite = (nearlyGraphic as DisplayObject).parent as Sprite;
			seriel.swapChildren(nearlyGraphic as DisplayObject,seriel.getChildAt(seriel.numChildren-1));
			var tipStr:String = nearlyGraphic.data.tipString[nearlyGraphic.yField];
			tooltip.show(tipStr);
			locateTooltip(nearlyGraphic.x + nearlyGraphic.center.x,nearlyGraphic.y + nearlyGraphic.center.y);
		}
		/**
		 * 将鼠标提示定位到相应的位置
		 * @param xValue x值
		 * @param yValue y值
		 * 
		 */		
		protected function locateTooltip(xValue:Number,yValue:Number):void {
			if(tooltip.x == 0 && tooltip.y == 0) {
				tooltip.x = xValue;
				tooltip.y = yValue;
			}
			var targetX:Number = xValue;
			var targetY:Number = yValue;
			if(targetX + tooltip.width > axisRect.x + axisRect.width) {
				targetX = xValue - tooltip.width - 20;
			}
			if(targetY + tooltip.height > axisRect.y + axisRect.height) {
				targetY = axisRect.y + axisRect.height - tooltip.height;
			}
			TweenLite.to(tooltip,0.2,{x:targetX,y:targetY});
		}
		/**
		 * 执行清理动作
		 * 
		 */
		public function clear():void {
			tooltip.hide();
			graphics.clear();
			var nextGraphic:IChartGraphic;
			for each(nextGraphic in graphicsCollection) {
				nextGraphic.state = MouseEvent.MOUSE_OUT;
			}
		}
		
	}
}