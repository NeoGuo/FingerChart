package ui
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.riameeting.finger.display.skin.ISkin;
	import flash.text.TextFormat;
	
	/**
	 * 线图的皮肤
	 * @author 黄龙
	 */
	public class PieChart3DTooltipSkin extends MovieClip implements ISkin
	{
		public var bg:MovieClip;
		public var label:TextField = new TextField();
		private var _hostComponent:Object;
		
		public function PieChart3DTooltipSkin()
		{
			super();
			label.x = label.y = 10;
			//var tf:TextFormat = new TextFormat();
			//tf.leading = 8;
			//label.setTextFormat(tf);
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
			var style:Object = _hostComponent.style;
			var color:String = style["color"];
			label.htmlText = "<textformat leading='8px'><font color='#FFFFFF'>" + parms.value + "</font></textformat>";
			label.x = 14+5;
			label.width = label.textWidth + 4;
			label.height = label.textHeight + 4;
			bg.x = 5;
			bg.width = label.width + 28;
			bg.height = label.height + 20;
			bg.y = -20;
			label.y = -12;
			/*graphics.clear();
			graphics.lineStyle(1,style["borderColor"],style["borderAlpha"]/100);
			graphics.beginFill(style["tipbgColor"],1);
			graphics.drawRoundRect(4.5,1,label.width+5,label.height+5,0,0);
			graphics.endFill();*/
		}
	}
}