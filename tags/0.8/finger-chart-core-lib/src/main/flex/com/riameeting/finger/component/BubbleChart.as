package com.riameeting.finger.component
{
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;
	/**
	 * 组件：气泡图
	 * @author Finger
	 * 
	 */	
	public class BubbleChart extends AbstractChart
	{
		public function BubbleChart(width:uint, height:uint)
		{
			axis = new BasicAxis(this);
			chartGraphicContainer = new ChartGraphicContainer(this,BubbleGraphic,"BubbleGraphic",LineGraphic,true,new MoveIn(),new MoveOut());
			tooltipContainer = new TooltipContainer(this,Tooltip);
			pluginContainer = new PluginContainer(this);
			super(axis, chartGraphicContainer, tooltipContainer, pluginContainer, width, height);
		}
	}
}