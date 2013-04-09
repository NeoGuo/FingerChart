package com.riameeting.finger.display.tooltip
{
	import com.riameeting.utils.DPIReset;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 鼠标提示类
	 * @author Finger
	 * 
	 */
	public class Tooltip extends Sprite implements ITooltip
	{
		private var _text:String;
		private var label:TextField;
		private var _style:Object;
		private var _skin:MovieClip;
		/**
		 * 样式
		 * @return 
		 * 
		 */		
		public function get style():Object {return _style};
		public function set style(value:Object):void {_style = value;};
		/**
		 * 皮肤
		 * @return 
		 * 
		 */		
		public function get skin():MovieClip {return _skin}
		public function set skin(value:MovieClip):void {
			if(_skin != null) removeChild(_skin);
			_skin = value;
			_skin.hostComponent=this;
			_skin.mouseChildren = false;
			_skin.mouseEnabled = false;
			addChildAt(_skin,0);
			label = _skin.label;
			label.multiline = true;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.wordWrap = false;
			var tf:TextFormat = new TextFormat();
			tf.size = 12;// DPIReset.getNumber(20);
			tf.font = "Tahoma";
			label.defaultTextFormat = tf;
			label.x = 9;
		}
		/**
		 * 设置显示文本
		 * @return 
		 * 
		 */	
		public function get text():String {return _text;}
		public function set text(value:String):void {
			_text = value;
			skin.updateDisplayList({value:value});
		}
		/**
		 * 显示文本
		 * @param text
		 * 
		 */	
		public function show(value:String):void {
			text = value;
			visible = true;
		}
		/**
		 * 隐藏
		 * 
		 */	
		public function hide():void {
			visible = false;
		}
		/**
		 * 构造方法
		 * 
		 */		
		public function Tooltip()
		{
			mouseEnabled = false;
			mouseChildren = false;
		}
	}
}