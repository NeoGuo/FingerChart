package com.riameeting.finger.display.skin
{
	import com.riameeting.utils.ColorUtils;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * 默认的柱图图形皮肤
	 * @author RIAMeeting
	 * 
	 */	
	public class CompareColumnGraphicSkin extends MovieClip implements ISkin
	{
		protected var dot:Sprite = new Sprite();
		
		private var _hostComponent:Object;
		/**
		 * 组件引用
		 * @return 
		 * 
		 */		
		public function get hostComponent():Object {return _hostComponent};
		public function set hostComponent(value:Object):void {_hostComponent = value};
		
		public function CompareColumnGraphicSkin()
		{
			super();
			dot.graphics.lineStyle(1,0x000000,1);
			dot.graphics.beginFill(0xFFFFFF,1);
			dot.graphics.drawCircle(0,0,6);
			dot.graphics.endFill();
			dot.graphics.lineStyle();
			dot.graphics.beginFill(0x000000,1);
			dot.graphics.drawCircle(0,0,2);
			dot.graphics.endFill();
			dot.visible = false;
			addChild(dot);
		}
		
		public function updateDisplayList(parms:Object=null):void
		{
			if (parms.width > 25) { parms.width = 25; }
			graphics.clear();
			var matix:Matrix =new Matrix();
			matix.createGradientBox(parms.width, parms.height, Math.PI / 2, 0, 0);
			graphics.beginFill(parms.color, 1);
			//graphics.beginGradientFill(GradientType.LINEAR,[ColorUtils.fadeColor(parms.color,0x000000,0.5),parms.color],[1,1],[0x00,0xFF],matix);
			graphics.drawRect(-parms.width/2,0,parms.width,parms.height);
			graphics.endFill();
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void {
			if(frame == 1) {
				dot.visible = false;
			} else {
				dot.visible = true;
			}
		}
		
	}
}