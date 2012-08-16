package com.riameeting.finger.display.graphic
{
	import com.cartogrammar.drawing.CubicBezier;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.container.IChartGraphicContainer;
	import com.riameeting.finger.events.ChartEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	/**
	 * 线状图图形类
	 * @author Finger
	 * 
	 */	
	public class LineGraphic extends Sprite implements IChartGraphic
	{
		private var _data:Object;
		private var _yField:String;
		protected var _color:uint;
		private var _state:String;
		private var _style:Object;
		private var _skinName:String;
		private var _skin:MovieClip;
		/**
		 * 鼠标提示字符串
		 */	
		protected var tipStr:String;
		private var _point:Point;
		private var _center:Point;
		private var _enabled:Boolean = true;
		private var _chartRef:IChart;
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */	
		public function get chartRef():IChart {return _chartRef;}
		public function set chartRef(value:IChart):void {_chartRef=value;}
		/**
		 * 是否禁用
		 * @return 布尔量
		 * 
		 */	
		public function get enabled():Boolean{return _enabled;}
		public function set enabled(value:Boolean):void{_enabled = value;}
		/**
		 * 数据点对应的定位坐标，一般与x和y一致
		 * @return Object
		 * 
		 */		
		public function get point():Point {return _point;};
		public function set point(value:Point):void {_point = value;};
		/**
		 * 图形的中心点，鼠标提示将判断这个中心点来定位
		 * @return 坐标值
		 * 
		 */	
		public function get center():Point{return _center;}
		public function set center(value:Point):void{_center = value;}
		/**
		 * 颜色
		 * @return 颜色值
		 * 
		 */	
		public function get color():uint{return _color;}
		public function set color(value:uint):void{_color = value;skin.updateDisplayList({color:value})}
		/**
		 * 样式
		 * @return 
		 * 
		 */		
		public function get style():Object {return _style};
		public function set style(value:Object):void {_style = value;};
		/**
		 * 皮肤name
		 * @return 
		 * 
		 */		
		public function get skinName():String {return _skinName};
		public function set skinName(value:String):void {_skinName = value};
		/**
		 * 皮肤
		 * @return 
		 * 
		 */		
		public function get skin():MovieClip {return _skin};
		public function set skin(value:MovieClip):void {if(_skin != null) removeChild(_skin);_skin = value;_skin.hostComponent=this;addChildAt(_skin,0)};
		/**
		 * 数据对象
		 * @return Object
		 * 
		 */	
		public function get data():Object{return _data;}
		public function set data(value:Object):void{_data = value;}
		/**
		 * Y轴字段
		 * @return 字符串
		 * 
		 */	
		public function get yField():String{return _yField;}
		public function set yField(value:String):void{_yField = value;}
		/**
		 * 状态
		 * @return 状态字符串
		 * 
		 */	
		public function get state():String{return _state;}
		public function set state(value:String):void
		{
			_state = value;
			if(skin == null) return;
			graphics.clear();
			if(value == MouseEvent.MOUSE_OVER) {
				skin.gotoAndStop(2);
			} else if(value == MouseEvent.MOUSE_OUT) {
				skin.gotoAndStop(1);
			}
		}
		/**
		 * 构造方法
		 * 
		 */		
		public function LineGraphic(chartRef:IChart)
		{
			super();
			_chartRef = chartRef;
			addEventListener(MouseEvent.MOUSE_OVER,mouseHandler);
			addEventListener(MouseEvent.MOUSE_OUT,mouseHandler);
			addEventListener(MouseEvent.CLICK,mouseHandler);
			mouseChildren = false;
			buttonMode = true;
			cacheAsBitmap = true;
			_center = new Point(0,0);
			_skinName = "skin.DotGraphic";
		}
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 * 
		 */	
		public function locate(value:Point=null,offset:uint=10):void {
			if(value != null) _point = value;
			x = _point.x;
			y = _point.y;
			var prevIndex:int = chartRef.dataset.collection.indexOf(data)-1;
			if(style["lineMode"] == "line") {
				if(prevIndex != -1) {
					var prevObject:Object = chartRef.dataset.collection[prevIndex];
					if(prevObject.enabled) {
						var prevPoint:Point = chartRef.axis.getPoint(prevObject,yField);
						(parent as Sprite).graphics.lineStyle(style["lineWidth"],color);
						(parent as Sprite).graphics.moveTo(x-0.5,y);
						(parent as Sprite).graphics.lineTo(prevPoint.x,prevPoint.y);
					}
				}
			} else {
				if(prevIndex == chartRef.dataset.collection.length-2) {
					var points:Array = [];
					var i:uint = 0;
					for(;i<chartRef.dataset.collection.length;i++) {
						prevObject = chartRef.dataset.collection[i];
						var currentPoint:Point = chartRef.axis.getPoint(prevObject,yField);
						points.push(currentPoint);
					}
					(parent as Sprite).graphics.lineStyle(style["lineWidth"],color);
					CubicBezier.curveThroughPoints((parent as Sprite).graphics,points,0.5,0.2);
				}
			}
			//tip str
			if(data["tipString"] == null) data["tipString"] = {};
			data["tipString"][_yField] = "<b><font color='#"+color.toString(16)+"'>"+_yField+"</font></b><br/>";
			var categoryField:String = chartRef.dataset.config["categoryField"];
			data["tipString"][_yField] += categoryField+" : "+data[categoryField]+"<br/>";
			var yTitle:String = chartRef.dataset.config["yTitle"];
			data["tipString"][_yField] += yTitle+" : "+data[_yField];
			if(chartRef.dataset.config["qualifier"] != null) {
				data["tipString"][_yField] += chartRef.dataset.config["qualifier"];
			}
		}
		/**
		 * 执行清理动作
		 * 
		 */	
		public function clear():void {
			graphics.clear();
		}
		/**
		 * 响应鼠标事件的回调方法
		 * @param e 鼠标事件
		 * 
		 */	
		protected function mouseHandler(e:MouseEvent):void {
			var itemEvt:ChartEvent;
			switch(e.type) {
				case MouseEvent.MOUSE_OVER:
					itemEvt = new ChartEvent(ChartEvent.ITEM_MOUSE_OVER);
					break;
				case MouseEvent.MOUSE_OUT:
					itemEvt = new ChartEvent(ChartEvent.ITEM_MOUSE_OUT);
					break;
				case MouseEvent.CLICK:
					itemEvt = new ChartEvent(ChartEvent.ITEM_CLICK);
					break;
			}
			//event dispatch
			itemEvt.point = new Point(x,y);
			itemEvt.data = data;
			itemEvt.yField = yField;
			dispatchEvent(itemEvt);
		}
		
	}
}