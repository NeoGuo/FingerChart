package comps {
	
	import com.riameeting.finger.component.*;
	import flash.display.DisplayObject;
	
	public class BubbleChartImp extends LineChartImp {

		public function BubbleChartImp() {
			chart = new BubbleChart(width,height);
			super();
		}

	}
	
}
