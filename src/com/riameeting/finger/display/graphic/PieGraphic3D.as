package com.riameeting.finger.display.graphic
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.DrawTool;
	import com.riameeting.utils.ObjectUtils;
	import com.riameeting.utils.StringUtils;
	import flash.display.GradientType;
	import flash.utils.setTimeout;
	import ghostcat.debug.Debug;
	import ghostcat.game.util.GameTickTimeout;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
	/**
	 * 3D饼图图形
	 * @author 黄龙
	 */
	public class PieGraphic3D extends PieGraphic
	{
		
		public function PieGraphic3D(chartRef:IChart)
		{
			super(chartRef);
		}
		
		override public function locate(value:Point = null, offset:uint = 0):void
		{
			if (value != null)
				point = value;
			x = point.x;
			y = point.y;
			_x0 = x;
			_y0 = y;
			_h = 10;
			
			if (chartRef.dataset.config.labelArr == null) { chartRef.dataset.config.labelArr = [[], []]; }
			
			locatePoint = value;
			var axis:IAxis = chartRef.axis;
			var axisRect:Rectangle = chartRef.axis.getAxisRect();
			//sector
			var angleObj:Object = axis.getAngle(data, yField);
			//trace(angleObj.beginAngle);
			var r:Number = (axisRect.width < axisRect.height) ? (axisRect.width / 2-50  + offset) : (axisRect.height / 2-50  + offset);
			if (stage.height == 300)
			{
				r = 70 / 0.75;
			}
			_a = r;
			_b = r * 0.75;
			var lastAngel:Number = angleObj.angle;
			if (angleObj.angle < 0.5)
			{
				angleObj.angle = 0.5
			}
			center = drawSector3D(graphics, new Point(0, 0), r, angleObj.beginAngle, angleObj.angle, 0xFFFFFF, 1, 1, color, 0);
			angleObj.angle = lastAngel;
			if (data["tipString"] == null)
				data["tipString"] = {};
			data["tipString"][yField] = "";
			var categoryField:String = chartRef.dataset.config["categoryField"];
			//data["tipString"][yField] += "<b><font color='#" + color.toString(16) + "'>" + data[categoryField] + "</font></b><br/>";
			data["tipString"][yField] += "<b><font color='#FFFFFF'>" + data[categoryField] + "</font></b><br/>";
			var yTitle:String = chartRef.dataset.config["yTitle"];
			data["tipString"][yField] += yTitle + "" + ((angleObj.angle / 360) * 100).toFixed(2) + "%\n";
			if (data[yField + "_tooltext"])
			{
				data["tipString"][yField] += data[yField + "_tooltext"];
			}
			else
			{
				data["tipString"][yField] += data[yField];
				if (chartRef.dataset.config["qualifier"])
				{
					data["tipString"][yField] += chartRef.dataset.config["qualifier"];
				}
			}
			if (chartRef.chartConfig["graphicLabel"] != "hidden")
			{
				if (chartRef.chartConfig["graphicLabel"] == "first" && chartRef.dataset.collection.indexOf(data) != 0)
				{
					return;
				}
				if (angleObj.angle >= 50)
				{
					label.htmlMode = true;
					label.setFontSize(11);
					label.text = "<b>" + data[categoryField] + "</b>\n";
					if (data[yField + "_tooltext"])
					{
						label.text += data[yField + "_tooltext"];
					}
					else
					{
						label.text += StringUtils.fomart(data[yField]);
						if (chartRef.dataset.config["qualifier"])
						{
							label.text += chartRef.dataset.config["qualifier"];
						}
					}
					label.text+="\n"+((angleObj.angle / 360) * 100).toFixed(2) + "%";
					label.x = center.x*1.2 - label.width * 0.5;
					label.y = center.y*1.2 - label.height * 0.5;
					label.visible = true;
					label.color = 0xFFFFFF;
				}
				else
				{
					label.setFontSize(11);
					//graphics.lineStyle(1, 0xE0E0E0, 1);
					//graphics.moveTo(center.x * 2, center.y * 2);
					label.x = center.x * 2.2;
					label.y = center.y * 2.2 - label.height;
					if (label.x < 0)
					{
						if ((chartRef.dataset.config.labelArr[0] as Array).indexOf(label) == -1)
						{
							chartRef.dataset.config.labelArr[0].push(label);
						}
					}
					else
					{
						if ((chartRef.dataset.config.labelArr[1] as Array).indexOf(label) == -1)
						{
							chartRef.dataset.config.labelArr[1].push(label);
						}
					}
					
					label.color = 0x000000;
					label.text = data[categoryField] + " " + ((angleObj.angle / 360) * 100).toFixed(2) + "%";
					label.visible = true;
					
					
					/*if (center.x <= 0)
					{
						label.x -= label.width;
						//label.x -= label.localToGlobal(new Point(0, 0)).x - 20;
						if (label.localToGlobal(new Point(0, 0)).x < 10)
						{
							label.x -= label.localToGlobal(new Point(0, 0)).x - 10;
						}
					}*/
					Debug.trace("label宽高", label.width, label.height);
					//label.hitArea
					/*checkHitTest();*/
					
					/*if (center.x > 0)
					{
						//label.x = axis.width-label.width-20;
						graphics.lineTo(label.x - 1, label.y + label.height * 0.5);
						graphics.lineTo(label.x+2, label.y + label.height * 0.5);
					}
					else
					{
						graphics.lineTo(label.x + label.width+1, label.y + label.height * 0.5);
						graphics.lineTo(label.x + label.width-2, label.y + label.height * 0.5);
					}*/
					
					
					/*if (ChartGlobal.labelArr.indexOf(label) == -1)
					{
						ChartGlobal.labelArr.push(label);
					}*/
					GameTickTimeout.setTimeout(drawLabel,250,angleObj, categoryField, yTitle,r);
				}
			}
			if (chartRef['setTimeFleg'] == false)
			{
				setTimeout(mySetDepths, 100);
				chartRef['setTimeFleg'] = true;
			}
			x += center.x / 5;
			y += center.y/ 5;
			locatePoint.x = x;
			locatePoint.y = y;
			/*if (this.contains(label) == false)
			{
				this.addChild(label);
			}*/
			//setTimeout(labelToLocal, 1000);
		}
		
		private var drawLabelFleg:Boolean = false;
		public function drawLabel(angleObj:Object,categoryField:String,yTitle:String,r:Number):void
		{
			if (ChartGlobal.drawOver == false)
			{
				GameTickTimeout.setTimeout(drawLabel, 50, angleObj, categoryField, yTitle,r);
				return;
			}
			if(drawLabelFleg){return}
			
			drawLabelFleg = true;
			if (chartRef.dataset.config["showOutLabel"] != "0")
			{
				if (chartRef.chartConfig["graphicLabel"] == "first" && chartRef.dataset.collection.indexOf(data) != 0) 
				{
					return;
				}
				//graphics.clear();
				graphics.lineStyle(1,_color,1);
				graphics.moveTo(center.x*1.9,center.y*1.9);
				label.visible = true;
				trace("圆,标签位置", r, label.x, label.y);
				if (center.x > 0)
				{
					label.x = r+10;
				}
				else
				{
					label.x = -r-5 - label.width;
				}
				if (center.x > 0)
				{
					graphics.lineTo(label.x-11,label.y+ label.height * 0.5);
					graphics.lineTo(label.x-1, label.y + label.height * 0.5);
				}
				else
				{
					graphics.lineTo(label.x + label.width+5,label.y + label.height * 0.5);
					graphics.lineTo(label.x + label.width-5, label.y + label.height * 0.5);
				}
			}
		}
		
		private var labelLocalFleg:Boolean = false;
		public function labelToLocal():void
		{
			if (labelLocalFleg)
			{
				return;
			}
			labelLocalFleg = true;
			var labelPoint:Point = new Point(label.x, label.y);
			var labelPointGlobal:Point = this.localToGlobal(labelPoint);
			label.x = labelPointGlobal.x;
			label.y = labelPointGlobal.y;
			trace(label.x, label.y);
			if (this.contains(label))
			{
				this.removeChild(label);
			}
			stage.addChild(label);
		}
		
		public function checkHitTest():void
		{
			var i:int = 0;
			var lArr:Array = ChartGlobal.labelArr;
			var len:int = lArr.length;
			var checkFleg:Boolean = false;
			for (i = 0; i < len; i++)
			{
				if (label.hitTestObject(lArr[i]))
				{
					label.y = lArr[len-1].y;
					checkLabelY();
					break;
				}
			}
		}
		
		public function checkLabelY():void
		{
			var i:int = 0;
			var lArr:Array = ChartGlobal.labelArr;
			var len:int = lArr.length;
			var checkFleg:Boolean = false;
			var basePoint:Point = new Point(0, 0);
			// label.localToGlobal(new Point()), label.width, label.height);
			var p1:Point = label.localToGlobal(basePoint);
			var p2:Point;
			//var fle
			for (i = 0; i < len; i++)
			//if(len>0)
			{
				//i = len - 1;
				//TODO::循环计算是否叠加，如果叠加就移动位置
				//Debug.trace("label",label.x,label.y,lArr[i].x,lArr[i].y);
				p2 = lArr[i].localToGlobal(basePoint);
				//Debug.trace("label", p1, p2,label.width,label.height,label.x,label.y);
				if (label.x>0&&lArr[i].x>0)
				{
					if (Math.abs(p1.y - p2.y) < 12)
					//if (label.hitTestObject(lArr[i]))
					{
						label.y += 9;
						//trace(label.y);
						if (label.y < 0)
						{
							label.x += 25;
						}
						//label.globalToLocal
						p1 = label.localToGlobal(basePoint);
						//checkFleg = true;
					}
				}
				else if(label.x<0&&lArr[i].x<0)
				{
					if (Math.abs(p1.y-p2.y)<12)
					//if (label.hitTestObject(lArr[i]))
					{
						label.y -= 9;
						/*if (label.y < 0)
						{
							label.x -= 25;
						}*/
						p1 = label.localToGlobal(basePoint);
						//checkFleg = true;
					}
				}
			}
			/*if (checkFleg == true)
			{
				checkLabelY();
			}*/
		}
		
		public function mySetDepths():void
		{
			var _depthList:Array = [];
			var len:uint = chartRef.chartGraphicContainer.graphicsCollection.length;
			/*for (var j:uint = 0; j < len; j++)
			   {
			   var minJ:Number = chartRef.chartGraphicContainer.graphicsCollection[j].minR;
			   var maxJ:Number = chartRef.chartGraphicContainer.graphicsCollection[j].maxR;
			   switch (true)
			   {
			   case minJ >= -90 && minJ <= 90 && maxJ <= 180:
			   _depthList[j] = minJ;
			   break;
			   default:
			   _depthList[j] = 1000 - minJ;
			   }
			   }
			   _depthList = _depthList.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			   for (j = 0; j < len; j++)
			   {
			   chartRef.chartGraphicContainer.graphicsCollection[_depthList[j]].parent.setChildIndex(chartRef.chartGraphicContainer.graphicsCollection[_depthList[j]], j);
			 }*/
			for (var i:int = 0; i < len; i++)
			{
				for (var j:int = len - 1; j >= 0; j--)
				{
					if (i == j)
					{
						continue;
					}
					var index1:int = chartRef.chartGraphicContainer.graphicsCollection[0].parent.getChildIndex(chartRef.chartGraphicContainer.graphicsCollection[i]);
					var index2:int = chartRef.chartGraphicContainer.graphicsCollection[0].parent.getChildIndex(chartRef.chartGraphicContainer.graphicsCollection[j]);
					if (chartRef.chartGraphicContainer.graphicsCollection[i].center.y > chartRef.chartGraphicContainer.graphicsCollection[j].center.y)
					{
						if (index1 < index2)
						{
							//trace("换");
							chartRef.chartGraphicContainer.graphicsCollection[0].parent.swapChildren(chartRef.chartGraphicContainer.graphicsCollection[i], chartRef.chartGraphicContainer.graphicsCollection[j]);
						}
					}
				}
			}
		}
		
		public var minR:Number;
		public var maxR:Number;
		
		public function drawSector3D(graphics:Graphics, point:Point, radius:Number, beginAngle:Number, angle:Number, lineColor:uint, lineWidth:uint, lineAlpha:Number, color:uint, innerRadius:uint = 50):Point
		{
			var centerPoint:Point = new Point();
			graphics.clear();
			_x0 = point.x;
			_y0 = point.y;
			var drakColor2:uint = getDarkColor2(color); //深色
			var drakColor3:uint = getDarkColor3(color);
			var g:Graphics = graphics;
			//底面
			//g.lineStyle(2, 0xFFFFFF);
			g.beginFill(color, lineAlpha);
			g.moveTo(point.x, point.y + _h);
			//g.moveTo(_x0, _y0 + _h);
			var r:Number = beginAngle
			minR = r;
			maxR = r + angle;
			var step:Number = 0.1;
			while (r + step <= maxR)
			{
				if (int(r) == int((maxR + minR) / 2))
				{
					centerPoint.x = getRPoint(_x0, _y0, _a, _b, r).x / 2;
					centerPoint.y = getRPoint(_x0, _y0, _a, _b, r).y / 1.9 + 3;
				}
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, r).x, getRPoint(_x0, _y0 + _h, _a, _b, r).y);
				r += step;
			}
			g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, maxR).x, getRPoint(_x0, _y0 + _h, _a, _b, maxR).y);
			g.endFill();
			var rightB:Boolean = false;
			if (((minR > 0 || maxR > 0) && minR < 180) == false)
			{
				g.beginGradientFill(GradientType.LINEAR, [color, drakColor2], [lineAlpha, lineAlpha], [0x00, 0xFF]);
				g.moveTo(getRPoint(_x0, _y0 + _h, _a, _b, minR).x, getRPoint(_x0, _y0 + _h, _a, _b, minR).y);
				g.lineTo(getRPoint(_x0, _y0, _a, _b, minR).x, getRPoint(_x0, _y0, _a, _b, minR).y);
				r = minR;
				rightB = false;
				while (r + step < maxR)
				{
					r += step;
					if (r == 0 || r == 180)
					{
						rightB = true;
						g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, r).x, getRPoint(_x0, _y0 + _h, _a, _b, r).y);
						while (r - step > minR)
						{
							g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, r).x, getRPoint(_x0, _y0 + _h, _a, _b, r).y);
							r -= step;
						}
						break;
					}
					g.lineTo(getRPoint(_x0, _y0, _a, _b, r).x, getRPoint(_x0, _y0, _a, _b, r).y);
				}
				if (!rightB)
				{
					g.lineTo(getRPoint(_x0, _y0, _a, _b, maxR).x, getRPoint(_x0, _y0, _a, _b, maxR).y);
					g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, maxR).x, getRPoint(_x0, _y0 + _h, _a, _b, maxR).y);
					while (r - step > minR)
					{
						g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, r).x, getRPoint(_x0, _y0 + _h, _a, _b, r).y);
						r -= step;
					}
				}
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, minR).x, getRPoint(_x0, _y0 + _h, _a, _b, minR).y);
				g.endFill();
			}
			
			//return centerPoint;
			if (90 < minR && minR < 180)
			{
				//trace(minR);
				//画外侧面
				//g.beginFill(drakColor, lineAlpha);
				g.beginGradientFill(GradientType.LINEAR, [drakColor2, drakColor3], [lineAlpha, lineAlpha], [0x00, 0xff])
				g.moveTo(_x0, _y0 + _h);
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, maxR).x, getRPoint(_x0, _y0 + _h, _a, _b, maxR).y);
				g.lineTo(getRPoint(_x0, _y0, _a, _b, maxR).x, getRPoint(_x0, _y0, _a, _b, maxR).y);
				g.lineTo(_x0, _y0);
				g.endFill();
				
				//画内侧面
				//g.beginFill(drakColor, lineAlpha);
				g.beginGradientFill(GradientType.LINEAR, [drakColor3, drakColor2], [lineAlpha, lineAlpha], [0x00, 0xFF])
				g.moveTo(_x0, _y0 + _h);
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, minR).x, getRPoint(_x0, _y0 + _h, _a, _b, minR).y);
				g.lineTo(getRPoint(_x0, _y0, _a, _b, minR).x, getRPoint(_x0, _y0, _a, _b, minR).y);
				g.lineTo(_x0, _y0);
				g.endFill();
			}
			else
			{
				//画内侧面
				//g.beginFill(drakColor, lineAlpha);
				g.beginGradientFill(GradientType.LINEAR, [drakColor3, drakColor2], [lineAlpha, lineAlpha], [0x00, 0xFF])
				g.moveTo(_x0, _y0 + _h);
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, minR).x, getRPoint(_x0, _y0 + _h, _a, _b, minR).y);
				g.lineTo(getRPoint(_x0, _y0, _a, _b, minR).x, getRPoint(_x0, _y0, _a, _b, minR).y);
				g.lineTo(_x0, _y0);
				g.endFill();
				
				//画外侧面
				//g.beginFill(drakColor, lineAlpha);
				g.beginGradientFill(GradientType.LINEAR, [drakColor2, drakColor3], [lineAlpha, lineAlpha], [0x00, 0xff])
				g.moveTo(_x0, _y0 + _h);
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, maxR).x, getRPoint(_x0, _y0 + _h, _a, _b, maxR).y);
				g.lineTo(getRPoint(_x0, _y0, _a, _b, maxR).x, getRPoint(_x0, _y0, _a, _b, maxR).y);
				g.lineTo(_x0, _y0);
				g.endFill();
			}
			
			//画外弧侧面
			//g.lineStyle(0)
			
			//g.beginFill(drakColor + 0x003000, lineAlpha);
			//g.lineStyle(1);
			/*if ((minR > 0 || maxR > 0) && minR < 180)
			 {*/
			g.beginFill(drakColor2, lineAlpha);
			g.moveTo(getRPoint(_x0, _y0 + _h, _a, _b, minR).x, getRPoint(_x0, _y0 + _h, _a, _b, minR).y);
			g.lineTo(getRPoint(_x0, _y0, _a, _b, minR).x, getRPoint(_x0, _y0, _a, _b, minR).y);
			r = minR;
			rightB = false;
			while (r + step < maxR)
			{
				r += step;
				if (r == 0 || r == 180)
				{
					rightB = true;
					g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, r).x, getRPoint(_x0, _y0 + _h, _a, _b, r).y);
					while (r - step > minR)
					{
						g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, r).x, getRPoint(_x0, _y0 + _h, _a, _b, r).y);
						r -= step;
					}
					break;
				}
				g.lineTo(getRPoint(_x0, _y0, _a, _b, r).x, getRPoint(_x0, _y0, _a, _b, r).y);
			}
			if (!rightB)
			{
				g.lineTo(getRPoint(_x0, _y0, _a, _b, maxR).x, getRPoint(_x0, _y0, _a, _b, maxR).y);
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, maxR).x, getRPoint(_x0, _y0 + _h, _a, _b, maxR).y);
				while (r - step > minR)
				{
					g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, r).x, getRPoint(_x0, _y0 + _h, _a, _b, r).y);
					r -= step;
				}
			}
			g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, minR).x, getRPoint(_x0, _y0 + _h, _a, _b, minR).y);
			g.endFill();
			/*}*/
			
			if (minR > 180 && minR < 270)
			{
				g.beginGradientFill(GradientType.LINEAR, [drakColor3, drakColor2], [lineAlpha, lineAlpha], [0x00, 0xFF])
				g.moveTo(_x0, _y0 + _h);
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, minR).x, getRPoint(_x0, _y0 + _h, _a, _b, minR).y);
				g.lineTo(getRPoint(_x0, _y0, _a, _b, minR).x, getRPoint(_x0, _y0, _a, _b, minR).y);
				g.lineTo(_x0, _y0);
				g.endFill();
			}
			
			if (maxR > 270 && maxR < 360)
			{
				g.beginGradientFill(GradientType.LINEAR, [drakColor2, drakColor3], [lineAlpha, lineAlpha], [0x00, 0xff])
				g.moveTo(_x0, _y0 + _h);
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, maxR).x, getRPoint(_x0, _y0 + _h, _a, _b, maxR).y);
				g.lineTo(getRPoint(_x0, _y0, _a, _b, maxR).x, getRPoint(_x0, _y0, _a, _b, maxR).y);
				g.lineTo(_x0, _y0);
				g.endFill();
			}
			
			if (maxR > -90 && maxR < 0)
			{
				g.beginGradientFill(GradientType.LINEAR, [drakColor2, drakColor3], [lineAlpha, lineAlpha], [0x00, 0xff])
				g.moveTo(_x0, _y0 + _h);
				g.lineTo(getRPoint(_x0, _y0 + _h, _a, _b, maxR).x, getRPoint(_x0, _y0 + _h, _a, _b, maxR).y);
				g.lineTo(getRPoint(_x0, _y0, _a, _b, maxR).x, getRPoint(_x0, _y0, _a, _b, maxR).y);
				g.lineTo(_x0, _y0);
				g.endFill();
			}
			
			//画上表面
			//g.beginGradientFill(GradientType.LINEAR, [color,drakColor], [lineAlpha, lineAlpha], [0x00, 0xFF])
			g.beginFill(color, lineAlpha);
			g.moveTo(_x0, _y0);
			r = minR;
			while (r + step < maxR)
			{
				g.lineTo(getRPoint(_x0, _y0, _a, _b, r).x, getRPoint(_x0, _y0, _a, _b, r).y);
				r += step;
			}
			g.lineTo(getRPoint(_x0, _y0, _a, _b, maxR).x, getRPoint(_x0, _y0, _a, _b, maxR).y);
			g.endFill();
			return centerPoint;
		}
		
		public static var PIE_NAME:String = "pie";
		//存放shape对象
		private var __contain:Object;
		//设置角度从-90开始
		private var R:int = -90;
		private var D:uint = 30;
		private var _shape:Shape;
		//初始饼图的圆心位置
		private var _x0:Number;
		private var _y0:Number;
		//椭圆饼图的长轴与短轴长度
		private var _a:Number;
		private var _b:Number;
		//饼图的厚度
		private var _h:Number;
		//透明度
		private var _alpha:Number;
		//数据列表
		private var _dataList:Array;
		private var _colorList:Array;
		private var _angleList:Array;
		private var _depthList:Array;
		//
		private var _tween1:Tween;
		private var _tween2:Tween;
		
		private function setAngleList():void
		{
			_angleList = [];
			var totalData:int;
			var len:uint = _dataList.length;
			for (var j:uint = 0; j < len; j++)
			{
				totalData += _dataList[j];
			}
			for (j = 0; j < len; j++)
			{
				if (j == len - 1)
				{
					_angleList.push([R, 270]);
				}
				else
				{
					var r:uint = Math.floor(_dataList[j] / totalData * 360);
					var posR:int = R + r;
					_angleList.push([R, posR]);
					R = posR;
						//trace(r + "___r");
						//trace(R);
				}
			}
			//trace(_angleList + ":::");
		}
		
		private function setDepths():void
		{
			_depthList = [];
			var len:uint = _angleList.length;
			for (var j:uint = 0; j < len; j++)
			{
				var minJ:Number = _angleList[j][0];
				var maxJ:Number = _angleList[j][1];
				switch (true)
				{
					case minJ >= -90 && minJ <= 90 && maxJ <= 90: 
						_depthList[j] = minJ;
						break;
					default: 
						_depthList[j] = 1000 - minJ;
				}
			} //end for
			//trace(_depthList + "::::_depthList");
			_depthList = _depthList.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			//trace(_depthList);
			for (j = 0; j < len; j++)
			{
				setChildIndex(__contain[PieGraphic3D.PIE_NAME + _depthList[j]], j);
			}
		}
		
		private function getDarkColor(color:uint):uint
		{
			var r:uint = color >> 16 & 0xFF / 1.3;
			var g:uint = color >> 8 & 0xFF / 1.3;
			var b:uint = color & 0xFF / 1.3;
			return r << 16 | g << 8 | b;
		}
		
		private function getDarkColor2(color:uint):uint
		{
			var index:int = ChartGlobal.colorCollection.indexOf(color);
			return ChartGlobal.colorCollection2[index];
		}
		
		private function getDarkColor3(color:uint):uint
		{
			var index:int = ChartGlobal.colorCollection.indexOf(color);
			return ChartGlobal.colorCollection3[index];
		}
		
		private function getBleachColor(color:uint):uint
		{
			var r:uint = color >> 16 & 0xFF * 1.3;
			var g:uint = color >> 8 & 0xFF * 1.3;
			var b:uint = color & 0xFF * 1.3;
			return r << 16 | g << 8 | b;
		}
		
		private function getRPoint(x0:Number, y0:Number, a:Number, b:Number, r:Number):Object
		{
			r = r * Math.PI / 180;
			return {x: Math.cos(r) * a + x0, y: Math.sin(r) * b + y0};
		}
		
		public function get contain():Object
		{
			return __contain;
		}
		
		public function clearAll():void
		{ //清除内容
			graphics.clear();
			//ObjectUtils.removeAllChildren(this);
		}
	
	}

}