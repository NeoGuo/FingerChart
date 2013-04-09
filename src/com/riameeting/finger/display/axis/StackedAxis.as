package com.riameeting.finger.display.axis
{
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.factory.ObjectFactory;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.ui.control.Alert;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.ColorUtils;
	import com.riameeting.utils.DPIReset;
	import com.riameeting.utils.DrawTool;
	import com.riameeting.utils.NumberTool;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 堆栈坐标系
	 * @author 黄龙
	 */
	public class StackedAxis extends BasicAxis
	{
		
		public function StackedAxis(chartRef:IChart, ignoreOffsetV:Boolean = false)
		{
			super(chartRef, ignoreOffsetV);
		}
		
		override protected function calculateMaxValue():void
		{
			var i:uint = 0, j:uint = 0, obj:Object;
			if (dataset.config["minValueX"] != null)
			{
				minValueX = dataset.config["minValueX"];
			}
			else
			{
				minValueX = 0;
			}
			if (dataset.config["maxValueX"] != null)
			{
				maxValueX = dataset.config["maxValueX"];
			}
			else
			{
				maxValueX = 0;
			}
			if (dataset.config["minValueY"] != null)
			{
				minValueY = dataset.config["minValueY"];
			}
			else
			{
				minValueY = 0;
			}
			if (dataset.config["maxValueY"] != null)
			{
				maxValueY = dataset.config["maxValueY"];
			}
			else
			{
				maxValueY = 0;
			}
			//x
			if (xField != null)
			{
				if (yFields.length != 1)
				{
					Alert.show("you must define 1 y fileds with xField mode", "Error");
					throw new Error("you must define 1 y fileds with xField mode");
				}
				countX = (graphicArea.width - int(style["offsetV"]) * 2) / int(style["gridHeight"]);
				//maxXValue
				for (j = 0; j < dataset.collection.length; j++)
				{
					obj = dataset.collection[j];
					if (obj[xField] > maxValueX)
					{
						maxValueX = obj[xField];
					}
					if (obj[xField] < minValueX)
					{
						minValueX = obj[xField];
					}
				}
				maxValueX = NumberTool.getMaxNumber(maxValueX);
				minValueX = NumberTool.getMinNumber(minValueX);
			}
			else
			{
				countX = dataset.collection.length;
			}
			//y
			for (j = 0; j < dataset.collection.length; j++)
			{
				var yFieldsINum:Number = 0;;
				obj = dataset.collection[j];
				obj.doubleArbor = false;
				for (i = 0; i < yFields.length; i++)
				{
					yFieldsINum += Number(obj[yFields[i]]);
					trace(obj[yFields[i]]);
				}
				if (yFieldsINum > maxValueY)
				{
					maxValueY = yFieldsINum;
				}
				if (yFieldsINum < minValueY)
				{
					minValueY = yFieldsINum;
				}
			}
			countY = graphicArea.height / int(style["gridHeight"]);
			maxValueY = NumberTool.getMaxNumberY(maxValueY,countY);
			minValueY = NumberTool.getMinNumber(minValueY);
			//ignoreOffsetV
			if (ignoreOffsetV)
			{
				style["offsetH"] = graphicArea.width / (countX + 1);
			}
			//maxValueY *= 2;
		}
	}

}