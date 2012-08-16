package com.riameeting.finger.component
{
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;
	/**
	 * 组件：柱图
	 * @author Finger
	 * 
	 */	
	public class ColumnChart extends AbstractChart
	{
		public function ColumnChart(width:uint, height:uint)
		{
			axis = new BasicAxis(this,true);
			chartGraphicContainer = new ChartGraphicContainer(this,ColumnGraphic,"ColumnGraphic",LineGraphic,false,new MoveIn(),new MoveOut());
			tooltipContainer = new TooltipContainer(this,Tooltip);
			pluginContainer = new PluginContainer(this);
			super(axis, chartGraphicContainer, tooltipContainer, pluginContainer, width, height);
		}
	}
}