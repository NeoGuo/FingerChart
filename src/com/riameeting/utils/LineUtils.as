package com.riameeting.utils
{
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.display.Sprite;
	
	/**
	 * 虚线
	 * @author 黄龙
	 */
	public class LineUtils
	{
		
		public function LineUtils()
		{
		
		}
		
		/**
		 * 画虚线
		 *
		 * @param graphics <b>Graphics</b>
		 * @param beginPoint <b>Point</b> 开始位置
		 * @param endPoint <b>Point</b> 结束位置
		 * @param widths <b>Number</b> 虚线的长度
		 * @param grap <b>Number</b> 间距
		 */
		static public function drawDashed(graphics:Graphics, beginPoint:Point, endPoint:Point, widths:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || widths <= 0 || grap <= 0)
			{
				return;
			}
			//widths = 1; grap = 2;
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var x:Number, y:Number;
			graphics.lineStyle(1, 0xE5E5E5, 1);
			while (currLen <= totalLen)
			{
				x = Ox + Math.cos(radian) * currLen;
				y = Oy + Math.sin(radian) * currLen;
				graphics.moveTo(x, y);
				
				currLen += widths;
				if (currLen > totalLen)
				{
					currLen = totalLen;
				}
				
				x = Ox + Math.cos(radian) * currLen;
				y = Oy + Math.sin(radian) * currLen;
				graphics.lineTo(x, y);
				
				currLen += grap;
			}
		}
	
	}

}