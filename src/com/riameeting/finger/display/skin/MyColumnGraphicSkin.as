package com.riameeting.finger.display.skin 
{
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.ColorUtils;
	import com.riameeting.utils.ObjectUtils;
	import flash.text.TextField;
	import ghostcat.debug.Debug;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * 我的柱状图面板
	 * @author 黄龙
	 */
	public class MyColumnGraphicSkin extends ColumnGraphic 
	{
		
		public function MyColumnGraphicSkin() 
		{
			super();
		}
		
		override public function updateDisplayList(parms:Object=null):void
		{
			graphics.clear();
			if (parms.width > 25) { parms.width = 25; }
			ObjectUtils.removeAllChildren(this);
			var matix:Matrix =new Matrix();
			matix.createGradientBox(parms.width, parms.height, Math.PI/2, 0, 0);
			//graphics.beginGradientFill(GradientType.LINEAR, [ColorUtils.fadeColor(parms.color, 0x000000, 0.2), parms.color], [1, 1], [0x00, 0xFF], matix);
			//graphics.beginGradientFill(GradientType.LINEAR,[ColorUtils.fadeColor(parms.color,0x000000,0.2),parms.color],[1,1],[0xFF,0xFF],matix);
			graphics.beginFill(parms.color, 1);
			graphics.drawRect(-parms.width/2,0,parms.width,parms.height);
			graphics.endFill();
			/*if (parms.height + 5+parms.text.height + int(hostComponent.chartRef.axis['realGridHeight'] * 0.5 - 2) > hostComponent.chartRef.axis.graphicArea.height)
			{
				parms.text.y =  0;
				parms.text.color = 0xFFFFFF;
			}
			else
			{*/
				parms.text.y =  -parms.text.height+5;
			/*}*/
			//edit by huanglong 不需要切断文字
			/*if (parms.text.width > parms.width)
			{
				parms.text.width = parms.width;
			}*/
			Debug.trace("显示文字宽度", parms.text.width);
			parms.text.x = -parms.text.width * 0.5+2;
			addChild(parms.text);
		}
		
	}

}