package  {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class BottonListView extends MovieClip {
		
		public var txt1:MovieClip;
		public var txt2:MovieClip;
		public var bg:MovieClip;
		public function BottonListView() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			bg.width = stage.stageWidth;
		}
		
		public function setText(str:String):void
		{
			var arr:Array;
			if (str.indexOf(",")!=-1)
			{
				arr = str.split(",", 2);
			}
			else if (str .indexOf(" ") != -1)
			{
				//str.replace("\\s+", " ");
				arr = str.split(" ", 2);
			}
			else
			{
				arr[0] = arr[1]=str;
			}
			
			txt1.txt.text = arr[0]
			txt1.txt.width = txt1.txt.textWidth + 5;
			txt1.txt.height = txt1.txt.textHeight + 5;
			txt2.x = txt1.x + txt1.width + 10;
			txt2.txt.text = arr[1];
			txt2.txt.width = txt2.txt.textWidth + 5;
			txt2.txt.height = txt2.txt.textHeight + 5;
		}
		
	}
	
}
