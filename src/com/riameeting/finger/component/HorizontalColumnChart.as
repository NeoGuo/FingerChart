package com.riameeting.finger.component 
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;
	import ui.ColumnChartTooltipSkin;
	/**
	 * ...
	 * @author 黄龙
	 */
	public class HorizontalColumnChart extends AbstractChart
	{
		
		public function HorizontalColumnChart(width:uint, height:uint) 
		{
			ChartGlobal.getSkin("skin.TooltipSkin");
			ChartGlobal.skinClassDict["skin.TooltipSkin"] = ColumnChartTooltipSkin;
			axis = new HorizontalAxis(this,true);
			chartGraphicContainer = new ChartGraphicContainer(this,HorizontalColumnGraphic,"HorizontalColumnGraphic",LineGraphic,false,new FadeIn(),new FadeOut());
			tooltipContainer = new Pie3DTooltipContaniner(this,Tooltip,'byy');
			pluginContainer = new PluginContainer(this);
			super(axis, chartGraphicContainer, tooltipContainer, pluginContainer, width, height);
		}
		
	}

}