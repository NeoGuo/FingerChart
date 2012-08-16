package com.riameeting.finger.display.skin
{
	import flash.display.MovieClip;
	/**
	 * 默认的点图形皮肤
	 * @author RIAMeeting
	 * 
	 */	
	public class DotGraphic extends MovieClip implements ISkin
	{
		private var parms:Object;
		
		private var _hostComponent:Object;
		/**
		 * 组件引用
		 * @return 
		 * 
		 */		
		public function get hostComponent():Object {return _hostComponent};
		public function set hostComponent(value:Object):void {_hostComponent = value};
		
		public function DotGraphic()
		{
			super();
		}
		
		public function updateDisplayList(parms:Object=null):void
		{
			this.parms = parms;
			drawGraphic(1);
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void {
			drawGraphic(int(frame));
		}
		
		protected function drawGraphic(frame:int):void {
			graphics.clear();
			var dotcolor:uint = parms.color;
			var style:Object = _hostComponent.style;
			if(frame == 2) {
				dotcolor = 0x000000;
				graphics.lineStyle(1,0x000000,1);
				graphics.beginFill(0xFFFFFF,1);
				graphics.drawCircle(0,0,style.dotWidth+4);
				graphics.endFill();
			}
			graphics.lineStyle();
			graphics.beginFill(dotcolor,1);
			graphics.drawCircle(0,0,style.dotWidth);
			graphics.endFill();
		}
		
	}
}