package com.riameeting.finger.display.skin
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.ReversalAxis;
	import com.riameeting.finger.factory.ObjectFactory;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.ColorUtils;
	import com.riameeting.utils.LineUtils;
	import com.riameeting.utils.StringUtils;
	import flash.geom.Point;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * 我的折线图(区域图)的坐标skin
	 * @author 黄龙
	 */
	public class MyAxisSkin extends AxisSkin
	{
		
		public function MyAxisSkin()
		{
		
		}
		
		override protected function drawBottomContainer(w:Number, h:Number):void 
		{
			graphics.clear();
			var style:Object=hostComponent.style;
			var color1:uint=style["lineColors"][0];
			var color2:uint=style["lineColors"][1];
			var alpha1:Number=style["lineAlphas"][0] / 100;
			var alpha2:Number=style["lineAlphas"][1] / 100;
			var stroke1:uint=style["lineStrokes"][0];
			var stroke2:uint=style["lineStrokes"][1];
			/*var matix:Matrix=new Matrix();
			matix.createGradientBox(w, h, Math.PI / 2);
			graphics.beginGradientFill(GradientType.LINEAR, [color1, color2], [colorAlpha1, colorAlpha2], [0x00, 0xFF], matix);
			graphics.drawRect(style["paddingLeft"], style["paddingTop"], style["lineWidth"], h - style["paddingTop"] - style["paddingBottom"]);
			graphics.drawRect(style["paddingLeft"], h - style["paddingBottom"], w - style["paddingLeft"] - style["paddingRight"], style["lineWidth"]);
			graphics.endFill();*/
			graphics.lineStyle(stroke1,color1,alpha1);
			graphics.moveTo(style["paddingLeft"], style["paddingTop"]-10);
			graphics.lineTo(style["paddingLeft"], h - style["paddingBottom"]+1);
			graphics.lineTo(w - style["paddingRight"]+10, h - style["paddingBottom"]+1);
			graphics.lineStyle(stroke2,color2,alpha2);
		}
		
		override public function updateDisplayList(parms:Object = null):void
		{
			var w:Number = hostComponent.axisWidth, h:Number = hostComponent.axisHeight;
			drawBottomContainer(w, h);
			//create label
			createLabels(w, h);
			//trace(w, h);
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
			if (hostComponent.dataset.config.qualifier != null&&hostComponent.dataset.config.qualifier !=" "&&hostComponent.dataset.config.qualifier !="")
			{
				var qualifierLabel:Label = ObjectFactory.produce(Label, "Label");
				qualifierLabel.color =style["color"];;
				qualifierLabel.text = "(" + hostComponent.dataset.config.qualifier + ")";
				qualifierLabel.x = (style["paddingLeft"] - qualifierLabel.width) * 0.5;
				qualifierLabel.y = int(style["paddingTop"]) - qualifierLabel.height-5;
				labelContainer.addChild(qualifierLabel);
			}
			for (; i < hostComponent.countY; i++)
			{
				currentLabel = ObjectFactory.produce(Label, "Label");
				//currentLabel.height = 20;
				//qualifierLabel.color = 0x666666;
				currentLabel.color = style["color"];
				
				currentLabel.y = Number(style["paddingTop"]) + hostComponent.realGridHeight * i - 10;
				currentLabel.text = StringUtils.numberToUnitString(hostComponent.maxValueY - Number(((hostComponent.maxValueY - hostComponent.minValueY) / hostComponent.countY) * i));
				currentLabel.x = (style["paddingLeft"] - currentLabel.width) * 0.5;
				labelContainer.addChild(currentLabel);
				LineUtils.drawDashed(graphics, new Point(style["paddingLeft"], currentLabel.y + 10), new Point(w - style["paddingRight"], currentLabel.y + 10), 1, 2);
			}
			//Bottom label
			allBottomLabelWidth = 0;
			for (i = 0; i < hostComponent.countX; i++)
			{
				currentLabel = ObjectFactory.produce(Label, "Label");
				//currentLabel.color = 0x666666;
				currentLabel.color = style["color"];
				currentLabel.name = "l" + i;
				if (hostComponent.xField != null)
				{
					currentLabel.text = String(int(((hostComponent.maxValueX - hostComponent.minValueX) / (hostComponent.countX - 1)) * i + hostComponent.minValueX));
				}
				else
				{
					currentLabel.text = hostComponent.dataset.collection[i][hostComponent.dataset.config["categoryField"]];
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
				var count:uint = 0;
				for (i = 0; i < hostComponent.countX; i++)
				{
					var bottomLabel:Label = labelContainer.getChildByName("l" + i) as Label;
					if (count == 0)
					{
						count = hideIndex;
						
						var pX:Number = int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset;
						LineUtils.drawDashed(graphics, new Point(pX, bottomLabel.y - 10), new Point(pX, Number(style["paddingTop"])), 1, 2);
					}
					else
					{
						bottomLabel.visible = false;
						count--;
					}
				}
				//trace(hideIndex)
				for (var j:int = 0; j < hostComponent.countY; j++)
				{
					if (j % 2 == 0)
					{
						for (i = 0; i < hostComponent.countX; i++)
						{
							
							if (i % ((hideIndex+1)*2) == 0)
							{
								graphics.lineStyle(0, 0, 0);
								graphics.beginFill(0xFFFEF6, 1);
								//trace(style["paddingLeft"] + (i) * hostComponent.realGridWidth, int(style["paddingTop"]) + hostComponent.realGridHeight * j)
								if (style["paddingLeft"] + (i) * hostComponent.realGridWidth + hostComponent.realGridWidth * (hideIndex + 1) > w - style["paddingRight"])
								{
									graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth, Number(style["paddingTop"]) + hostComponent.realGridHeight * j , w - style["paddingRight"]-(style["paddingLeft"] + (i) * hostComponent.realGridWidth), hostComponent.realGridHeight);
								}
								else
								{
									graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth, Number(style["paddingTop"]) + hostComponent.realGridHeight * j , hostComponent.realGridWidth*(hideIndex+1)-1, hostComponent.realGridHeight-1);
								}
								graphics.endFill();
							}
						}
						
					}
					else
					{
						graphics.lineStyle(0, 0, 0);
						graphics.beginFill(0xFFFEF6, 1);
						//trace(int(style["paddingTop"]),hostComponent.realGridHeight);
						// trace(this.y,this.parent.y,this.parent.parent.y);
						graphics.drawRect(style["paddingLeft"], int(style["paddingTop"]) + hostComponent.realGridHeight * j, w - style["paddingRight"] - style["paddingLeft"]-1, hostComponent.realGridHeight-1);
						graphics.endFill();
					}
				}
			}
			else
			{
				hideIndex = 0;
				count = 0;
				var dI:int = 0;
				if (ChartGlobal.chartConfig.type == "MyColumnChart"||ChartGlobal.chartConfig.type == "ColumnChart")
				{
					i = 0;
					dI = 1;
				}
				else
				{
					i = 1;
					dI = -1;
				}
				for (i; i < hostComponent.countX; i++)
				{
					bottomLabel = labelContainer.getChildByName("l" + i) as Label;
					pX = int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset;
					LineUtils.drawDashed(graphics, new Point(pX, bottomLabel.y - 10), new Point(pX, Number(style["paddingTop"])), 1, 2);
				}
				//trace(hideIndex)
				for (j = 0; j < hostComponent.countY; j++)
				{
					if (j % 2 == 0)
					{
						for (i = 0; i < hostComponent.countX+dI; i++)
						{
							
							if (i % 2 == 1)
							{
								graphics.lineStyle(0, 0, 0);
								graphics.beginFill(0xFFFEF6, 1);
								graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth+1, Number(style["paddingTop"]) + hostComponent.realGridHeight * j +1, hostComponent.realGridWidth*(hideIndex+1)-2, hostComponent.realGridHeight-2);
								graphics.endFill();
							}
						}
						
					}
					else
					{
						
						for (i = 0; i < hostComponent.countX+dI; i++)
						{
							graphics.lineStyle(0, 0, 0);
							graphics.beginFill(0xFFFEF6, 1);
							graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth+1, Number(style["paddingTop"]) + hostComponent.realGridHeight * j +1, hostComponent.realGridWidth*(hideIndex+1)-2, hostComponent.realGridHeight-2);
							graphics.endFill();
						}
					}
				}
			}
		}
	}

}