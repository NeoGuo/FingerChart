package com.riameeting.finger.events
{
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * 图表事件
	 * @author Finger
	 * 
	 */	
	public class ChartEvent extends Event
	{
		/**
		 * 图形鼠标经过的事件
		 */		
		public static const ITEM_MOUSE_OVER:String = "itemMouseOver";
		/**
		 * 图形鼠标移出的事件
		 */		
		public static const ITEM_MOUSE_OUT:String = "itemMouseOut";
		/**
		 * 图形点击的事件
		 */		
		public static const ITEM_CLICK:String = "itemClick";
		/**
		 * 坐标值
		 */		
		public var point:Point;
		/**
		 * 数据对象
		 */		
		public var data:Object;
		/**
		 * Y轴字段
		 */		
		public var yField:String;
		/**
		 * 构造方法
		 * @param type 类型
		 * @param bubbles 冒泡
		 * @param cancelable 可取消
		 * 
		 */		
		public function ChartEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		/**
		 * 覆写clone方法
		 * @return 
		 * 
		 */		
		override public function clone():Event {
			var cloneEvt:ChartEvent = new ChartEvent(this.type,true,false);
			cloneEvt.point = this.point;
			cloneEvt.data = this.data;
			cloneEvt.yField = this.yField;
			return cloneEvt;
		}
	}
}