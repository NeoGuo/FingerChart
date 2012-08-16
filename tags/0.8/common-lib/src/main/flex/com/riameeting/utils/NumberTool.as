package com.riameeting.utils
{
	import flash.geom.Point;
	/**
	 * 计算数值范围的工具类
	 * @author Finger
	 * 
	 */
	public class NumberTool
	{
		/**
		 * 获取离原值最接近的最大值
		 * @param value 原值
		 * @return 最大值
		 * 
		 */		
		public static function getMaxNumber(value:Number):Number
		{
			var returnNum:Number;
			var valueString:String = value.toString().split(".")[0];
			var leftPat:Number = Number(value > 0 ? valueString.charAt(0):valueString.charAt(1));
			if(value > 0) {
				leftPat++;
			} else {
				leftPat--;
			}
			var valueLength:Number = value > 0 ? valueString.length:valueString.length-1;
			for(var i:uint=1;i<valueLength;i++) {
				leftPat *= 10;
			}
			returnNum = (value > 0 ? leftPat:-leftPat);
			return returnNum;
		}
		/**
		 * 获取离原值最接近的最小值
		 * @param value 原值
		 * @return 最大值
		 * 
		 */		
		public static function getMinNumber(value:Number):Number
		{
			var returnNum:Number;
			var valueString:String = value.toString().split(".")[0];
			var leftPat:Number = Number(value > 0 ? valueString.charAt(0):valueString.charAt(1));
			if(value > 0) {
				leftPat--;
			} else {
				leftPat++;
			}
			var valueLength:Number = value > 0 ? valueString.length:valueString.length-1;
			for(var i:uint=1;i<valueLength;i++) {
				leftPat *= 10;
			}
			returnNum = (value > 0 ? leftPat:-leftPat);
			return returnNum;
		}
		/**
		 * 获取两点之间的距离
		 * @param point1 点1
		 * @param point2 点2
		 * @return 距离
		 * 
		 */		
		public static function getPointDistance(point1:Point,point2:Point):Number
		{
			var offsetX:Number = Math.abs(point1.x - point2.x);
			var offsetY:Number = Math.abs(point1.y - point2.y);
			var distance:Number = Math.sqrt(offsetX*offsetX+offsetY*offsetY);
			return distance;
		}
		/**
		 * 将Array自身的数据扩展N倍
		 * @param source
		 * @param num
		 * @return 
		 * 
		 */		
		public static function extendArrayByClone(source:Array,num:int):Array {
			var extendArray:Array = [];
			for(var i:uint=0;i<num;i++) {
				for(var j:uint=0;j<source.length;j++) {
					extendArray.push(source[j]);
				}
			}
			return extendArray;
		}
	}
}