package com.riameeting.finger.display.skin
{
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.geom.Matrix;

	/**
	 * 默认的图表皮肤
	 * @author RIAMeeting
	 * 
	 */	
	public class ChartSkin extends MovieClip implements ISkin
	{
		private var _hostComponent:Object;
		/**
		 * 组件引用
		 * @return 
		 * 
		 */		
		public function get hostComponent():Object {return _hostComponent};
		public function set hostComponent(value:Object):void {_hostComponent = value};
		public function ChartSkin()
		{
			super();
			this.cacheAsBitmap = true;
		}
		
		public function updateDisplayList(parm:Object=null):void {
			graphics.clear();
			var style:Object = _hostComponent.style;
			var color1:uint = style["bgColors"][0];
			var color2:uint = style["bgColors"][1];
			var colorAlpha1:Number = style["bgAlphas"][0]/100;
			var colorAlpha2:Number = style["bgAlphas"][1]/100;
			var matix:Matrix =new Matrix();
			matix.createGradientBox(parm.width, parm.height, Math.PI/2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR,[color1,color2],[colorAlpha1,colorAlpha2],[0x00,0xFF],matix);
			graphics.drawRect(0,0,parm.width,parm.height);
			graphics.endFill();
		}
		
	}
}