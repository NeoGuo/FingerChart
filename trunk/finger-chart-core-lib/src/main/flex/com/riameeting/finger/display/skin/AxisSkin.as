package com.riameeting.finger.display.skin
{
	import com.riameeting.finger.display.axis.ReversalAxis;
	import com.riameeting.finger.factory.ObjectFactory;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.ColorUtils;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 默认的坐标系皮肤
	 * @author RIAMeeting
	 *
	 */
	public class AxisSkin extends MovieClip implements ISkin
	{
		/**
		 * 计算底部标签的宽度总和，用于宽度超出的时候，进行优化处理
		 */
		public var allBottomLabelWidth:uint;
		/**
		 * 左上角显示的标签
		 */
		public var titleL:Label=new Label(true);
		/**
		 * 底部显示的标签
		 */
		public var titleB:Label=new Label(true);
		/**
		 * 标签的显示容器
		 */
		protected var labelContainer:Sprite=new Sprite();
		private var _hostComponent:Object;

		/**
		 * 组件引用
		 * @return
		 *
		 */
		public function get hostComponent():Object
		{
			return _hostComponent;
		}

		public function set hostComponent(value:Object):void
		{
			_hostComponent=value;
		}

		/**
		 * 构造方法
		 *
		 */
		public function AxisSkin()
		{
			super();
			addChild(titleL);
			addChild(titleB);
			addChild(labelContainer);
		}

		/**
		 * 更新显示列表
		 * @param parm
		 * @param style
		 *
		 */
		public function updateDisplayList(parms:Object=null):void
		{
			var style:Object=_hostComponent.style;
			var w:Number=_hostComponent.axisWidth, h:Number=_hostComponent.axisHeight;
			var value:Object=_hostComponent.dataset;
			titleL.text="<b><font color='" + ColorUtils.toWebColor(style["color"]) + "'>" + value.config["yTitle"] + "</font></b>";
			if (_hostComponent.xField != null)
			{
				titleB.text="<b><font color='" + ColorUtils.toWebColor(style["bottomColor"]) + "'>" + _hostComponent.xField + "</font></b>";
			}
			else
			{
				titleB.text="<b><font color='" + ColorUtils.toWebColor(style["bottomColor"]) + "'>" + value.config["categoryField"] + "</font></b>";
			}
			//reset location
			titleB.x=(w - titleB.width) / 2;
			titleB.y=h - titleB.height;
			drawBottomContainer(w, h);
			//create label
			createLabels(w, h);
		}

		/**
		 * 绘制底部容器
		 * @param parm
		 * @param style
		 *
		 */
		protected function drawBottomContainer(w:Number, h:Number):void
		{
			graphics.clear();
			var style:Object=_hostComponent.style;
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
			graphics.moveTo(style["paddingLeft"], style["paddingTop"]);
			graphics.lineTo(style["paddingLeft"], h - style["paddingBottom"]);
			graphics.lineTo(w - style["paddingRight"], h - style["paddingBottom"]);
			graphics.lineStyle(stroke2,color2,alpha2);
		}

		/**
		 * 创建需要显示的标签
		 *
		 */
		protected function createLabels(w:Number, h:Number):void
		{
			var style:Object=_hostComponent.style;
			//left label
			var i:uint=0, currentLabel:Label;
			_hostComponent.realGridHeight=_hostComponent.graphicArea.height / _hostComponent.countY;
			var currentOffset:Number=_hostComponent.ignoreOffsetV ? style["offsetH"] : style["offsetV"];
			_hostComponent.realGridWidth=(_hostComponent.graphicArea.width - currentOffset * 2) / (_hostComponent.countX - 1);
			for (; i < _hostComponent.countY; i++)
			{
				currentLabel=ObjectFactory.produce(Label, "Label");
				currentLabel.color=style["color"];
				currentLabel.y=int(style["paddingTop"]) + _hostComponent.realGridHeight * i - currentLabel.height / 2;
				currentLabel.text=String(_hostComponent.maxValueY - int(((_hostComponent.maxValueY - _hostComponent.minValueY) / _hostComponent.countY) * i));
				labelContainer.addChild(currentLabel);
				graphics.moveTo(style["paddingLeft"],currentLabel.y+currentLabel.height/2);
				graphics.lineTo(w - style["paddingRight"],currentLabel.y+currentLabel.height/2);
			}
			//Bottom label
			allBottomLabelWidth=0;
			for (i=0; i < _hostComponent.countX; i++)
			{
				currentLabel=ObjectFactory.produce(Label, "Label");
				currentLabel.color=style["color"];
				currentLabel.name="l" + i;
				if (_hostComponent.xField != null)
				{
					currentLabel.text=String(int(((_hostComponent.maxValueX - _hostComponent.minValueX) / (_hostComponent.countX - 1)) * i + _hostComponent.minValueX));
				}
				else
				{
					currentLabel.text=_hostComponent.dataset.collection[i][_hostComponent.dataset.config["categoryField"]];
				}
				currentLabel.x=int(style["paddingLeft"]) + _hostComponent.realGridWidth * i + currentOffset - currentLabel.width / 2;
				currentLabel.y=_hostComponent.graphicArea.y + _hostComponent.graphicArea.height + 10;
				labelContainer.addChild(currentLabel);
				allBottomLabelWidth+=currentLabel.width;
			}
			if (allBottomLabelWidth > _hostComponent.graphicArea.width)
			{
				var hideIndex:uint=allBottomLabelWidth / _hostComponent.graphicArea.width;
				var count:uint=0;
				for (i=1; i < _hostComponent.countX; i++)
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
		}

		/**
		 * 当需重绘坐标系的时候，调用此方法
		 *
		 */
		public function clear():void
		{
			this.graphics.clear();
			while (labelContainer.numChildren > 0)
			{
				(labelContainer.getChildAt(0) as Label).clear();
				ObjectFactory.reclaim(Label, labelContainer.removeChildAt(0), "Label");
			}
		}
	}
}
