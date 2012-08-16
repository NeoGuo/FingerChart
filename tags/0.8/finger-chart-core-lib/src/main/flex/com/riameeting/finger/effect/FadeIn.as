package com.riameeting.finger.effect
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * 透明度渐变进入
	 * @author Finger
	 * 
	 */
	public class FadeIn implements IEffect
	{
		/**
		 * 构造方法
		 * 
		 */		
		public function FadeIn()
		{
			super();
		}
		/**
		 * 执行
		 * @param obj 对象
		 * @param time 时长
		 * 
		 */	
		public function execute(obj:Object,time:Number,callback:Function = null):void
		{
			obj.alpha = 0;
			obj.visible = true;
			TweenLite.to(obj,time,{alpha:1,onComplete:callBack});
			function callBack():void {
				if(callback != null) callback();
			}
		}
		
	}
}