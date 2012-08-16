package com.riameeting.ui.control
{
	import flash.display.Sprite;
	/**
	 * 一个轻量级的按钮组件
	 * @author Finger
	 * 
	 */	
	public class Button extends Sprite
	{
		private var _label:String;
		/**
		 * 文本显示
		 */		
		protected var labelDisplay:Label = new Label();
		/**
		 * 构造方法
		 * 
		 */		
		public function Button()
		{
			labelDisplay.color = 0xFFFFFF;
			addChild(labelDisplay);
		}
		/**
		 * 设置文本显示
		 * @return 
		 * 
		 */		
		public function get label():String {
			return _label;
		}
		public function set label(value:String):void {
			_label = value;
			labelDisplay.text = value;
			this.graphics.clear();
			this.graphics.beginFill(0x333333,0.8);
			this.graphics.drawRoundRect(-2,-2,labelDisplay.width+4,labelDisplay.height+4,4,4);
			this.graphics.endFill();
		}
		
	}
}