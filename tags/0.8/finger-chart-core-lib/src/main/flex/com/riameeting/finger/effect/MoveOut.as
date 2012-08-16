package com.riameeting.finger.effect
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.riameeting.finger.display.graphic.IChartGraphic;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	/**
	 * 移动淡出特效
	 * @author Finger
	 * 
	 */
	public class MoveOut implements IEffect
	{
		/**
		 * 构造方法
		 * 
		 */		
		public function MoveOut()
		{
		}
		/**
		 * 执行
		 * @param obj 对象
		 * @param time 时长
		 * 
		 */	
		public function execute(obj:Object, time:Number, callback:Function = null):void
		{
			var seriel:Sprite = obj as Sprite;
			var child:IChartGraphic;
			var childNum:uint = seriel.numChildren;
			var splitTime:Number = time/childNum;
			var currentIndex:uint = 0;
			seriel.graphics.clear();
			setTimeout(callBack,time*1000);
			for(var i:uint=0;i<childNum;i++) {
				child = seriel.getChildAt(i) as IChartGraphic;
				TweenLite.to(child,time,{y:seriel.stage.stageHeight,delay:splitTime*i});
			}
			function callBack(...args):void {
				if(callback != null) callback();
			}
		}
	}
}