package com.riameeting.finger.display.skin 
{
	import com.riameeting.finger.display.axis.ReversalAxis;
	import com.riameeting.finger.factory.ObjectFactory;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.ColorUtils;
	import com.riameeting.utils.DrawTool;
	import com.riameeting.utils.LineUtils;
	import com.riameeting.utils.StringUtils;
	import flash.geom.Point;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * 横向坐标系皮肤
	 * @author 黄龙
	 */
	public class HorizontalAxisSkin extends AxisSkin
	{
		
		public function HorizontalAxisSkin() 
		{
			
		}
		
		override public function updateDisplayList(parms:Object = null):void
		{
			var w:Number = hostComponent.axisWidth, h:Number = hostComponent.axisHeight;
			//hostComponent.style['paddingLeft'] = 120;
			drawBottomContainer(w, h);
			//create label
			createLabels(w, h);
		}
		
		override protected function createLabels(w:Number, h:Number):void 
		{
			
			var style:Object=hostComponent.style;
			//left label
			var i:uint=0, currentLabel:Label;
			hostComponent.realGridHeight=hostComponent.graphicArea.height / (hostComponent.countX+1);
			//var currentOffset:Number=hostComponent.ignoreOffsetV ? style["offsetH"] : style["offsetV"];
			hostComponent.realGridWidth=(hostComponent.graphicArea.width) / (hostComponent.countY);
			/*for (; i < hostComponent.countY; i++)
			{
				currentLabel=ObjectFactory.produce(Label, "Label");
				currentLabel.color = style["color"];
				currentLabel.text=StringUtils.numberToUnitString(hostComponent.maxValueY - int(((hostComponent.maxValueY - hostComponent.minValueY) / hostComponent.countY) * i));
				labelContainer.addChild(currentLabel);
				currentLabel.x=int(style["paddingLeft"]) + hostComponent.realGridWidth * (hostComponent.countY-i)  - currentLabel.width / 2;
				currentLabel.y=hostComponent.graphicArea.y + hostComponent.graphicArea.height + 10;
				//currentLabel.y=int(style["paddingTop"]) + hostComponent.realGridHeight * i - currentLabel.height / 2;
				//graphics.moveTo(style["paddingLeft"],currentLabel.y+currentLabel.height/2);
				//graphics.lineTo(w - style["paddingRight"],currentLabel.y+currentLabel.height/2);
			}*/
			//Bottom label
			allBottomLabelWidth=0;
			for (i=0; i < hostComponent.countX; i++)
			{
				currentLabel=ObjectFactory.produce(Label, "Label");
				currentLabel.color=style["color"];
				currentLabel.name="l" + i;
				if (hostComponent.xField != null)
				{
					currentLabel.text=StringUtils.numberToUnitString(int(((hostComponent.maxValueX - hostComponent.minValueX) / (hostComponent.countX - 1)) * i + hostComponent.minValueX));
				}
				else
				{
					currentLabel.text=hostComponent.dataset.collection[i][hostComponent.dataset.config["categoryField"]];
				}
				//currentLabel.x=int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset - currentLabel.width / 2;
				//currentLabel.y=hostComponent.graphicArea.y + hostComponent.graphicArea.height + 10;
				currentLabel.x = style["paddingLeft"] - currentLabel.width;
				currentLabel.y=int(style["paddingTop"]) + hostComponent.realGridHeight * i - currentLabel.height*0.5+hostComponent.realGridHeight;
				labelContainer.addChild(currentLabel);
				allBottomLabelWidth+=currentLabel.width;
			}
			if (allBottomLabelWidth > hostComponent.graphicArea.width)
			{
				var hideIndex:uint=allBottomLabelWidth / hostComponent.graphicArea.width;
				var count:uint=0;
				for (i=1; i < hostComponent.countX; i++)
				{
					var bottomLabel:Label = labelContainer.getChildByName("l" + i) as Label;
					if (count == hideIndex)
					{
						count=0;
					}
					else
					{
						bottomLabel.visible=false;
						count++;
					}
				}
			}
			var geWH:int = 20;
			var lenX:int = hostComponent.graphicArea.height / geWH;
			var lenY:int = hostComponent.graphicArea.width / geWH;
			var j:int = 0;
			graphics.lineStyle(1, 0xC0C0C0);
			for (i = 0; i <= lenX; i++)
			{
				//graphics.moveTo(style["paddingLeft"], style["paddingTop"] + i * 30);
				DrawTool.dotLineTo(graphics, style["paddingLeft"], style["paddingTop"] + i * geWH, hostComponent.graphicArea.width+style["paddingLeft"], style["paddingTop"] + i * geWH, 1);
				//graphics.lineTo(style["paddingLeft"],style["paddingTop"]+i*30);
			}
			
			for (j = 1; j <= lenY; j++)
			{
				DrawTool.dotLineTo(graphics, style["paddingLeft"]+ j * geWH, style["paddingTop"], style["paddingLeft"]+ j * geWH, style["paddingTop"]+hostComponent.graphicArea.height, 1);
			}
			
		}
	}

}