package  {
	
	import com.as3long.utils.TextUtils;
	import com.riameeting.finger.config.ChartGlobal;
	import flash.display.*;
	import flash.events.Event;
	import flash.text.TextField;
	public class CompareColumnChartListView extends MovieClip {
		
		public var _txt:TextField;
		public var bg:MovieClip;
		public function CompareColumnChartListView() {
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
			_txt.text = str;
		}
		
		public function setTextArr(arr:Array):void
		{
			for (var i:int = 0; i < arr.length; i++)
			{
				TextUtils.appendText(_txt, "■ ", ChartGlobal.colorCollection[i]);
				TextUtils.appendText(_txt, arr[i] + " ");
			}
		}
		
	}
	
}
