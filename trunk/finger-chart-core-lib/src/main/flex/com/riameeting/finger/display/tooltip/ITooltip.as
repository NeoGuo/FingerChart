package com.riameeting.finger.display.tooltip
{
	import flash.display.MovieClip;

	/**
	 * 鼠标提示接口
	 * @author Finger
	 * 
	 */	
	public interface ITooltip
	{
		/**
		 * 设置显示文本
		 * @return 
		 * 
		 */		
		function get text():String;
		function set text(value:String):void;
		/**
		 * 显示文本
		 * @param text
		 * 
		 */		
		function show(text:String):void;
		/**
		 * 隐藏
		 * 
		 */		
		function hide():void;
		/**
		 * x坐标值
		 * @return 
		 * 
		 */		
		function get x():Number;
		function set x(value:Number):void;
		/**
		 * y坐标值
		 * @return 
		 * 
		 */		
		function get y():Number;
		function set y(value:Number):void;
		/**
		 * 宽度
		 * @return 
		 * 
		 */		
		function get width():Number;
		function set width(value:Number):void;
		/**
		 * 高度
		 * @return 
		 * 
		 */		
		function get height():Number;
		function set height(value:Number):void;
		/**
		 * 样式
		 * @return 
		 * 
		 */		
		function get style():Object;
		function set style(value:Object):void;
		/**
		 * 皮肤
		 * @return 
		 * 
		 */		
		function get skin():MovieClip;
		function set skin(value:MovieClip):void;
	}
}