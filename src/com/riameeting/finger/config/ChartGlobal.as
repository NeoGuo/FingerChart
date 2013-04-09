package com.riameeting.finger.config
{
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.skin.*;
	import com.riameeting.finger.vo.DatasetVO;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * 定义全局可访问的变量和配置，属性皆是静态属性，直接引用即可
	 * @author Finger
	 * 
	 */	
	public class ChartGlobal
	{
		/**
		 * 定义当前图表的版本号
		 */		
		public static var version:String = "0.9";
		
		/**
		 * 最后更新日期
		 */		
		public static const buildDate:String = "2011-8-21";
		/**
		 * 皮肤源
		 */		
		public static var skinSource:MovieClip;
		/**
		 * 图表引用
		 */		
		public static var skinClassDict:Dictionary;
		
		public static var chartConfig:Object;
		
		public static var baseDataSet:Object;
		public static var width:int;
		public static var height:int;
		
		public static var labelArr:Array = [];
		
		public static var LabelSprite:Sprite = new Sprite();
		
		public static var drawOver:Boolean = false;
		
		/**
		 * 颜色引用
		 */
		public static var colorDict:Dictionary = new Dictionary();
		
		/**
		 * 获取皮肤素材
		 * @param skinName
		 * @return 
		 * 
		 */		
		public static function getSkin(skinName:String):MovieClip {
			if(skinClassDict == null) {
				skinClassDict = new Dictionary();
				skinClassDict["skin.ChartSkin"] = ChartSkin;
				skinClassDict["skin.AxisSkin"] = AxisSkin;
				skinClassDict["skin.TooltipSkin"] = TooltipSkin;
				skinClassDict["skin.ColumnGraphic"] = ColumnGraphic;
				skinClassDict["skin.BarGraphic"] = BarGraphic;
				skinClassDict["skin.DotGraphic"] = DotGraphic;
			}
			var skin:MovieClip,skinClass:Class;
			if(skinSource != null) {
				skinClass = skinSource.loaderInfo.applicationDomain.getDefinition(skinName) as Class;
			} else {
				skinClass = skinClassDict[skinName] as Class;
			}
			skin = new skinClass() as MovieClip;
			return skin;
		}
		/**
		 * 颜色数组，用于图表图形的绘制
		 */		
		public static var colorCollection:Array = [0xDC3535,0x808080,0x3781DD,0x0EA149,0x8FA42D,0xFF7800,0xE10A5B,0xFFBA00,0x770CEF,0x39CDB3];
		/**
		 * 颜色数组，用于图表图形的绘制
		 */		
		public static var colorCollection2:Array = [0x9B0707,0x5A5959,0x0058C6,0x0E9142,0x7E960E,0xC1610C,0xC4054D,0xEDAE06,0x5E0ABC,0x28B99F];
		
		/**
		 * 颜色数组，用于图表图形的绘制
		 */		
		public static var colorCollection3:Array = [0x710000,0x444444,0x00459B,0x006027,0x687C09,0xD66908,0xA60743,0xDAA006,0x490496,0x12A48A];
	}
}