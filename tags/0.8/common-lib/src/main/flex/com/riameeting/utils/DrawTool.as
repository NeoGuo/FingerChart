package com.riameeting.utils
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * 绘图工具
	 * @author Finger
	 * 
	 */
	public class DrawTool
	{
		/**
		 * 绘制一条虚线
		 * @param graphics 进行绘制的容器
		 * @param startX 起始X坐标
		 * @param startY 起始Y坐标
		 * @param endX 结束X坐标
		 * @param endY 结束Y坐标
		 * @param dotLength 虚线线段长度
		 * 
		 */		
		public static function dotLineTo(graphics:Graphics,startX:Number,startY:Number,endX:Number,endY:Number,dotLength:uint=4):void
		{
			graphics.moveTo(startX,startY);
			var offsetX:Number = endX - startX;
			var offsetY:Number = endY - startY;
			var lineWidth:Number = Math.sqrt(offsetX*offsetX+offsetY*offsetY);
			var count:uint = lineWidth/dotLength;
			offsetX = offsetX/count;
			offsetY = offsetY/count;
			var targetX:Number,targetY:Number;
			for(var i:uint=0;i<=count;i++) {
				targetX = startX+i*offsetX;
				targetY = startY+i*offsetY;
				if(i%2==0) {
					graphics.lineTo(targetX,targetY);
				} else {
					graphics.moveTo(targetX,targetY);
				}
			}
		}
		/**
		 * 绘制一个扇形或环形
		 * @param graphics 进行绘制的容器
		 * @param point 圆心点坐标
		 * @param radius 半径
		 * @param beginAngle 起始角度
		 * @param angle 角度
		 * @param lineColor 线条颜色
		 * @param lineWidth 线条宽度
		 * @param lineAlpha 线条透明度
		 * @param color 图形颜色
		 * @param innerRadius 环形半径
		 * @return 中心点的坐标
		 * 
		 */		
		public static function drawSector(graphics:Graphics,point:Point,radius:Number,beginAngle:Number,angle:Number,lineColor:uint,lineWidth:uint,lineAlpha:Number,color:uint,innerRadius:uint=50):Point {
			graphics.clear();
			var centerPoint:Point;
			var sx:Number = radius,sxInner:Number = innerRadius;
			var sy:Number = 0,syInner:Number = 0;
			if (beginAngle != 0) {
				sx = Math.cos(beginAngle * Math.PI/180) * radius;
				sy = Math.sin(beginAngle * Math.PI/180) * radius;
				sxInner = Math.cos(beginAngle * Math.PI/180) * innerRadius;
				syInner = Math.sin(beginAngle * Math.PI/180) * innerRadius;
			}
			graphics.lineStyle(lineWidth,lineColor,lineAlpha);
			//graphics.beginFill(color);
			var matix:Matrix =new Matrix();
			matix.createGradientBox(radius*2, radius*2, 0, -radius, -radius);
			graphics.beginGradientFill(GradientType.RADIAL,[ColorUtils.fadeColor(color,0xFFFFFF,0.2),ColorUtils.fadeColor(color,0x000000,0.2)],[1,1],[0x00,0xFF],matix);
			graphics.moveTo(point.x + sxInner, point.y + syInner);
			graphics.lineTo(point.x + sx, point.y +sy);
			var rad:Number =  angle * Math.PI / 180 / angle;
			var cos:Number = Math.cos(rad);
			var sin:Number = Math.sin(rad);
			var i:uint,nx:Number,ny:Number,nxInner:Number,nyInner:Number;
			for (i=0; i<angle; i++) {
				nx = cos * sx - sin * sy;
				ny = cos * sy + sin * sx;
				nxInner = cos * sxInner - sin * syInner;
				nyInner = cos * syInner + sin * sxInner;
				sx = nx;
				sy = ny;
				sxInner = nxInner;
				syInner = nyInner;
				graphics.lineTo(sx + point.x, sy + point.y);
				if(i == uint(angle/2)) {
					centerPoint = new Point((sx + point.x)/2, (sy + point.y)/2);
				}
			}
			graphics.lineTo(point.x + sxInner, point.y + syInner);
			for (i=0; i<angle; i++) {
				nxInner = cos * sxInner + sin * syInner;
				nyInner = cos * syInner - sin * sxInner;
				sxInner = nxInner;
				syInner = nyInner;
				graphics.lineTo(sxInner + point.x, syInner + point.y);
			}
			graphics.endFill();
			return centerPoint;
		}
		
	}
}