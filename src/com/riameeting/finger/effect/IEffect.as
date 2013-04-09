package com.riameeting.finger.effect
{
	/**
	 * 特效接口
	 * @author Finger
	 * 
	 */	
	public interface IEffect
	{
		/**
		 * 执行
		 * @param obj 对象
		 * @param time 时长
		 * 
		 */		
		function execute(obj:Object,time:Number,callback:Function=null):void;
	}
}