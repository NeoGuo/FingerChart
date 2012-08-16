package com.riameeting.finger.component
{
	import com.riameeting.finger.display.axis.*;
	import com.riameeting.finger.display.chart.AbstractChart;
	import com.riameeting.finger.display.container.*;
	import com.riameeting.finger.display.graphic.*;
	import com.riameeting.finger.display.tooltip.Tooltip;
	import com.riameeting.finger.effect.*;

	/**
	 * 组件：区域图
	 * 
	 * @example var areaChart:AreaChart = new AreaChart();
	 * @see AbstractChart
	 * @author Finger
	 */	
	public class AreaChart extends AbstractChart
	{
		public function AreaChart(width:uint, height:uint)
		{
			axis = new BasicAxis(this,false);
			chartGraphicContainer = new ChartGraphicContainer(this,AreaGraphic,"AreaGraphic",LineGraphic,false,new MoveIn(),new MoveOut());
			tooltipContainer = new TooltipContainer(this,Tooltip);
			pluginContainer = new PluginContainer(this);
			super(axis, chartGraphicContainer, tooltipContainer, pluginContainer, width, height);
		}
	}
}