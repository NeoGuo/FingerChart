package comps {
	
	import com.riameeting.finger.component.*;
	import flash.display.DisplayObject;
	
	public class PlotChartImp extends LineChartImp {

		public function PlotChartImp() {
			chart = new PlotChart(width,height);
			super();
		}

	}
	
}
