package com.riameeting.finger.display.container
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.graphic.IChartGraphic;
	import com.riameeting.finger.effect.IEffect;
	import com.riameeting.finger.events.ChartEvent;
	import com.riameeting.finger.factory.ObjectFactory;
	import com.riameeting.finger.vo.DatasetVO;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;

	/**
	 * 图形容器类
	 * @author Finger
	 * 
	 */	
	public class ChartGraphicContainer extends Sprite implements IChartGraphicContainer
	{
		private var _dataset:DatasetVO;
		private var _graphicClass:Class;
		private var _graphicKey:String;
		private var _yFields:Array;
		private var _benchmark:Array;
		private var _graphicsCollection:Array;
		private var _seriesCollection:Array;
		private var _seriesMode:Object = {};
		private var _style:Object = {color:0x000000,benchmarkColor:0x999999,lineWidth:2,dotWidth:2,lineMode:"line"};
		private var _benchmarkClass:Class;
		private var _graphicShowEffect:IEffect;
		private var _graphicHideEffect:IEffect;
		private var _chartRef:IChart;
		private var _differentColors:Boolean;
		/**
		 * 遮罩
		 */		
		protected var maskRect:Sprite = new Sprite();
		/**
		 * 是否开启动画模式
		 */		
		public var useAnimation:Boolean = true;
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */	
		public function get chartRef():IChart {return _chartRef;}
		public function set chartRef(value:IChart):void {_chartRef=value;}
		/**
		 * 是否开启多色彩模式（每个图形使用单独的色彩）
		 * @return 布尔量
		 * 
		 */
		public function get differentColors():Boolean{return _differentColors;}
		public function set differentColors(value:Boolean):void{_differentColors = value;}
		/**
		 * 图形显示的特效
		 * @return 
		 * 
		 */	
		public function get graphicShowEffect():IEffect{return _graphicShowEffect;}
		public function set graphicShowEffect(value:IEffect):void{_graphicShowEffect = value;}
		/**
		 * 图形隐藏的特效
		 * @return 
		 * 
		 */	
		public function get graphicHideEffect():IEffect{return _graphicHideEffect;}
		public function set graphicHideEffect(value:IEffect):void{_graphicHideEffect = value;}
		/**
		 * 参考线类
		 * @return 类
		 * 
		 */	
		public function get benchmarkClass():Class{return _benchmarkClass;}
		public function set benchmarkClass(value:Class):void{_benchmarkClass = value;}
		/**
		 * CSS样式定义
		 * @return 对象
		 * 
		 */	
		public function get style():Object{return _style;}
		public function set style(value:Object):void{_style = value;}
		/**
		 * 图形类
		 * @return 类
		 * 
		 */
		public function get graphicClass():Class{return _graphicClass;}
		public function set graphicClass(value:Class):void{_graphicClass = value;}
		/**
		 * 对数据源的引用
		 * @return DatasetVO引用
		 * 
		 */
		public function get dataset():DatasetVO{return _dataset;}
		public function set dataset(value:DatasetVO):void
		{
			_dataset = value;
			yFields = value.config["yField"].split(",");
			if(value.config["benchmark"] != null) benchmark = value.config["benchmark"].split(",");
		}
		/**
		 * Y轴定义的数据显示字段，可以为1个或多个
		 * @return 数组
		 * 
		 */	
		public function get yFields():Array{return _yFields;}
		public function set yFields(value:Array):void{_yFields = value;}
		/**
		 * Y轴定义的参考线显示字段，可以为1个或多个
		 * @return 数组
		 * 
		 */
		public function get benchmark():Array {return _benchmark;}
		public function set benchmark(value:Array):void {_benchmark = value;}
		/**
		 * 构造方法
		 * @param graphicClass 图形类
		 * @param benchmarkClass 参考线类
		 * @param differentColors 不同色彩模式
		 * @param showEffect 显示特效
		 * @param hideEffect 隐藏特效
		 * 
		 */		
		public function ChartGraphicContainer(chartRef:IChart,graphicClass:Class,graphicKey:String,benchmarkClass:Class,differentColors:Boolean,showEffect:IEffect,hideEffect:IEffect)
		{
			super();
			_chartRef = chartRef;
			_graphicClass = graphicClass;
			_graphicKey = graphicKey;
			_benchmarkClass = benchmarkClass;
			_differentColors = differentColors;
			graphicShowEffect = showEffect;
			graphicHideEffect = hideEffect;
			addEventListener(ChartEvent.ITEM_CLICK,itemClickHanlder);
		}
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法进行重绘
		 * @param width 宽度
		 * @param height 高度
		 * 
		 */	
		public function updateDisplayList(width:uint,height:uint):void {
			clear();
			for(var i:uint=0;i<yFields.length;i++) {
				var series:Sprite = ObjectFactory.produce(Sprite,"Sprite") as Sprite;
				_seriesCollection.push(series);
				series.name = yFields[i];
				addChild(series);
				for(var j:uint=0;j<dataset.collection.length;j++) {
					var graphic:IChartGraphic;
					if(dataset.config["benchmark"] != null && benchmark.indexOf(yFields[i]) > -1) {
						graphic = ObjectFactory.produce(_benchmarkClass,"BenchmarkClass",[chartRef]) as IChartGraphic;
					} else {
						graphic = ObjectFactory.produce(_graphicClass,_graphicKey,[chartRef]) as IChartGraphic;
					}
					graphic.data = dataset.collection[j];
					graphic.style = style;
					if(graphic.skin == null) graphic.skin = ChartGlobal.getSkin(graphic.skinName);
					if(graphic.data["name"] == null) graphic.data["name"] = graphic.data[dataset.config["categoryField"]];
					graphic.name = graphic.data["name"];
					graphic.yField = yFields[i];
					if(graphic.data[graphic.yField] == "-") {
						graphic.enabled = false;
						graphic.data.enabled = false;
					} else {
						graphic.enabled = true;
						graphic.data.enabled = true;
					}
					if(dataset.config["benchmark"] != null && benchmark.indexOf(graphic.yField) > -1) {
						graphic.color = style["benchmarkColor"];
					} else {
						if(differentColors) {
							graphic.color = ChartGlobal.colorCollection[j];
						} else {
							graphic.color = ChartGlobal.colorCollection[i];
						}
					}
					if(graphic.enabled) {
						series.addChild(graphic as DisplayObject);
						graphic.locate(chartRef.axis.getPoint(graphic.data,graphic.yField));
						_graphicsCollection.push(graphic);
					}
				}
				if(seriesMode[series.name] != false) {
					showSeries(series.name);
				} else {
					hideSeries(series.name);
				}
			}
			//mask
			var axisRect:Rectangle = chartRef.axis.getAxisRect();
			maskRect.graphics.clear();
			maskRect.graphics.beginFill(0x000000,1);
			maskRect.graphics.drawRect(axisRect.x,axisRect.y,axisRect.width,axisRect.height);
			maskRect.graphics.endFill();
			mask = maskRect;
			parent.addChild(maskRect);
		}
		/**
		 * 显示series（适用于多组数据，比如多条折线）
		 * @param seriesName 名称
		 * 
		 */	
		public function showSeries(seriesName:String,animation:Boolean=false):void {
			var series:DisplayObject = getChildByName(seriesName);
			if(useAnimation) animation = true;
			if(animation && graphicShowEffect!=null) {
				graphicShowEffect.execute(series,0.5,effectComplete);
				(chartRef as Sprite).mouseEnabled = false;
			} else {
				series.visible = true;
			}
		}
		/**
		 * 隐藏series（适用于多组数据，比如多条折线）
		 * @param seriesName 名称
		 * 
		 */	
		public function hideSeries(seriesName:String,animation:Boolean=false):void {
			var series:DisplayObject = getChildByName(seriesName);
			if(useAnimation) animation = true;
			if(animation && graphicHideEffect!=null) {
				graphicHideEffect.execute(series,0.5,effectComplete);
				(chartRef as Sprite).mouseEnabled = false;
			} else {
				series.visible = false;
			}
		}
		/**
		 * 显示图形
		 * @param graphicName 名称
		 * 
		 */	
		public function showGraphic(graphicName:String,animation:Boolean=false):void {
			var g:DisplayObject = getObjByName(graphicName);
			if(graphicShowEffect!=null) {
				graphicShowEffect.execute(g,0.5,effectComplete);
				(chartRef as Sprite).mouseEnabled = false;
			} else {
				g.visible = true;
			}
		}
		/**
		 * 隐藏图形
		 * @param graphicName 名称
		 * 
		 */	
		public function hideGraphic(graphicName:String,animation:Boolean=false):void {
			var g:DisplayObject = getObjByName(graphicName);
			if(graphicHideEffect!=null) {
				graphicHideEffect.execute(g,0.5,effectComplete);
				(chartRef as Sprite).mouseEnabled = false;
			} else {
				g.visible = false;
			}
		}
		/**
		 * 一个包含了所有图形的数组
		 * @return 数组
		 * 
		 */	
		public function get graphicsCollection():Array {return _graphicsCollection;}
		/**
		 * 如果yFields是多个，则将数据分为N个series，series放置到这个数组
		 * @return 数组
		 * 
		 */	
		public function get seriesCollection():Array {return _seriesCollection;}
		/**
		 * 同seriesCollection对应，但存储的是series的状态
		 * @return 
		 * 
		 */		
		public function get seriesMode():Object {return _seriesMode;}
		/**
		 * 获取容器中的图形
		 * @param data 数据对象
		 * @param yField Y轴字段
		 * @return IChartGraphic
		 * 
		 */	
		public function getGraphic(data:Object,yField:String):IChartGraphic {
			var graphic:IChartGraphic;
			f:for each(var item:IChartGraphic in _graphicsCollection) {
				if(item.data == data && item.yField == yField) {
					graphic = item;
					break f;
				}
			}
			return graphic;
		}
		/**
		 * 图形被点击触发的回调方法
		 * @param e 图形点击事件
		 * 
		 */		
		protected function itemClickHanlder(e:ChartEvent):void {
			if(chartRef.chartConfig["callback"] != null && ExternalInterface.available) {
				ExternalInterface.call(chartRef.chartConfig["callback"],e.data);
			}
		}
		/**
		 * 通过名称获取对象的引用
		 * @param objName 对象名称
		 * @return 对象
		 * 
		 */		
		protected function getObjByName(objName:String):DisplayObject {
			var obj:DisplayObject;
			f:for each(var item:DisplayObject in graphicsCollection) {
				if(item.name == objName) {
					obj = item;
					break f;
				}
			}
			return obj;
		}
		/**
		 * 特效执行完毕
		 * @param e
		 * 
		 */		
		protected function effectComplete():void {
			(chartRef as Sprite).mouseEnabled = true;
		}
		/**
		 * 执行清理动作
		 * 
		 */	
		public function clear():void {
			graphics.clear();
			_graphicsCollection = [];
			_seriesCollection = [];
			var series:Sprite;
			while(numChildren > 0) {
				series = getChildAt(0) as Sprite;
				while(series.numChildren > 0) {
					(series.getChildAt(0) as IChartGraphic).clear();
					if(benchmark != null &&benchmark.indexOf(series.name) > -1) {
						ObjectFactory.reclaim(_benchmarkClass,series.removeChildAt(0),"BenchmarkClass");
					} else {
						ObjectFactory.reclaim(_graphicClass,series.removeChildAt(0),_graphicKey);
					}
				}
				series.name = "";
				series.graphics.clear();
				ObjectFactory.reclaim(Sprite,removeChild(series),"Sprite");
			}
		}
		
	}
}