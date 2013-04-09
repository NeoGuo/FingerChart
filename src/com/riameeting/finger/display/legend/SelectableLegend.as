package com.riameeting.finger.display.legend
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.ui.control.CheckBox;
	import com.riameeting.finger.display.graphic.IChartGraphic;
	/**
	 * 可选择的图表说明类
	 * @author Finger
	 * 
	 */
	public class SelectableLegend extends SimpleLegend
	{
		/**
		 * 用于显示复选框的容器
		 */	
		protected var checkboxContainer:Sprite = new Sprite();
		/**
		 * 构造方法
		 * @param legendMode 模式
		 * @param legendWidth 宽度
		 * @param legendHeight 高度
		 * 
		 */		
		public function SelectableLegend(chartRef:IChart,legendMode:String,legendWidth:Number,legendHeight:Number)
		{
			super(chartRef,legendMode,legendWidth,legendHeight);
			addChild(checkboxContainer);
		}
		/**
		 * 重写创建标签的方法
		 * 
		 */	
		override public function createLabel():void
		{
			super.createLabel();
			labelContainer.x += 20;
			var yFiledArr:Array = dataset.config["yField"].split(",");
			var checkBox:CheckBox;
			for(var i:uint=0;i<yFiledArr.length;i++) {
				checkBox = new CheckBox();
				checkBox.y = i * 20;
				checkBox.name = yFiledArr[i];
				checkBox.selected = true;
				checkBox.addEventListener(MouseEvent.CLICK,refrishChart);
				checkboxContainer.addChild(checkBox);
			}
			checkboxContainer.x = style["paddingLeft"];
			checkboxContainer.y = style["paddingTop"];
		}
		/**
		 * 刷新图表
		 * @param e
		 * 
		 */		
		protected function refrishChart(e:MouseEvent):void {
			var currentCheckbox:CheckBox = e.target as CheckBox;
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
			for each(var item:Sprite in seriesArr) {
				if(item.name == yField) {
					if(show) {
						chartRef.chartGraphicContainer.showSeries(item.name);
					} else {
						chartRef.chartGraphicContainer.hideSeries(item.name);
					}
				}
			}
		}
		
	}
}