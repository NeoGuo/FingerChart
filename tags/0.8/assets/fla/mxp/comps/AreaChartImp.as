package comps {
	
	import com.riameeting.finger.component.*;
	import flash.display.DisplayObject;
	
	public class AreaChartImp extends LineChartImp {

		public function AreaChartImp() {
			chart = new AreaChart(width,height);
			super();
		}

	}
	
}
