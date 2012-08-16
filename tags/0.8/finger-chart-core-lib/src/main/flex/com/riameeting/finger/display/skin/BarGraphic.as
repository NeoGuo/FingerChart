package com.riameeting.finger.display.skin
{
	import com.riameeting.utils.ColorUtils;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * 默认的条图皮肤
	 * @author RIAMeeting
	 * 
	 */	
	public class BarGraphic extends MovieClip implements ISkin
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
		public function BarGraphic()
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
			graphics.clear();
			var matix:Matrix =new Matrix();
			matix.createGradientBox(-parms.height, -parms.width/2, 0, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR,[ColorUtils.fadeColor(parms.color,0xFFFFFF,0.2),parms.color],[1,1],[0x00,0xFF],matix);
			graphics.drawRect(-parms.height,-parms.width/2,parms.height,parms.width);
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