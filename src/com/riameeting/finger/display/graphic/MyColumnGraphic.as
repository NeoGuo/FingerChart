package com.riameeting.finger.display.graphic
{
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.display.axis.IAxis;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.display.skin.MyColumnGraphicSkin;
	import com.riameeting.ui.control.*;
	import com.riameeting.utils.StringUtils;
	import flash.text.TextField;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 自定义柱状图
	 * @author 黄龙
	 */
	public class MyColumnGraphic extends LineGraphic
	{
		
		protected var columnOffset:Number = 5;
		
		override public function set color(value:uint):void
		{
			_color = value;
		}
		
		/**
		 * 构造方法
		 *
		 */
		public function MyColumnGraphic(chartRef:IChart)
		{
			super(chartRef);
			skinName = "skin.MyColumnGraphicSkin";
			//ChartGlobal.getSkin("skin.AxisSkin");
			ChartGlobal.skinClassDict["skin.MyColumnGraphicSkin"] = MyColumnGraphicSkin;
		}
		
		/**
		 * 执行定位方法，确定图形的位置
		 * @param value 坐标值
		 * @param offset 偏移量
		 *
		 */
		override public function locate(value:Point = null, offset:uint = 10):void
		{
			super.locate(value, offset);
			trace(value);
			if (data["tipString"] == null)
				data["tipString"] = {};
			//data["tipString"][yField] = "<b><font color='#"+color.toString(16)+"'>"+yField+"</font></b><br/>";
			var categoryField:String = chartRef.dataset.config["categoryField"];
			data["tipString"][yField] = "<b><font color='#FFFFFF'>" + data[categoryField] + "</font></b><br/>";
			var yTitle:String = chartRef.dataset.config["yTitle"];
			if (yTitle == " " || yTitle == "")
			{
				data["tipString"][yField] += data[yField];
			}
			else
			{
				data["tipString"][yField] += yTitle + "  " + data[yField];
			}
			if (chartRef.dataset.config["qualifier"] != null)
			{
				data["tipString"][yField] += chartRef.dataset.config["qualifier"];
			}
			if (data[yField + "_tooltext"])
			{
				data["tipString"][yField] += "\n"+data[yField + "_tooltext"];
			}
			var prevIndex:int = chartRef.dataset.collection.indexOf(data) - 1;
			var style:Array = ChartGlobal.colorCollection;
			var cIndex:int = (prevIndex + 1) % style.length;
			_color = style[cIndex];
			var axis:IAxis = chartRef.axis;
			if (prevIndex != -1)
			{
				(parent as Sprite).graphics.clear();
			}
			var axisRect:Rectangle = axis.getAxisRect();
			var columnWidth:Number = axisRect.width / (axis.dataset.collection.length + 2) - columnOffset;
			var columnItemWidth:Number = columnWidth / (axis.dataset.config["yField"].split(",").length - (axis.dataset.config["benchmark"] != null ? axis.dataset.config["benchmark"].split(",").length : 0));
			var yFieldIndex:int = axis.dataset.config["yField"].split(",").indexOf(yField);
			x += -(columnWidth) / 2 + columnItemWidth * yFieldIndex + columnItemWidth / 2;
			var textField:Label2 = new Label2();
			textField.htmlMode = true;
			var fontSize:int = 16;// (int(columnItemWidth * 0.25) < 11)?11:int(columnItemWidth * 0.25);
			var qualifier:String = "";
			if (chartRef.dataset.config["qualifier"] != null)
			{
				qualifier = chartRef.dataset.config["qualifier"];
			}
			if (qualifier == "%")
			{
				fontSize = 20;
			}
			
			var textData:String = "<font color='#" + color.toString(16) + "' size='" + fontSize + "' face='HeleveticaNarrow'>" + StringUtils.numberToUnitHtmlString2(Math.round(data[yField]))+"<font face='SongTi'><b>"+qualifier+"</b></font></font>";
			/*if (chartRef.dataset.config["qualifier"] != null)
			{
				textData += "<font color='#" + color.toString(16) + "' size='"+fontSize+"'> " + chartRef.dataset.config["qualifier"] + "</font>";
			}*/
			textField.text = textData;
			//textField.width = textField.textWidth + 5;
			trace(axisRect.y + axisRect.height - y);
			var myColumnItemHeight:Number;
			if (Number(data.value) == 0)
			{
				myColumnItemHeight = 1;
			}
			skin.updateDisplayList( { width: columnItemWidth, height: axisRect.y + axisRect.height - y, color: _color, text: textField } );
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
				for (i = 0; i < len; i++)
				{
					if (i == len - 1)
					{
						rStr += String(arr[0]).substr(arr[0].length % 3 + i * 3, 3);
						break;
					}
					rStr += String(arr[0]).substr(arr[0].length % 3 + i * 3, 3) + ",";
				}
			}
			else
			{
				if (arr[0].length > 3)
				{
					rStr = String(arr[0]).substr(0, arr[0].length % 3) + ',';
					for (i = 1; i < len; i++)
					{
						if (i == len - 1)
						{
							rStr += String(arr[0]).substr(arr[0].length % 3 + (i - 1) * 3, 3);
							break;
						}
						rStr += String(arr[0]).substr(arr[0].length % 3 + (i - 1) * 3, 3) + ",";
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
				rStr += "." + arr[1];
			}
			return rStr;
		}
	
	}

}