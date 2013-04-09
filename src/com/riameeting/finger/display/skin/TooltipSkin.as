package com.riameeting.finger.display.skin
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * 默认的鼠标提示皮肤
	 * @author RIAMeeting
	 * 
	 */	
	public class TooltipSkin extends MovieClip implements ISkin
	{
		public var label:TextField = new TextField();
		private var _hostComponent:Object;
		/**
		 * 组件引用
		 * @return 
		 * 
		 */		
		public function get hostComponent():Object {return _hostComponent};
		public function set hostComponent(value:Object):void {_hostComponent = value};
		
		public function TooltipSkin()
		{
			super();
			label.x = label.y = 2;
			addChild(label);
		}
		
		public function updateDisplayList(parms:Object=null):void
		{
			var style:Object = _hostComponent.style;
			var color:String = style["color"];
			label.htmlText = "<font color='" + color.replace("0x","#") + "'>" + parms.value + "</font>";
			label.width = label.textWidth + 4;
			label.height = label.textHeight + 4;
			graphics.clear();
			graphics.lineStyle(1,style["borderColor"],style["borderAlpha"]/100);
			graphics.beginFill(style["tipbgColor"],1);
			graphics.drawRoundRect(4.5,1,label.width+5,label.height+5,0,0);
			graphics.endFill();
		}
		
	}
}