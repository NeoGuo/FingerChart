package com.riameeting.finger.display.skin
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.utils.ColorUtils;
	import ghostcat.debug.Debug;
	
	/**
	 * 比较型点的形状
	 * @author 黄龙
	 */
	public class CompareDotGraphic extends DotGraphic
	{
		
		public function CompareDotGraphic()
		{
			super();
		}
		
		override protected function drawGraphic(frame:int):void
		{
			//super.drawGraphic(frame);
			graphics.clear();
			var dotcolor:uint = parms.color;
			var style:Object = hostComponent.style;
			/*trace(dotcolor);
			var color1:String = ColorUtils.toColorString(dotcolor);
			var arr:Array = ChartGlobal.colorCollection;*/
			var index:int = ChartGlobal.colorCollection.indexOf(dotcolor);
			//trace(index);
			if (index == -1)
			{
				index = ChartGlobal.colorCollection.indexOf(ColorUtils.toColorBString(dotcolor));
			}
			dotcolor = ChartGlobal.colorCollection[Math.floor((index) * 0.5)];
			//Debug.trace("color", dotcolor);
			if (index % 2 == 1)
			{
				if (frame == 2)
				{
					graphics.lineStyle(2, 0xFFFFFF, 1);
					graphics.beginFill(0x000000, 1);
					graphics.drawRect(-style.dotWidth, -style.dotWidth, style.dotWidth * 2, style.dotWidth * 2);
					graphics.endFill();
				}
				else
				{
					graphics.lineStyle(2, 0xFFFFFF, 1);
					graphics.beginFill(dotcolor, 1);
					graphics.drawRect(-style.dotWidth, -style.dotWidth, style.dotWidth * 2, style.dotWidth * 2);
					graphics.endFill();
				}
			}
			else
			{
				if (frame == 2)
				{
					//dotcolor = 0x000000;
					graphics.lineStyle(2, 0xFFFFFF, 1);
					graphics.beginFill(0x000000, 1);
					graphics.drawCircle(0, 0, style.dotWidth);
					graphics.endFill();
				}
				else
				{
					graphics.lineStyle(2, 0xFFFFFF, 1);
					graphics.beginFill(dotcolor, 1);
					graphics.drawCircle(0, 0, style.dotWidth);
					graphics.endFill();
				}
			}
		}
	}

}