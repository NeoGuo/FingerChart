package com.riameeting.ui.control
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 复选框类
	 * @author Finger
	 * 
	 */	
	public class CheckBox extends Sprite
	{
		private var _selected:Boolean;
		private var icon:Sprite = new Sprite();
		private var _label:String;
		/**
		 * 文本显示
		 */		
		protected var labelDisplay:Label = new Label();
		/**
		 * 标记复选框的选择状态
		 * @return 布尔量
		 * 
		 */
		public function get selected():Boolean{return _selected;}
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected) {
				icon.graphics.beginFill(0x000000,1);
				icon.graphics.drawRect(2,2,11,11);
				icon.graphics.endFill();
			} else {
				icon.graphics.clear();
			}
		}

		/**
		 * 构造方法
		 * 
		 */		
		public function CheckBox()
		{
			super();
			buttonMode = true;
			mouseChildren = false;
			graphics.lineStyle(1,0xCCCCCC,1);
			graphics.beginFill(0xFFFFFF,1);
			graphics.drawRect(2,2,14,14);
			graphics.endFill();
			addChild(icon);
			icon.x = 2;
			icon.y = 2;
			addEventListener(MouseEvent.CLICK,checkStatus);
			labelDisplay.x = 20;
			addChild(labelDisplay);
		}
		/**
		 * 检查状态
		 * @param e
		 * 
		 */		
		protected function checkStatus(e:MouseEvent):void {
			selected = !selected;
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
		}
		
	}
}