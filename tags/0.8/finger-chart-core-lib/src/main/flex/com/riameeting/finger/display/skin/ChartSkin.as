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
			var color3:uint = style["lineColors"][0];
			var color4:uint = style["lineColors"][1];
			var colorAlpha3:Number = style["lineAlphas"][0]/100;
			var colorAlpha4:Number = style["lineAlphas"][1]/100;
			var matix:Matrix =new Matrix();
			matix.createGradientBox(parm.width, parm.height, Math.PI/2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR,[color1,color2],[colorAlpha1,colorAlpha2],[0x00,0xFF],matix);
			graphics.drawRect(0,0,parm.width,parm.height);
			graphics.endFill();
			var lineWidth:int = 50;
			var lineNum:int = parm.width/lineWidth;
			for(var i:uint=0;i<(lineNum)/2;i++) {
				graphics.beginGradientFill(GradientType.LINEAR,[color3,color4,color3],[colorAlpha3,colorAlpha4,colorAlpha3],[0x00,0xCC,0xFF],matix);
				graphics.drawRect(i*lineWidth*2+lineWidth,0,lineWidth,parm.height);
				graphics.endFill();
			}
		}
		
	}
}