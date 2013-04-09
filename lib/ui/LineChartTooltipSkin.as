package ui
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.riameeting.finger.display.skin.ISkin;
	/**
	 * 线图的皮肤
	 * @author 黄龙
	 */
	public class LineChartTooltipSkin extends MovieClip implements ISkin 
	{
		public var bg:MovieClip;
		public var label:TextField = new TextField();
		private var _hostComponent:Object;
		public function LineChartTooltipSkin() 
		{
			super();
			//label.x = label.y = 2;
			addChild(label);
		}
		
		/* INTERFACE com.riameeting.finger.display.skin.ISkin */
		
		public function get hostComponent():Object 
		{
			return _hostComponent;
		}
		
		public function set hostComponent(value:Object):void 
		{
			_hostComponent = value;
		}
		
		public function updateDisplayList(parms:Object = null):void 
		{
			if (parms.value != null)
			{
				this.gotoAndStop(1);
				var style:Object = _hostComponent.style;
				var color:String = style["color"];
				//label.defaultTextFormat.li
				label.htmlText = "<textformat leading='8px'><font color='#FFFFFF'>" + parms.value + "</font></textformat>";
				//trace(label.htmlText);
				label.width = label.textWidth + 4;
				label.height = label.textHeight + 4;
				label.x = -label.width * 0.5;
				label.y = -label.height - 24 ;
				bg.height = label.height + 16;
				bg.width = label.width + 24;
				bg.x = label.x - 12;
				bg.y = label.y - 7;
			}
			else if(parms.ltx!=null)
			{
				//(parms.ltx, parms.lty,bg.y,bg.width*0.5);
				//trace()
				//if(parms.lty)
				if (parms.lty + bg.y < 0)
				{
					this.gotoAndStop(2);
					label.y = 24 ;
					bg.y = 15;
				}
				
				if (bg.width * 0.5 > parms.ltx)
				{
					bg.x = -18;
					//bg.x = label.x - 12;
					label.x=-6
				}
				
				if (parms.ltx + bg.width > 740)
				{
					bg.x =-bg.width+18;
					//bg.x = label.x - 12;
					label.x =-bg.width+30;
				}
				
			}
		}
		
	}

}