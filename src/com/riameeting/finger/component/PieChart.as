package com.riameeting.finger.component
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;
	import ui.PieChart3DTooltipSkin;
	
	/**
	 * 组件：饼图(横向)
	 * @author Finger
	 * 
	 */	
	public class PieChart extends AbstractChart
	{
		public function PieChart(width:uint, height:uint)
		{
			
			ChartGlobal.getSkin("skin.TooltipSkin");
			ChartGlobal.skinClassDict["skin.TooltipSkin"] = PieChart3DTooltipSkin;
			axis = new PieAxis(this,true);
			chartGraphicContainer = new ChartGraphicContainer(this,PieGraphic,"PieGraphic",LineGraphic,true,new FadeIn(),new FadeOut());
			tooltipContainer = new Pie3DTooltipContaniner(this,Tooltip,"byp");
			pluginContainer = new PluginContainer(this);
			super(axis, chartGraphicContainer, tooltipContainer, pluginContainer, width, height);
		}
	}
}