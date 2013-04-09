package com.riameeting.finger.effect
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * 透明度渐变淡出
	 * @author Finger
	 * 
	 */
	public class FadeOut implements IEffect
	{
		/**
		 * 构造方法
		 * 
		 */		
		public function FadeOut()
		{
		}
		/**
		 * 执行
		 * @param obj 对象
		 * @param time 时长
		 * 
		 */	
		public function execute(obj:Object,time:Number,callback:Function=null):void
		{
			TweenLite.to(obj,time,{alpha:0,onComplete:callBack});
			function callBack():void {
				if(callback != null) callback();
			}
		}
	}
}