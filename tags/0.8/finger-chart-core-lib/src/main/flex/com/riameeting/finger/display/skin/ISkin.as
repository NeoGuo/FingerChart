package com.riameeting.finger.display.skin
{
	/**
	 * 皮肤元件接口
	 * @author RIAMeeting
	 * 
	 */	
	public interface ISkin
	{
		function get hostComponent():Object;
		function set hostComponent(value:Object):void;
		/**
		 * 皮肤应实现这个方法
		 * 
		 */		
		function updateDisplayList(parms:Object=null):void;
	}
}