package com.riameeting.finger.display.skin
{
	import com.riameeting.utils.ColorUtils;
	import flash.text.TextField;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * 横向图柱形对象
	 * @author 黄龙
	 */
	public class HorzontalColumnGraphicSkin extends ColumnGraphic
	{
		private var labelContainer:Sprite = new Sprite();
		
		public function HorzontalColumnGraphicSkin()
		{
			super();
		}
		
		override public function updateDisplayList(parms:Object = null):void
		{
			if (parms.height > 20) { parms.height = 20; }
			graphics.clear();
			if (this.contains(labelContainer) == false)
			{
				this.addChild(labelContainer);
			}
			removeAllLabel();
			var matix:Matrix = new Matrix();
			matix.createGradientBox(parms.width, parms.height, Math.PI / 2, 0, 0);
			//graphics.beginGradientFill(GradientType.LINEAR, [ColorUtils.fadeColor(parms.color, 0x000000, 0.2), parms.color], [1, 1], [0x00, 0xFF], matix);
			//graphics.beginGradientFill(GradientType.LINEAR, [ColorUtils.fadeColor(parms.color, 0x000000, 0.2), parms.color], [1, 1], [0xFF, 0xFF], matix);
			graphics.beginFill(parms.color, 1);
			graphics.drawRect(0,0, parms.width, parms.height);
			graphics.endFill();
			dot.x = parms.width;
			dot.y = parms.height / 2;
			//parms.text.htmlText = "<font face = 'Tahoma' > "+parms.text.htmlText + "</font>";
			parms.text.x = parms.width + 10;
			parms.text.y = -5;
			if (parms.text.x + parms.text.width > hostComponent.chartRef.axis.graphicArea.width)
			{
				parms.text.x = parms.width - parms.text.width;
				parms.text.color = 0xFFFFFF;
			}
			labelContainer.addChild(parms.text);
		}
		
		private function removeAllLabel():void
		{
			var len:uint = labelContainer.numChildren;
			while (len > 0)
			{
				labelContainer.removeChildAt(0);
				len--;
			}
		}
	}

}