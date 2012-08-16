package com.riameeting.finger.display.legend
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.ui.control.GraphicLabel;
	
	import flash.display.Sprite;

	/**
	 * 最基本的图表说明类
	 * @author Finger
	 * 
	 */	
	public class SimpleLegend extends Sprite implements ILegend
	{
		private var _dataset:DatasetVO;
		private var _style:Object = {color:0xFFFFFF,paddingTop:0,paddingLeft:0,benchmarkColor:0xCCCCCC,bgColor:0x666666,bgAlpha:100};
		private var _chartRef:IChart;
		/**
		 * 标签容器
		 */		
		protected var labelContainer:Sprite = new Sprite();
		private var _legendMode:String;
		private var _legendWidth:Number;
		private var _legendHeight:Number;
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
		 * @param legendMode 模式
		 * @param legendWidth 宽度
		 * @param legendHeight 高度
		 * 
		 */
		public function SimpleLegend(chartRef:IChart,legendMode:String,legendWidth:Number,legendHeight:Number)
		{
			_chartRef = chartRef;
			_legendMode = legendMode;
			_legendWidth = legendWidth;
			_legendHeight = legendHeight;
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
			var label:GraphicLabel;
			for(var i:uint=0;i<yFiledArr.length;i++) {
				if(benchmarkArr != null && benchmarkArr.indexOf(yFiledArr[i]) > -1) {
					label = new GraphicLabel(false,style["benchmarkColor"],"line");
				} else {
					label = new GraphicLabel(false,ChartGlobal.colorCollection[i],legendMode);
				}
				label.color = style["color"];
				label.y = i*label.height;
				label.text = yFiledArr[i];
				labelContainer.addChild(label);
			}
			labelContainer.x = style["paddingLeft"];
			labelContainer.y = style["paddingTop"];
		}
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘图表
		 * @param width 宽度
		 * @param height 高度
		 */
		public function updateDisplayList(w:uint,h:uint):void {
			graphics.clear();
			if(style != null && style["bgColor"] != null) {
				graphics.lineStyle(1,0x000000,0.3);
				graphics.beginFill(style["bgColor"],style["bgAlpha"]/100);
				graphics.drawRect(0,0,w,h);
				graphics.endFill();
			}
		}
		
	}
}