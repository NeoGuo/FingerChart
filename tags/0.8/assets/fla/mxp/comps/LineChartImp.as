package comps {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.component.*;
	
	import fl.core.UIComponent;
	import flash.utils.setTimeout;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	public class LineChartImp extends UIComponent {

		private var _css:String;
		private var _skin:String;
		private var _data:String;
		
		protected var label:TextField = new TextField();
		
		protected var chart:IChart;
		protected var config:Object = {};

		public function LineChartImp() {
			label.text = "FingerChart";
			addChild(label);
			if(chart == null) chart = new LineChart(width,height);
			addChild(chart as DisplayObject);
			drawNow();
		}
		
		[Inspectable(defaultValue="default.css")] 
		public function get css():String {
			return _css;
		}
		public function set css(value:String):void {
			_css = value;
		}
		
		[Inspectable(defaultValue="default_skin.swf")] 
		public function get skin():String {
			return _skin;
		}
		public function set skin(value:String):void {
			_skin = value;
		}
		
		[Inspectable(type="String")] 
		public function get data():String {
			return _data;
		}
		public function set data(value:String):void {
			if(value == null || value == "") return;
			if(isLivePreview) return;
			_data = value;
			setTimeout(delayInvoke,500);
		}
		
		private function delayInvoke():void {
			config.css = css;
			config.skin = skin;
			config.data = data;
			chart.chartConfig = config;
			chart.loadAssets();
		}
		
		override protected function configUI():void {
			super.configUI();
		}
		
		override protected function draw():void {
			this.graphics.clear();
			this.graphics.beginFill(0x000000,0.2);
			this.graphics.drawRect(0,0,width,height);
			this.graphics.endFill();
			chart.width = width;
			chart.height = height;
			super.draw();
		}
		
	}
	
}
