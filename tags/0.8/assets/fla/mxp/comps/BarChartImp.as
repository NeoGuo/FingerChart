package comps {
	
	import com.riameeting.finger.component.*;
	import flash.display.DisplayObject;
	
	public class BarChartImp extends LineChartImp {

		public function BarChartImp() {
			chart = new BarChart(width,height);
			super();
		}

	}
	
}
