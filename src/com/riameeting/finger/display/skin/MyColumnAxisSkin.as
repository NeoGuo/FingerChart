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
	import ghostcat.debug.Debug;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * 我的柱状图的坐标skin
	 * @author 黄龙
	 */
	public class MyColumnAxisSkin extends AxisSkin
	{
		
		public function MyColumnAxisSkin() 
		{
			
		}
		
		override public function updateDisplayList(parms:Object = null):void
		{
			var w:Number = hostComponent.axisWidth, h:Number = hostComponent.axisHeight;
			drawBottomContainer(w, h);
			//create label
			createLabels(w, h);
		}
		
		/**
		 * 创建需要显示的标签
		 *
		 */
		override protected function createLabels(w:Number, h:Number):void
		{
			var style:Object = hostComponent.style;
			//left label
			var i:uint = 0, currentLabel:Label;
			hostComponent.realGridHeight = hostComponent.graphicArea.height / hostComponent.countY;
			var currentOffset:Number = hostComponent.ignoreOffsetV ? style["offsetH"] : style["offsetV"];
			if (hostComponent.countX == 1) 
			{ 
				hostComponent.realGridWidth = (hostComponent.graphicArea.width - currentOffset * 2) / 2;
			}
			else
			{
				hostComponent.realGridWidth = (hostComponent.graphicArea.width - currentOffset * 2) / (hostComponent.countX - 1);
			}
			var maxLabelWidth:Number = style["paddingTop"];
			for (; i < hostComponent.countY; i++)
			{
				currentLabel = ObjectFactory.produce(Label, "Label");
				currentLabel.color = style["color"];
				
				currentLabel.y = Number(style["paddingTop"]) + hostComponent.realGridHeight * i - 10;
				currentLabel.text = StringUtils.numberToUnitString(hostComponent.maxValueY - Number(((hostComponent.maxValueY - hostComponent.minValueY) / hostComponent.countY) * i));
				if (hostComponent.dataset.config.qualifier != null&&hostComponent.dataset.config.qualifier !=" "&&hostComponent.dataset.config.qualifier !="")
				{
					currentLabel.text += hostComponent.dataset.config.qualifier;
				}
				if (currentLabel.width > maxLabelWidth)
				{
					maxLabelWidth = currentLabel.width;
				}
				currentLabel.x = Number(style["paddingLeft"]) - currentLabel.width - 5;
				labelContainer.addChild(currentLabel);
				LineUtils.drawDashed(graphics, new Point(style["paddingLeft"], currentLabel.y + 10), new Point(w - style["paddingRight"], currentLabel.y + 10), 1, 2);
					//graphics.moveTo(style["paddingLeft"],currentLabel.y+currentLabel.height/2);
					//graphics.lineTo(w - style["paddingRight"],currentLabel.y+currentLabel.height/2);
			}
			if (maxLabelWidth>Number(style["paddingLeft"]))
			{
				style["paddingLeft"] = maxLabelWidth+5;
				hostComponent.chartRef.updateDisplayList();
				return;
			}
			//Bottom label
			allBottomLabelWidth = 0;
			for (i = 0; i < hostComponent.countX; i++)
			{
				currentLabel = ObjectFactory.produce(Label, "Label", [true]);
				
				currentLabel.color = style["color"];
				currentLabel.name = "l" + i;
				if (hostComponent.xField != null)
				{
					currentLabel.text = String(int(((hostComponent.maxValueX - hostComponent.minValueX) / (hostComponent.countX - 1)) * i + hostComponent.minValueX));
				}
				else
				{
					currentLabel.htmlMode = true;
					currentLabel.text ="<b>"+hostComponent.dataset.collection[i][hostComponent.dataset.config["categoryField"]]+"</b>";
				}
				
				currentLabel.x = int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset - currentLabel.width / 2;
				currentLabel.y = hostComponent.graphicArea.y + hostComponent.graphicArea.height + 10;
				
				labelContainer.addChild(currentLabel);
				allBottomLabelWidth += currentLabel.width;
			}
			
			var hideIndex:uint;
			if (allBottomLabelWidth > hostComponent.graphicArea.width)
			{
				hideIndex = allBottomLabelWidth / hostComponent.graphicArea.width;
				//Debug.trace("间隔", hideIndex);
				var count:uint = 0;
				var pX:Number;
				for (i = 1; i < hostComponent.countX; i++)
				{
					var bottomLabel:Label = labelContainer.getChildByName("l" + i) as Label;
					//Debug.trace("间隔",count ,hideIndex);
					//Debug.trace("间隔", i,hostComponent.countX);
					if (count == hideIndex)
					{
						count = 0;
						pX = int(style["paddingLeft"]) + hostComponent.realGridWidth * (i-1) + currentOffset;
						//LineUtils.drawDashed(graphics, new Point(pX, bottomLabel.y - 10), new Point(pX, Number(style["paddingTop"])), 1, 2);
					}
					else
					{
						
						bottomLabel.visible = false;
						count++;
					}
				}
				
				/*if (hostComponent.countX % (hideIndex + 1) == 0)
				{
					pX = int(style["paddingLeft"]) + hostComponent.realGridWidth * (hostComponent.countX-1) + currentOffset;
					LineUtils.drawDashed(graphics, new Point(pX, bottomLabel.y - 10), new Point(pX, Number(style["paddingTop"])), 1, 2);
				}*/
				
				//pX = int(style["paddingLeft"]) + hostComponent.realGridWidth * (hostComponent.countX-1) + currentOffset;
				//LineUtils.drawDashed(graphics, new Point(pX, bottomLabel.y - 10), new Point(pX, int(style["paddingTop"])), 1, 2);
				
				//trace(hideIndex)
				/*for (var j:int = 0; j < hostComponent.countY; j++)
				{
					if (j % 2 == 0)
					{
						for (i = 0; i < hostComponent.countX; i++)
						{
							//trace(i,hideIndex);
							if (i %((hideIndex+1)*2) == hideIndex+1)
							{
								graphics.lineStyle(0, 0, 0);
								graphics.beginFill(0xFF80C0, 0.05);
								graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth, Number(style["paddingTop"]) + hostComponent.realGridHeight * j , hostComponent.realGridWidth*(hideIndex+1), hostComponent.realGridHeight);
								graphics.endFill();
							}
						}
						
						if (hostComponent.countX % (hideIndex*2+2) == hideIndex+1)
						{
							graphics.lineStyle(0, 0, 0);
							graphics.beginFill(0xFF80C0, 0.05);
							graphics.drawRect(style["paddingLeft"] + (hostComponent.countX) * hostComponent.realGridWidth, Number(style["paddingTop"]) + hostComponent.realGridHeight * j , hostComponent.realGridWidth, hostComponent.realGridHeight);
							graphics.endFill();
						}
					}
					else
					{
						graphics.lineStyle(0, 0, 0);
						graphics.beginFill(0xFF80C0, 0.05);
						graphics.drawRect(style["paddingLeft"], int(style["paddingTop"]) + hostComponent.realGridHeight * j, w - style["paddingRight"] - style["paddingLeft"], hostComponent.realGridHeight);
						graphics.endFill();
					}
				}*/
			}
			else
			{
				hideIndex = 0;
				count = 0;
				/*for (i = 0; i < hostComponent.countX; i++)
				{
					bottomLabel = labelContainer.getChildByName("l" + i) as Label;
					pX = int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset;
					LineUtils.drawDashed(graphics, new Point(pX, bottomLabel.y - bottomLabel.height*0.5), new Point(pX, Number(style["paddingTop"])), 1, 2);
				}*/
				//trace(hideIndex)
				/*for (j = 0; j < hostComponent.countY; j++)
				{
					if (j % 2 == 0)
					{
						for (i = 0; i < hostComponent.countX; i++)
						{
							
							if (i % 2 == 1)
							{
								graphics.lineStyle(0, 0, 0);
								graphics.beginFill(0xFF80C0, 0.05);
								graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth, Number(style["paddingTop"]) + hostComponent.realGridHeight * j , hostComponent.realGridWidth*(hideIndex+1), hostComponent.realGridHeight);
								graphics.endFill();
							}
						}
						
						if (hostComponent.countX % 2 == 1)
						{
							graphics.lineStyle(0, 0, 0);
							graphics.beginFill(0xFF80C0, 0.05);
							graphics.drawRect(style["paddingLeft"] + (hostComponent.countX) * hostComponent.realGridWidth, Number(style["paddingTop"]) + hostComponent.realGridHeight * j , hostComponent.realGridWidth*(hideIndex+1), hostComponent.realGridHeight);
							graphics.endFill();
						}
					}
					else
					{
						graphics.lineStyle(0, 0, 0);
						graphics.beginFill(0xFF80C0, 0.05);
						graphics.drawRect(style["paddingLeft"], int(style["paddingTop"]) + hostComponent.realGridHeight * j, w - style["paddingRight"] - style["paddingLeft"], hostComponent.realGridHeight);
						graphics.endFill();
					}
				}*/
			}
			
			var geWH:int = 20;
			//var lenX:int = hostComponent.graphicArea.height / geWH;
			var lenY:int = hostComponent.graphicArea.width / geWH;
			var j:int = 0;
			graphics.lineStyle(1, 0xE5E5E5, 1);
			/*for (i = 0; i <= lenX; i++)
			{
				//graphics.moveTo(style["paddingLeft"], style["paddingTop"] + i * 30);
				DrawTool.dotLineTo(graphics, style["paddingLeft"], style["paddingTop"] + i * geWH, hostComponent.graphicArea.width+style["paddingLeft"], style["paddingTop"] + i * geWH, 1);
				//graphics.lineTo(style["paddingLeft"],style["paddingTop"]+i*30);
			}*/
			
			for (j = 1; j <= lenY; j++)
			{
				DrawTool.dotLineTo(graphics, style["paddingLeft"]+ j * geWH, style["paddingTop"], style["paddingLeft"]+ j * geWH, style["paddingTop"]+hostComponent.graphicArea.height, 1);
			}
		}
	}

}