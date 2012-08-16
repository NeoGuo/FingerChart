package com.riameeting.finger.config
{
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.skin.*;
	
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
		public static const version:String = "0.8";
		
		/**
		 * 最后更新日期
		 */		
		public static const buildDate:String = "2010-12-26";
		/**
		 * 皮肤源
		 */		
		public static var skinSource:MovieClip;
		/**
		 * 图表引用
		 */		
		private static var skinClassDict:Dictionary;
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
		public static var colorCollection:Array = [0xff0000,0xff0078,0xff00d2,0x9c00ff,0x0c00ff,0x00a2ff,0x09c700,0xe7b300,0xe75c00];
	}
}