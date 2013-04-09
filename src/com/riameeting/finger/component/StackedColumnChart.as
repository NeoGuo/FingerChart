package com.riameeting.finger.component 
{
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;
	import ui.ColumnChartTooltipSkin;
	import com.riameeting.finger.config.ChartGlobal;
	
	/**
	 * 堆栈图
	 * @author 黄龙
	 */
	public class StackedColumnChart extends AbstractChart
	{
		public var setTimeStackedFleg:Boolean = false;
		public function StackedColumnChart(width:uint, height:uint) 
		{
			ChartGlobal.getSkin("skin.TooltipSkin");
			ChartGlobal.skinClassDict["skin.TooltipSkin"] = ColumnChartTooltipSkin;
			axis = new StackedAxis(this,true);
			chartGraphicContainer = new ChartGraphicContainer(this,StackedColumnGraphic,"StackedColumnGraphic",LineGraphic,false,new FadeIn(),new FadeOut());
			tooltipContainer = new Pie3DTooltipContaniner(this,Tooltip);
			pluginContainer = new PluginContainer(this);
			super(axis, chartGraphicContainer, tooltipContainer, pluginContainer, width, height);
		}
		
	}

}