package com.riameeting.controler
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * 事件总线
	 * 
	 */
	public class EventBus
	{
		/**
		 * 事件派发器
		 */		
		public static var dispatcher:IEventDispatcher = new EventDispatcher();
		/**
		 * 添加事件侦听
		 * @param eventType 事件类型
		 * @param eventHandler 事件处理方法
		 * 
		 */		
		public static function addEventListener(eventType:String,eventHandler:Function):void
		{
			dispatcher.addEventListener(eventType,eventHandler);
		}
		/**
		 * 删除事件侦听
		 * @param eventType 事件类型
		 * @param eventHandler 事件处理方法
		 * 
		 */		
		public static function removeEventListener(eventType:String,eventHandler:Function):void
		{
			dispatcher.removeEventListener(eventType,eventHandler);
		}
		
	}
}