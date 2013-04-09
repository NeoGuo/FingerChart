package com.riameeting.finger.display.skin 
{
	import com.riameeting.utils.ColorUtils;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * 堆栈图柱状图面板
	 * @author 黄龙
	 */
	public class StackedColumnGraphicSkin extends ColumnGraphic 
	{
		
		public function StackedColumnGraphicSkin() 
		{
			super();
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			//trace(this.parent.parent.parent.name);
			if(frame == 1) {
				dot.visible = false;
			} else {
				dot.visible = true;
			}
		}
		
		override public function updateDisplayList(parms:Object=null):void
		{
			graphics.clear();
			var matix:Matrix =new Matrix();
			matix.createGradientBox(parms.width, parms.height, Math.PI/2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR,[parms.color,parms.color],[0.9,0.9],[0x00,0xFF],matix);
			graphics.drawRect(-parms.width/2,0,parms.width,parms.height);
			graphics.endFill();
		}
		
	}

}