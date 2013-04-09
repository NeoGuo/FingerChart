package
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ChartButton extends MovieClip
	{
		
		public var txt:TextField;
		public var bg:MovieClip;
		private var _selected:Boolean = false;
		
		public function ChartButton()
		{
			
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.mouseChildren = false;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			gotoAndStop(2);
			this.y = stage.stageHeight - 32;
			this.buttonMode = true;
		}
		
		public function setText(str:String):void
		{
			txt.text = str;
			txt.width = txt.textWidth + 5;
			bg.width = txt.width + 10;
			txt.x = 5;
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (selected == false)
			{
				selected = true;
			}
			else
			{
				selected = false;
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void
		{
			super.gotoAndStop(frame, scene);
			if (frame == 1)
			{
				bg.visible = false;
			}
			else if (frame == 2)
			{
				bg.visible = true;
			}
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			//trace();
			if (_selected == false)
			{
				gotoAndStop(2);
			}
			else
			{
				gotoAndStop(1);
			}
		}
	}

}
