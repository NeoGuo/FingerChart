package
{
	import com.riameeting.finger.component.*;
	import com.riameeting.finger.display.legend.*;
	
	import flash.events.Event;

	
	[SWF(backgroundColor="#FFFFFF",pageTitle="AreaChart")]
	/**
	 * 区域图
	 * 
	 * <p>Website:<a href="http://www.riameeting.com/fingerchart">http://www.riameeting.com/fingerchart</a></p>
	 * <p>在线交流QQ群:72916285</p>
	 * @author RIAMeeting
	 * 
	 */	
	public class area_chart extends ChartWrapper
	{
		/**
		 * 构造方法
		 * 
		 */		
		public function area_chart() {
			super();
		}
		/**
		 * 初始化方法，将创建图表，并加载外部文件
		 * @param e
		 * 
		 */		
		override protected function init(e:Event=null):void {
			chart = new AreaChart(stage.stageWidth,stage.stageHeight);
			if(chartConfig["legend"] != null) {
				legend = new SlideLegend(chart,"rect",200,stage.stageHeight);
			}
			super.init(e);
		}
	}
}