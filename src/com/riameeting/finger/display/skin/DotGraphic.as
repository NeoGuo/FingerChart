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
		protected var parms:Object;
		
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
				//dotcolor = 0x000000;
				graphics.lineStyle(1, 0xFFFFFF, 1);
				graphics.beginFill(dotcolor,1);
				graphics.drawCircle(0,0,8);
				//graphics.endFill();
				graphics.beginFill(0xFFFFFF,1);
				graphics.drawCircle(0,0,5);
				//graphics.endFill();
				graphics.beginFill(dotcolor,1);
				graphics.drawCircle(0,0,4);
				graphics.endFill();
				return;
			}
			graphics.lineStyle(2,0xFFFFFF,1);
			graphics.beginFill(dotcolor,1);
			graphics.drawCircle(0,0,5);
			graphics.endFill();
		}
		
	}
}