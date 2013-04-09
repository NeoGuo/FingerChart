package com.riameeting.ui.control
{
	import flash.text.TextField;
	
	import com.riameeting.utils.ColorUtils;
	/**
	 * 带左侧图形显示的标签
	 * @author Finger
	 * 
	 */
	public class GraphicLabel extends Label
	{
		/**
		 * 构造方法
		 * @param htmlMode html模式
		 * @param lineColor 图形颜色
		 * @param mode 图形模式
		 * @param number 如果模式是数字，则传入此值
		 * 
		 */		
		public function GraphicLabel(htmlMode:Boolean=false,lineColor:uint=0x000000,mode:String="line",number:uint=0)
		{
			super(htmlMode);
			innerTxt.x = 20;
			graphics.beginFill(lineColor,1);
			switch(mode) {
				case "line":
					graphics.drawRect(0,8,15,4);
					break;
				case "double":
					graphics.drawRect(0,8,15,2);
					graphics.endFill();
					graphics.beginFill(ColorUtils.fadeColor(lineColor,0xFFFFFF,0.4),1);
					graphics.drawRect(0,10,15,2);
					break;
				case "rect":
					graphics.drawRect(0,2,14,14);
					break;
				case "number":
					var numerTxt:Label = new Label(false);
					numerTxt.color = lineColor;
					numerTxt.text = number+"";
					addChild(numerTxt);
					break;
			}
			graphics.endFill();
		}
	}
}