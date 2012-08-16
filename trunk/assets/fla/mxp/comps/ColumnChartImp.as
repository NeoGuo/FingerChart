package comps {
	
	import com.riameeting.finger.component.*;
	import flash.display.DisplayObject;
	
	public class ColumnChartImp extends LineChartImp {

		public function ColumnChartImp() {
			chart = new ColumnChart(width,height);
			super();
		}

	}
	
}
