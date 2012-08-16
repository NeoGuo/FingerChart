package com.riameeting.finger.component
{
	import com.riameeting.finger.component.LineChart;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.legend.ILegend;
	import com.riameeting.finger.display.legend.SelectableLegend;
	import com.riameeting.finger.display.legend.SimpleLegend;
	import com.riameeting.finger.vo.DatasetVO;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/**
	 * 图表包装类，用于将图表，图例说明，外部配置整合
	 * @author Finger
	 * 
	 */	
	public class ChartWrapper extends Sprite
	{
		/**
		 * 图表组件
		 */		
		protected var chart:IChart;
		/**
		 * 图例说明
		 */		
		protected var legend:ILegend;
		/**
		 * 图表所需的配置，引用请使用ChartGlobal.chartConfig
		 */		
		protected var chartConfig:Object;
		private var preloader:Preloader = new Preloader();
		/**
		 * 构造方法
		 * 
		 */	
		public function ChartWrapper()
		{
			super();
			if(stage != null) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.showDefaultContextMenu = false;
			}
			addEventListener(Event.ENTER_FRAME,checkStage);
			chartConfig = loaderInfo.parameters;
		}
		/**
		 * 检查Stage是否为空，当不为空时执行初始化方法
		 * @param e 事件
		 * 
		 */		
		protected function checkStage(e:Event):void {
			if(stage!=null && stage.stageWidth != 0) {
				init();
				//removelistener
				removeEventListener(Event.ENTER_FRAME,checkStage);
			}
		}
		/**
		 * 初始化方法，将创建图表，并加载外部文件
		 * @param e
		 * 
		 */		
		protected function init(e:Event=null):void {
			stage.addEventListener(Event.RESIZE,resizeHandler);
			chart.chartConfig = chartConfig;
			chart.loadAssets();
			(chart as DisplayObjectContainer).addEventListener(Event.COMPLETE,hideProloader);
			addChild(chart as DisplayObject);
			//legend
			if(chartConfig["legend"] != null) {
				addChild(legend as DisplayObject);
				legend.x = chart.width;
				chart.bindLegend(legend);
			}
			addChild(preloader);
			preloader.x = stage.stageWidth/2;
			preloader.y = stage.stageHeight/2;
			//receivedFromJavaScript
			if(ExternalInterface.available) {
				ExternalInterface.addCallback("addData",addDataFromJavaScript);
			}
		}
		/**
		 * 从JavaScript加入数据
		 * @param data
		 * @param policy
		 * 
		 */		
		protected function addDataFromJavaScript(data:Object,policy:String):void {
			chart.addData(data,policy);
		}
		/**
		 * 隐藏进度条
		 * @param e
		 * 
		 */		
		protected function hideProloader(e:Event):void {
			removeChild(preloader);
		}
		/**
		 * Flash尺寸发生改变触发的回调方法，将重绘图表的显示元素。
		 * @param e 事件
		 * 
		 */		
		protected function resizeHandler(e:Event):void 
		{
			chart.width = stage.stageWidth;
			chart.height = stage.stageHeight;
			legend.x = chart.width;
			legend.updateDisplayList(legend.width,chart.height);
		}
	}
}
import com.riameeting.ui.control.Label;

import flash.display.Sprite;

class Preloader extends Sprite {
	public function Preloader() {
		var label:Label = new Label();
		label.color = 0xFFFFFF;
		label.text = "加载中";
		label.x = -label.width/2;
		label.y = -label.height/2;
		addChild(label);
		this.graphics.beginFill(0xCCCCCC,1);
		this.graphics.drawCircle(0,0,label.width/2+4);
		this.graphics.endFill();
	}
}