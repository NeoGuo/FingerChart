package com.riameeting.finger.component
{
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;
	/**
	 * 组件：柱图(横向)
	 * @author Finger
	 * 
	 */	
	public class BarChart extends AbstractChart
	{
		public function BarChart(width:uint, height:uint)
		{
			axis = new ReversalAxis(this,true);
			chartGraphicContainer = new ChartGraphicContainer(this,BarGraphic,"BarGraphic",LineGraphic,false,new MoveIn(),new MoveOut());
			tooltipContainer = new TooltipContainer(this,Tooltip,"byy");
			pluginContainer = new PluginContainer(this);
			super(axis, chartGraphicContainer, tooltipContainer, pluginContainer, width, height);
		}
	}
}