package com.riameeting.finger.display.chart
{
	import com.adobe.images.PNGEncoder;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.legend.ILegend;
	import com.riameeting.finger.effect.IEffect;
	import com.riameeting.finger.parser.CSSParser;
	import com.riameeting.finger.parser.IParser;
	import com.riameeting.finger.parser.JSONParser;
	import com.riameeting.finger.parser.XMLParser;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.net.ResourceLoader;
	import com.riameeting.ui.control.Alert;
	import com.riameeting.utils.ArrayUtils;
	import com.riameeting.utils.NumberTool;
	import com.riameeting.utils.ObjectUtils;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.*;

	/**
	 * 抽象图表。此类并不确定图表的类型（线状图，柱状图或其它），依据它的依赖而定。
	 * @author Finger
	 *
	 */
	public class AbstractChart extends Sprite implements IChart
	{
		//4 layer
		private var _axis:IAxis;
		private var _chartGraphicContainer:IChartGraphicContainer;
		private var _tooltipContainer:ITooltipContainer;
		private var _pluginContainer:IPluginContainer;
		private var _chartConfig:Object;
		//model
		private var _dataset:DatasetVO;
		private var _legend:ILegend;
		//effect
		private var _showEffect:IEffect;
		private var _hideEffect:IEffect;
		private var _graphicShowEffect:IEffect;
		private var _graphicHideEffect:IEffect;
		private var _tipShowEffect:IEffect;
		private var _tipHideEffect:IEffect;
		private var globalStyle:Object;
		private var myContextMenu:ContextMenu;
		/**
		 * 图表宽度
		 */
		protected var chartWidth:uint;
		/**
		 * 图表高度
		 */
		protected var chartHeight:uint;
		/**
		 * 资源加载器
		 */
		protected var resourceLoader:ResourceLoader=new ResourceLoader();
		//style
		private var _style:Object={bgColors: [0xFFFFFF, 0xEFEFEF], bgAlphas: [100, 100]};
		private var _skin:MovieClip;
		private var _dataRange:Array;

		/**
		 * 图表的配置
		 * @return
		 *
		 */
		public function get chartConfig():Object
		{
			return _chartConfig;
		}

		public function set chartConfig(value:Object):void
		{
			_chartConfig=value;
		}

		/**
		 * CSS样式定义
		 * @return 对象
		 * @default {bgColors:[0xFFFFFF,0xc8c8c8],bgAlphas:[100,100],lineColors:[0x000000,0x000000],lineAlphas:[0,20]}
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
		 * SKIN定义
		 * @return 对象
		 *
		 */
		public function get skin():MovieClip
		{
			return _skin;
		}

		public function set skin(value:MovieClip):void
		{
			if (_skin != null)
				removeChild(_skin);
			_skin=value;
			_skin.hostComponent=this;
			addChildAt(_skin, 0);
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
			if (value == null)
				throw new Error("dataset not allow null");
			if(_dataRange != null)
			{
				value.filterByRange(_dataRange);
			}
			_dataset=value;
			_axis.dataset=value;
			_chartGraphicContainer.dataset=value;
			_tooltipContainer.dataset=value;
			_pluginContainer.dataset=value;
			updateDisplayList();
		}

		/**
		 * 图表的4个显示层级之一：坐标系
		 * @return 坐标系
		 *
		 */
		public function get axis():IAxis
		{
			return _axis;
		}

		public function set axis(value:IAxis):void
		{
			_axis=value;
		}

		/**
		 * 图表的4个显示层级之一：图形容器
		 * @return 图形容器
		 *
		 */
		public function get chartGraphicContainer():IChartGraphicContainer
		{
			return _chartGraphicContainer;
		}

		public function set chartGraphicContainer(value:IChartGraphicContainer):void
		{
			_chartGraphicContainer=value;
		}

		/**
		 * 图表的4个显示层级之一：鼠标提示容器
		 * @return 鼠标提示容器
		 *
		 */
		public function get tooltipContainer():ITooltipContainer
		{
			return _tooltipContainer;
		}

		public function set tooltipContainer(value:ITooltipContainer):void
		{
			_tooltipContainer=value;
		}

		/**
		 * 图表的4个显示层级之一：插件容器
		 * @return 插件容器
		 *
		 */
		public function get pluginContainer():IPluginContainer
		{
			return _pluginContainer;
		}

		public function set pluginContainer(value:IPluginContainer):void
		{
			_pluginContainer=value;
		}

		public function get dataRange():Array
		{
			return _dataRange;
		}

		public function set dataRange(value:Array):void
		{
			if(value!=null && value.length!=2)
				throw new Error("dataRange must had 2 value");
			_dataRange=value;
			if(_dataset != null)
			{
				_dataset.filterByRange(_dataRange);
				updateDisplayList();
			}
		}
		/**
		 * CSS解析器
		 */
		protected var cssParser:CSSParser=new CSSParser();

		/**
		 * 构造方法
		 * @param axis 坐标系
		 * @param chartGraphicContainer 图形容器
		 * @param tooltipContainer 鼠标提示容器
		 * @param pluginContainer 插件容器
		 * @param width 宽度
		 * @param height 高度
		 *
		 */
		public function AbstractChart(axis:IAxis, chartGraphicContainer:IChartGraphicContainer, tooltipContainer:ITooltipContainer, pluginContainer:IPluginContainer, width:uint, height:uint)
		{
			this._axis=axis;
			this._chartGraphicContainer=chartGraphicContainer;
			this._tooltipContainer=tooltipContainer;
			this._pluginContainer=pluginContainer;
			this.chartWidth=width;
			this.chartHeight=height;
			addChild(axis as DisplayObject);
			addChild(chartGraphicContainer as DisplayObject);
			addChild(tooltipContainer as DisplayObject);
			addChild(pluginContainer as DisplayObject);
			if (Alert.container == null)
				Alert.container=this;
			//Multitouch mode
			Multitouch.inputMode=MultitouchInputMode.GESTURE;
		}

		/**
		 * 图表宽度
		 * @return 宽度值
		 *
		 */
		override public function get width():Number
		{
			return chartWidth;
		}

		override public function set width(value:Number):void
		{
			chartWidth=value;
			updateDisplayList();
		}

		/**
		 * 图表高度
		 * @return 高度值
		 *
		 */
		override public function get height():Number
		{
			return chartHeight;
		}

		override public function set height(value:Number):void
		{
			chartHeight=value;
			updateDisplayList();
		}

		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘图表
		 *
		 */
		public function updateDisplayList():void
		{
			if (dataset == null)
				return;
			_axis.updateDisplayList(width, height);
			_chartGraphicContainer.updateDisplayList(width, height);
			_tooltipContainer.updateDisplayList(width, height);
			_pluginContainer.updateDisplayList(width, height);
			skin.updateDisplayList({width: width, height: height});
		}

		/**
		 * 加载图表依赖的数据和资源
		 *
		 */
		public function loadAssets(chartConfigObj:Object=null):void
		{
			if (chartConfigObj != null)
				chartConfig=chartConfigObj;
			var assets:Array=[];
			if (chartConfig.data != null)
				assets.push(chartConfig.data);
			if (chartConfig.skin != null)
				assets.push(chartConfig.skin);
			if (chartConfig.css != null)
				assets.push(chartConfig.css);
			if (chartConfig.dataStr != null)
			{
				chartConfig.data="innerData";
				resourceLoader.fileDict[chartConfig.data]=chartConfig.dataStr;
			}
			if (chartConfig.cssStr != null)
			{
				chartConfig.css="innerCSS";
				resourceLoader.fileDict[chartConfig.css]=chartConfig.cssStr;
			}
			if (assets.length > 0)
			{
				resourceLoader.loadAssets(assets, loadAssetsCompleteHandler);
			}
			else
			{
				loadAssetsCompleteHandler();
			}
		}

		/**
		 * 加载完毕执行的方法
		 *
		 */
		protected function loadAssetsCompleteHandler():void
		{
			//css
			if (chartConfig.css != null)
			{
				cssParser.clear();
				cssParser.parseCSS(resourceLoader.fileDict[chartConfig.css]);
				if (cssParser.getStyle("chart") != null)
				{
					style=ObjectUtils.mergePromps(cssParser.getStyle("chart"), style);
				}
				if (cssParser.getStyle("axis") != null)
					axis.style=ObjectUtils.mergePromps(cssParser.getStyle("axis"), axis.style);
				;
				if (cssParser.getStyle("gContainer") != null)
					chartGraphicContainer.style=ObjectUtils.mergePromps(cssParser.getStyle("gContainer"), chartGraphicContainer.style);
				if (cssParser.getStyle("tContainer") != null)
					tooltipContainer.style=ObjectUtils.mergePromps(cssParser.getStyle("tContainer"), tooltipContainer.style);
				if (cssParser.getStyle("pContainer") != null)
					pluginContainer.style=ObjectUtils.mergePromps(cssParser.getStyle("pContainer"), pluginContainer.style);
				if (_legend != null && cssParser.getStyle("legend") != null)
					_legend.style=ObjectUtils.mergePromps(cssParser.getStyle("legend"), _legend.style);
				if (cssParser.getStyle("global") != null)
				{
					globalStyle=cssParser.getStyle("global");
					ChartGlobal.colorCollection=globalStyle["colorCollection"];
					ChartGlobal.colorCollection=ArrayUtils.extendArrayByClone(ChartGlobal.colorCollection, 10);
				}
			}
			//skin
			if (chartConfig.skin != null)
			{
				var skinLoader:Loader=new Loader();
				skinLoader.loadBytes(resourceLoader.fileDict[chartConfig.skin]);
				skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					drawChart(e);
				});
			}
			else
			{
				drawChart();
			}
		}

		/**
		 * 准备工作完成，将数据赋值给图表，让图表开始绘制
		 *
		 */
		protected function drawChart(e:Event=null):void
		{
			if (stage == null)
			{
				setTimeout(drawChart, 100, e);
				return;
			}
			dispatchEvent(new Event(Event.COMPLETE));
			if (e != null)
				ChartGlobal.skinSource=e.currentTarget.content;
			skin=ChartGlobal.getSkin("skin.ChartSkin");
			axis.skin=ChartGlobal.getSkin("skin.AxisSkin");
			//data
			var parser:IParser;
			var dataStr:String=resourceLoader.fileDict[chartConfig.data];
			if (dataStr.charAt(0) != "{")
			{
				parser=new XMLParser();
			}
			else
			{
				parser=new JSONParser();
			}
			dataset=parser.parse(dataStr);
			if (_legend != null)
				_legend.dataset=dataset;
			contextMenuHandler();
			(chartGraphicContainer as Object).useAnimation=false;
		}

		/**
		 * 绑定到图例说明
		 * @param legend
		 *
		 */
		public function bindLegend(legend:ILegend):void
		{
			_legend=legend;
		}

		/**
		 * 添加数据
		 * @param data
		 * @param policy 策略，可选：add, replace
		 *
		 */
		public function addData(data:Object, policy:String="add"):void
		{
			if (policy == "replace")
			{
				dataset.collection.shift();
			}
			dataset.collection.push(data);
			updateDisplayList();
		}
		
		/**
		 * 删除数据
		 * @param index 索引
		 *
		 */
		public function deleteDataAt(index:int):void
		{
			dataset.collection.splice(index,1);
			updateDisplayList();
		}

		/**
		 * 响应右键操作
		 *
		 */
		protected function contextMenuHandler():void
		{
			myContextMenu=new ContextMenu();
			if (myContextMenu.customItems == null)
				return;
			contextMenu=myContextMenu;
			myContextMenu.hideBuiltInItems();
			var versionMenu:ContextMenuItem=new ContextMenuItem("Finger Chart, version: " + ChartGlobal.version);
			versionMenu.enabled=false;
			myContextMenu.customItems.push(versionMenu);
			var fullscreenMenu:ContextMenuItem=new ContextMenuItem("Full Screen", true);
			fullscreenMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fullscreenHandler);
			myContextMenu.customItems.push(fullscreenMenu);
			var saveMenu:ContextMenuItem=new ContextMenuItem("Save as Bitmap", false);
			saveMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, saveHandler);
			myContextMenu.customItems.push(saveMenu);
			var helpMenu:ContextMenuItem=new ContextMenuItem("www.riadev.com/o/fingerchart", true);
			helpMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, getHelpLink);
			myContextMenu.customItems.push(helpMenu);
			var dateMenu:ContextMenuItem=new ContextMenuItem("Last Update:" + ChartGlobal.buildDate, true);
			dateMenu.enabled=false;
			myContextMenu.customItems.push(dateMenu);
			stage.doubleClickEnabled=true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, fullscreenHandler);
		}

		/**
		 * 全屏
		 * @param e
		 *
		 */
		private function fullscreenHandler(e:Event):void
		{
			stage.displayState=StageDisplayState.FULL_SCREEN;
		}

		/**
		 * 保存图片
		 * @param e
		 *
		 */
		private function saveHandler(e:ContextMenuEvent):void
		{
			var bmd:BitmapData=new BitmapData(stage.width, stage.height);
			bmd.draw(this);
			var bmdBytes:ByteArray=PNGEncoder.encode(bmd);
			var saveFile:FileReference=new FileReference();
			var dateStr:String="finger_";
			var date:Date=new Date();
			dateStr+=date.getFullYear() + "-";
			dateStr+=date.getMonth() + 1 + "-";
			dateStr+=date.getDate();
			saveFile.save(bmdBytes, dateStr + ".png");
		}

		/**
		 * 链接
		 * @param e
		 *
		 */
		private function getHelpLink(e:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest("http://www.riadev.com/o/fingerchart"), "_blank");
		}

	}
}
