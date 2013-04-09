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
	 * 移动进入特效
	 * @author Finger
	 * 
	 */
	public class MoveIn implements IEffect
	{
		/**
		 * 对象哈希
		 */		
		public static var objDic:Dictionary = new Dictionary();
		/**
		 * 执行
		 * @param obj 对象
		 * @param time 时长
		 * 
		 */	
		public function execute(obj:Object, time:Number, callback:Function = null):void
		{
			var seriel:Sprite = obj as Sprite;
			seriel.visible = true;
			var child:IChartGraphic;
			var childNum:uint = seriel.numChildren;
			var splitTime:Number = time/childNum;
			var currentIndex:uint = 0;
			seriel.graphics.clear();
			setTimeout(callBack,time*1000);
			for(var i:uint=0;i<childNum;i++) {
				child = seriel.getChildAt(i) as IChartGraphic;
				var targetY:Number = child.point.y;
				(child as DisplayObject).y = seriel.stage.stageHeight;
				TweenLite.to(child,time,{y:targetY,delay:splitTime*i,onComplete:drawChild});
			}
			function drawChild(...args):void {
				if(currentIndex >= childNum) return;
				child = seriel.getChildAt(currentIndex) as IChartGraphic;
				child.locate();
				currentIndex++;
			}
			function callBack(...args):void {
				if(callback != null) callback();
			}
		}
	}
}