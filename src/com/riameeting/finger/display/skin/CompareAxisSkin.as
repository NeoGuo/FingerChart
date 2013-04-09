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
	 * 比较型线图坐标系
	 * @author 黄龙
	 */
	public class CompareAxisSkin extends AxisSkin 
	{
		
		public function CompareAxisSkin() 
		{
			
		}
		
		override public function updateDisplayList(parms:Object = null):void
		{
			var w:Number = hostComponent.axisWidth, h:Number = hostComponent.axisHeight;
			drawBottomContainer(w, h);
			//create label
			createLabels(w, h);
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
		
		/**
		 * 创建需要显示的标签
		 *
		 */
		override protected function createLabels(w:Number, h:Number):void
		{
			var clFleg:Boolean = false;
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
				var qualifierLabel:Label=ObjectFactory.produce(Label, "Label");
				qualifierLabel.text = "(" + hostComponent.dataset.config.qualifier + ")";
				qualifierLabel.x = (style["paddingLeft"] - qualifierLabel.width) * 0.5;
				qualifierLabel.y = int(style["paddingTop"]) - qualifierLabel.height-5;
				labelContainer.addChild(qualifierLabel);
			}
			for (; i < hostComponent.countY; i++)
			{
				currentLabel = ObjectFactory.produce(Label, "Label");
				currentLabel.color = style["color"];
				currentLabel.y = int(style["paddingTop"]) + hostComponent.realGridHeight * i - 10;
				currentLabel.text =StringUtils.numberToUnitString(hostComponent.maxValueY - int(((hostComponent.maxValueY - hostComponent.minValueY) / hostComponent.countY) * i));
				currentLabel.x = (style["paddingLeft"] - currentLabel.width) * 0.5;
				labelContainer.addChild(currentLabel);
				LineUtils.drawDashed(graphics, new Point(style["paddingLeft"], currentLabel.y + 10), new Point(w - style["paddingRight"], currentLabel.y + 10), 1, 2);
					//graphics.moveTo(style["paddingLeft"],currentLabel.y+currentLabel.height/2);
					//graphics.lineTo(w - style["paddingRight"],currentLabel.y+currentLabel.height/2);
			}
			//Bottom label
			allBottomLabelWidth = 0;
			for (i = 0; i < hostComponent.countX; i++)
			{
				currentLabel = ObjectFactory.produce(Label, "Label");
				currentLabel.color = style["color"];
				currentLabel.name = "l" + i;
				if (hostComponent.xField != null)
				{
					currentLabel.text = String(int(((hostComponent.maxValueX - hostComponent.minValueX) / (hostComponent.countX - 1)) * i + hostComponent.minValueX));
				}
				else
				{
					var str:String = hostComponent.dataset.collection[i][hostComponent.dataset.config["categoryField"]];
					
					if (str.search(',') != -1)
					{
						var labelStrArr:Array = [];
						labelStrArr = str.split(",", 10);
						currentLabel.text = labelStrArr[0];
						//currentLabel.y -= 10;
						clFleg = true;
						for (var clI:int = 1; clI < labelStrArr.length; clI++ )
						{
							var currentLabel2:Label=ObjectFactory.produce(Label, "Label");
							currentLabel2.color = style["color"];
							currentLabel2.name = "l2_" + i;
							currentLabel2.text = labelStrArr[clI];
							currentLabel2.x = int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset - currentLabel2.width / 2;
							currentLabel2.y = hostComponent.graphicArea.y + hostComponent.graphicArea.height + 5+12*clI;
							labelContainer.addChild(currentLabel2);
						}
					}
					else
					{
						currentLabel.text = hostComponent.dataset.collection[i][hostComponent.dataset.config["categoryField"]];
					}
				}
				
				currentLabel.x = int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset - currentLabel.width / 2;
				
				if (clFleg == true)
				{
					currentLabel.y = hostComponent.graphicArea.y + hostComponent.graphicArea.height + 5;
				}
				else
				{
					currentLabel.y = hostComponent.graphicArea.y + hostComponent.graphicArea.height + 10;
				}
				
				labelContainer.addChild(currentLabel);
				allBottomLabelWidth += currentLabel.width;
			}
			
			var hideIndex:uint;
			if (allBottomLabelWidth > hostComponent.graphicArea.width)
			{
				hideIndex = allBottomLabelWidth / hostComponent.graphicArea.width;
				var count:uint = 0;
				
				//trace(hideIndex)
				for (var j:int = 0; j < hostComponent.countY; j++)
				{
					if (j % 2 == 0)
					{
						for (i = 0; i < hostComponent.countX; i++)
						{
							
							if (i % ((hideIndex+1)*2) == hideIndex+1)
							{
								graphics.lineStyle(0, 0, 0);
								graphics.beginFill(0xFFFEF6, 1);
								graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth+1, int(style["paddingTop"]) + hostComponent.realGridHeight * j+1 , hostComponent.realGridWidth*(hideIndex+1)-2, hostComponent.realGridHeight-2);
								graphics.endFill();
							}
						}
					}
					else
					{
						for (i = 0; i < hostComponent.countX; i++)
						{
							graphics.lineStyle(0, 0, 0);
							graphics.beginFill(0xFFFEF6, 1);
							var rectWidth:Number = hostComponent.realGridWidth * (hideIndex + 1) - 2;
							if (style["paddingLeft"] + (i) * hostComponent.realGridWidth + 1 + rectWidth > w - style["paddingRight"])
							{
								rectWidth = w - style["paddingRight"] - (style["paddingLeft"] + (i) * hostComponent.realGridWidth + 1 + rectWidth);
							}
							graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth+1, int(style["paddingTop"]) + hostComponent.realGridHeight * j +1,rectWidth, hostComponent.realGridHeight-2);
							graphics.endFill();
						}
						//graphics.lineStyle(0, 0, 0);
						//graphics.beginFill(0xFFFEF6, 1);
						//graphics.drawRect(style["paddingLeft"], int(style["paddingTop"]) + hostComponent.realGridHeight * j, w - style["paddingRight"] - style["paddingLeft"], hostComponent.realGridHeight);
						//graphics.endFill();
					}
				}
				
				for (i = 1; i < hostComponent.countX; i++)
				{
					var bottomLabel:Label = labelContainer.getChildByName("l" + i) as Label;
					var bottomLabel2:Label = labelContainer.getChildByName("l2_" + i) as Label;
					if (count ==hideIndex)
					{
						count = 0;
						var pX:Number = int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset;
						LineUtils.drawDashed(graphics, new Point(pX, bottomLabel.y - 10), new Point(pX, int(style["paddingTop"])), 1, 2);
					}
					else
					{
						bottomLabel.visible = false;
						if (bottomLabel2 != null)
						{
							bottomLabel2.visible = false;
						}
						count++;
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
								graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth+1, int(style["paddingTop"]) + hostComponent.realGridHeight * j+1 , hostComponent.realGridWidth*(hideIndex+1)-2, hostComponent.realGridHeight-2);
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
								graphics.drawRect(style["paddingLeft"] + (i) * hostComponent.realGridWidth+1, int(style["paddingTop"]) + hostComponent.realGridHeight * j +1, hostComponent.realGridWidth*(hideIndex+1)-2, hostComponent.realGridHeight-2);
								graphics.endFill();
						}
						/*graphics.lineStyle(0, 0, 0);
						graphics.beginFill(0xFFFEF6, 1);
						graphics.drawRect(style["paddingLeft"], int(style["paddingTop"]) + hostComponent.realGridHeight * j, w - style["paddingRight"] - style["paddingLeft"], hostComponent.realGridHeight);
						graphics.endFill();*/
					}
				}
				
				for (i; i < hostComponent.countX; i++)
				{
					bottomLabel = labelContainer.getChildByName("l" + i) as Label;
					pX = int(style["paddingLeft"]) + hostComponent.realGridWidth * i + currentOffset;
					LineUtils.drawDashed(graphics, new Point(pX, bottomLabel.y - 10), new Point(pX, int(style["paddingTop"])), 1, 2);
				}
			}
			
		}
	}

}