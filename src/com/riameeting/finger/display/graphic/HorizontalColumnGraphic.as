package com.riameeting.finger.display.graphic 
{
	import com.adobe.serialization.json.JSON;
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.skin.*;
	import com.riameeting.ui.control.*;
	import flash.text.TextField;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 横向图
	 * @author 黄龙
	 */
	public class HorizontalColumnGraphic extends LineGraphic 
	{
		protected var columnOffset:Number = 5;
		override public function set color(value:uint):void{
			_color = value;
		}
		
		public function HorizontalColumnGraphic(chartRef:IChart) 
		{
			super(chartRef);
			skinName = "skin.HorzontalColumnGraphicSkin";
			//ChartGlobal.getSkin("skin.AxisSkin");
			ChartGlobal.skinClassDict["skin.HorzontalColumnGraphicSkin"] = HorzontalColumnGraphicSkin;
		}
		
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 * 
		 */	
		override public function locate(value:Point=null, offset:uint=10):void {
			super.locate(value, offset);
			var prevIndex:int = chartRef.dataset.collection.indexOf(data) - 1;
			var style:Array = ChartGlobal.colorCollection;
			var cIndex:int = (prevIndex+1) %style.length;
			_color = style[cIndex];
			var axis:IAxis = chartRef.axis;
			if(prevIndex != -1) {
				(parent as Sprite).graphics.clear();
			}
			var axisRect:Rectangle = axis.getAxisRect();
			var columnWidth:Number = axisRect.width / (axis.dataset.collection.length + 2) - columnOffset;
			var columnItemWidth:Number = columnWidth/(axis.dataset.config["yField"].split(",").length-(axis.dataset.config["benchmark"]!=null?axis.dataset.config["benchmark"].split(",").length:0));
			var yFieldIndex:int = axis.dataset.config["yField"].split(",").indexOf(yField);
			//
			x = axis.style["paddingLeft"];
			var textField:Label2 = new Label2();
			//textField.font
			textField.htmlMode = true;
			//textField.setFont("HeleveticaNarrow");
			var textData:String;
			if (data[yField + "_tooltext"])
			{
				textData = data[yField + "_tooltext"];
				var textdataArr:Array = fomartStr(textData);
				var textdataArr00:String = (isNaN(textdataArr[0][0])==false)?("<font face='HeleveticaNarrow'>"+fomart(Number(textdataArr[0][0]))+"</font>"):textdataArr[0][0];
				var textdataArr01:String = (isNaN(textdataArr[0][1]) == false)?("<font face='HeleveticaNarrow'>"+fomart(Number(textdataArr[0][1]))+"</font>"):textdataArr[0][1];
				if (axis['realGridHeight'] * 0.5 < 22)
				{
					textData = "<b><font color='#" + color.toString(16) + "' size='" + Number(axis['realGridHeight'] * 0.5 + 2) + "'>" + textdataArr00 + "</font></b>";
				}
				else
				{
					textData = "<b><font color='#" + color.toString(16) + "' size='24'>" + textdataArr00 + "</font></b>";
				}
				
				if (textdataArr01 != null)
				{
					if (axis['realGridHeight'] * 0.25 < 10)
					{
						textData += "<font color='#" + color.toString(16) + "' size='" + Number(axis['realGridHeight'] * 0.25+2) + "'> " + textdataArr01 + " </font>";
					}
					else
					{
						textData += "<font color='#" + color.toString(16) + "' size='12'> " + textdataArr01 + " </font>";
					}
				}
				
				if (textdataArr.length == 2)
				{
					var textdataArr10:String = (isNaN(textdataArr[1][0])==false)?"<b><font face='HeleveticaNarrow'>"+fomart(Number(textdataArr[1][0]))+"</font></b>":textdataArr[1][0];
					var textdataArr11:String = (isNaN(textdataArr[1][1])==false)?"<b><font face='HeleveticaNarrow'>"+fomart(Number(textdataArr[1][1]))+"</font></b>":textdataArr[1][1];
					if (textdataArr11 == null) { textdataArr11 = ""; }
					if (axis['realGridHeight'] * 0.25 < 12)
					{
						textData += "<font color='#" + color.toString(16) + "' size='" + Number(axis['realGridHeight'] * 0.25 + 2) + "' face='HeleveticaNarrow'> " + textdataArr10 + textdataArr11 + "</font>";
					}
					else
					{
						textData += "<font color='#" + color.toString(16) + "' size='14' face='HeleveticaNarrow'> " + textdataArr10 + textdataArr11 + "</font>";
					}
				}
			}
			else
			{
				if (axis['realGridHeight'] * 0.25 < 12)
				{
					textData = "<font color='#" + color.toString(16) + "' size='" + Number(axis['realGridHeight'] * 0.5 + 2) + "' face='HeleveticaNarrow'><b>" + fomart(data[yField]) + "</b>  </font>";
				}
				else
				{
					textData = "<font color='#" + color.toString(16) + "' size='24' face='HeleveticaNarrow'><b>" + fomart(data[yField]) + "</b>  </font>";
				}
			}
			textField.text = textData;
			skin.updateDisplayList( { width:data[yField]/axis['maxValueY']*axis['graphicArea']['width'], height:axis['realGridHeight']*0.5, color:_color,text:textField} );
			y = axis.style["paddingTop"] + axis['realGridHeight'] * (prevIndex + 2) - 10;
			var point:Point = this.center;
			point.x = data[yField] / axis['maxValueY'] * axis['axisWidth'];
			this.center = point;
			if(data["tipString"] == null) data["tipString"] = {};
			var categoryField:String = chartRef.dataset.config["categoryField"];
			//data["tipString"][yField] = "<b><font color='#"+color.toString(16)+"'>"+data[categoryField]+"</font></b><br/>";
			data["tipString"][yField] = "<b><font color='#ffffff'>"+data[categoryField]+"</font></b><br/>";
			var yTitle:String = chartRef.dataset.config["yTitle"];
			if (data[yField + "_tooltext"])
			{
				data["tipString"][yField] += yTitle + "  " + data[yField + "_tooltext"];
			}
			else
			{
				data["tipString"][yField] += yTitle + "  " + data[yField];
			}
		}
		
		private function fomartStr(str:String):Array
		{
			var arr:Array;
			var rArr:Array=[];
			if (str.indexOf(" ") != -1)
			{
				arr = str.split(" ", 2);
			}
			else
			{
				arr = [];
				arr.push(str);
			}
			var re:RegExp = /([0-9]*\.?[0-9]+)/;
			var str:String = '';
			for (var i:int = 0; i < arr.length; i++)
			{	
				var lArr:Array = arr[i].split(re);
				for (var j:int = 0; j < lArr.length; j++)
				{
					if (lArr[j] == "")
					{
						lArr.splice(j, 1);
					}
				}
				rArr.push(lArr);
			}
			return rArr;
		}
		
		/**
		 * 序列化数字为字符串
		 * @param	num 
		 * @return 	转换好的字符串
		 */
		private function fomart(num:Number):String
		{
			var rStr:String = '';
			var arr:Array = String(num).split('.');
			var len:int = Math.ceil(String(arr[0]).length / 3);
			var i:int = 0;
			if (arr[0].length % 3 == 0)
			{
				for (i = 0;i < len; i++)
				{
					if (i == len - 1)
					{
						rStr += String(arr[0]).substr(arr[0].length % 3 + i * 3, 3);
						break;
					}
					rStr += String(arr[0]).substr(arr[0].length % 3 + i  * 3, 3) + ",";
				}
			}
			else
			{
				if (arr[0].length > 3)
				{
					rStr = String(arr[0]).substr(0, arr[0].length % 3)+',';
					for (i = 1;i < len; i++)
					{
						if (i == len - 1)
						{
							rStr += String(arr[0]).substr(arr[0].length % 3 + (i-1) * 3, 3);
							break;
						}
						rStr += String(arr[0]).substr(arr[0].length % 3 + (i-1)* 3, 3) + ",";
					}
				}
				else
				{
					rStr = String(arr[0]).substr(0, arr[0].length % 3);
				}
			}
			//String(arr[0]).
			if (arr.length > 1)
			{
				rStr += "."+arr[1];
			}
			return rStr;
		}
	}

}