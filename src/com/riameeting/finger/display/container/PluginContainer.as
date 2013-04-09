package com.riameeting.finger.display.container
{
	import com.adobe.images.PNGEncoder;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.plugin.IChartPlugin;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.ui.control.Alert;
	import com.riameeting.utils.ObjectUtils;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * 插件容器类
	 * @author Finger
	 *
	 */
	public class PluginContainer extends Sprite implements IPluginContainer
	{
		private var _dataset:DatasetVO;
		private var _style:Object;
		private var _pluginCollection:Array = [];
		private var _chartRef:IChart;
		
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
			_chartRef = value;
		}
		
		/**
		 * 插件数组，即允许同时加载多个插件
		 * @return
		 *
		 */
		public function get pluginCollection():Array
		{
			return _pluginCollection;
		}
		
		public function set pluginCollection(value:Array):void
		{
			_pluginCollection = value;
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
			_style = value;
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
			//clear();
			_dataset = value;
			if (pluginCollection.length == 0)
			{
				var pluginStr:String = chartRef.chartConfig["plugin"];
				if (pluginStr != null)
				{
					for each (var url:String in pluginStr.split(","))
					{
						var loader:Loader = new Loader();
						loader.load(new URLRequest(url));
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
						addChild(loader);
						//addChildAt(loader, 0);
					}
				}
			}
			else
			{
				for each(var plugin:IChartPlugin in pluginCollection)
				{
					plugin.initPlugin(this);
				}
			}
		}
		
		/**
		 * 构造方法
		 * @param pluginStr 插件地址
		 *
		 */
		public function PluginContainer(chartRef:IChart)
		{
			_chartRef = chartRef;
			//PNGEncoder;
		}
		
		/**
		 * 插件加载完毕执行的回调方法
		 * @param e 事件
		 *
		 */
		protected function completeHandler(e:Event):void
		{
			var plugin:IChartPlugin = e.currentTarget.content as IChartPlugin;
			plugin.initPlugin(this);
			pluginCollection.push(plugin);
		}
		
		/**
		 * 插件加载错误触发的回调方法
		 * @param e IO错误
		 *
		 */
		protected function errorHandler(e:IOErrorEvent):void
		{
			Alert.show(e.toString(), "Error");
		}
		
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘图表
		 * @param width 宽度
		 * @param height 高度
		 */
		public function updateDisplayList(w:uint, h:uint):void
		{
			if (pluginCollection == null)
				return;
			for each (var plugin:IChartPlugin in pluginCollection)
			{
				plugin.updateDisplayList(w, h);
			}
		}
		
		/**
		 * 执行清理动作
		 *
		 */
		public function clear():void
		{
			ObjectUtils.removeAllChildren(this);
			pluginCollection = [];
		}
	}
}