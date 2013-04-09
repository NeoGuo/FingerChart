package com.riameeting.finger.display.container 
{
	import com.greensock.TweenLite;
	import com.riameeting.controler.EventBus;
	import com.riameeting.finger.component.PieChart3D;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.graphic.IChartGraphic;
	import com.riameeting.finger.display.graphic.PieGraphic3D;
	import com.riameeting.finger.display.skin.ISkin;
	import com.riameeting.finger.display.tooltip.ITooltip;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.utils.NumberTool;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	/**
	 * 爱彩票鼠标容器
	 * @author 黄龙
	 */
	public class LineChartTooltipContainer extends TooltipContainer implements ITooltipContainer 
	{
		private var firstFleg:Boolean = false;
		public function LineChartTooltipContainer(chartRef:IChart, tooltipClass:Class, checkType:String="byx") 
		{
			super(chartRef,tooltipClass,checkType);
		}
		
		override protected function containerMouseHandler(e:MouseEvent):void 
		{
			if (mouseX < axisRect.x || mouseX > (axisRect.x + axisRect.width) || mouseY < axisRect.y || mouseY > (axisRect.y + axisRect.height))
			{
				tooltip.hide();
				clear();
				return;
			}
			
			clear();
			var nearlyGraphic:IChartGraphic=graphicsCollection[0];
			var nextGraphic:IChartGraphic, mousePoint:Point=new Point(), targetPoint:Point=new Point(), prevPoint:Point=new Point();
			prevPoint.x=nearlyGraphic.x + nearlyGraphic.center.x;
			prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
			var fleg:Boolean = false;
			for each (nextGraphic in graphicsCollection)
			{
				nextGraphic.state=MouseEvent.MOUSE_OUT;
				mousePoint.x=mouseX;
				mousePoint.y=mouseY;
				targetPoint.x=nextGraphic.x + nextGraphic.center.x;
				targetPoint.y = nextGraphic.y + nextGraphic.center.y;
				if (NumberTool.getPointDistance(mousePoint, targetPoint) < 10)
				{
					nearlyGraphic=nextGraphic;
					prevPoint.x=nearlyGraphic.x + nearlyGraphic.center.x;
					prevPoint.y = nearlyGraphic.y + nearlyGraphic.center.y;
					fleg = true;
					break;
				}
			}
			if (fleg == false) { return };
			
			
			nearlyGraphic.state=MouseEvent.MOUSE_OVER;
			var seriel:Sprite = (nearlyGraphic as DisplayObject).parent as Sprite;
			if (!nearlyGraphic is PieGraphic3D)
			{
				seriel.swapChildren(nearlyGraphic as DisplayObject, seriel.getChildAt(seriel.numChildren - 1));
			}
			var tipStr:String=nearlyGraphic.data.tipString[nearlyGraphic.yField];
			tooltip.show(tipStr);
			locateTooltip(nearlyGraphic.x + nearlyGraphic.center.x, nearlyGraphic.y + nearlyGraphic.center.y);
		}
		
		/**
		 * 将鼠标提示定位到相应的位置
		 * @param xValue x值
		 * @param yValue y值
		 *
		 */
		protected override function locateTooltip(xValue:Number, yValue:Number):void
		{
			tooltip.skin.updateDisplayList({ltx:xValue,lty:yValue});
			tooltip.x = xValue;
			tooltip.y = yValue;
			
			//TweenLite.to(tooltip, 0.2, {x: xValue, y: yValue});
			return;
			
			if (tooltip.x == 0 && tooltip.y == 0)
			{
				tooltip.x=xValue;
				tooltip.y=yValue;
			}
			var targetX:Number=xValue;
			var targetY:Number=yValue;
			if (targetX + tooltip.width > axisRect.x + axisRect.width)
			{
				targetX=xValue - tooltip.width - 20;
			}
			if (targetY + tooltip.height > axisRect.y + axisRect.height)
			{
				targetY=axisRect.y + axisRect.height - tooltip.height;
			}
			//TweenLite.to(tooltip, 0.2, {x: targetX, y: targetY});
		}
		
	}

}