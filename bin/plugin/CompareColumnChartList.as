package
{
	import com.as3long.utils.ArrayUtils;
	import com.riameeting.utils.ObjectUtils;
	import flash.display.MovieClip;
	import com.riameeting.finger.plugin.IChartPlugin;
	import com.riameeting.finger.display.container.IPluginContainer;
	import flash.display.DisplayObject;
	import com.riameeting.finger.display.chart.IChart;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.parser.CSVParser;
	import com.riameeting.finger.vo.DatasetVO;
	
	public class CompareColumnChartList extends MovieClip implements IChartPlugin
	{
		
		private var Container:IPluginContainer;
		private var dataset:DatasetVO;
		private var chartRef:IChart;
		private var style:Object;
		private var btnArr:Array = [];
		private var firstFleg:Boolean = false;
		
		public function CompareColumnChartList()
		{
			// constructor code
		}
		
		/**
		 * 初始化插件
		 * @param container 插件容器
		 *
		 */
		public function initPlugin(container:IPluginContainer):void
		{
			if (firstFleg == true)
			{
				return;
			}
			firstFleg = true;
			this.Container = container;
			chartRef = container.chartRef;
			dataset = container.dataset;
			style = chartRef['chartGlobal'].colorCollection;
			if (chartRef['chartGlobal'].baseDataSet == null)
			{
				trace("baseDataSet");
				chartRef['chartGlobal'].baseDataSet = new Object();
				chartRef['chartGlobal'].baseDataSet.config = ObjectUtils.clone(container.dataset.config);
			}
			var i:int = 0;
			var j:int = 0;
			
			//trace(dataset.config.yField);
			//return;
			var yField:Array = String(dataset.config.yField).split(",", 10);
			var qualifierStr:String = String(dataset.config.qualifier);
			var bottonListView:CompareColumnChartListView = new CompareColumnChartListView();
			bottonListView.y = stage.stageHeight - bottonListView.height;
			bottonListView.setTextArr(yField);
			addChild(bottonListView);
			var buttonLength:Number = 0;
			//trace(dataset.config.categoryField)
			//trace(stage.stageHeight, this.y);
			for (i = 0; i < dataset.collectionPrototype.length; i++)
			{
				var btn:CompareColumnChartButton = new CompareColumnChartButton();
				btn.name = i.toString();
				btn.addEventListener(MouseEvent.CLICK, btn_click_hander);
				btn.setText(dataset.collectionPrototype[i][dataset.config.categoryField]);
				btnArr.push(btn);
				buttonLength += btn.width + 5;
				btn.y = 15;
				bottonListView.addChild(btn);
			}
			
			var btnAll:CompareColumnChartButton = new CompareColumnChartButton();
			btnAll.setText("全部");
			btnAll.y = 15;
			buttonLength += btnAll.width + 25;
			btnArr.push(btnAll);
			btnAll.addEventListener(MouseEvent.CLICK, btnAll_click_hander);
			bottonListView.addChild(btnAll);
			btnArr[0].x = stage.stageWidth - buttonLength;
			for (i = 1; i < btnArr.length; i++)
			{
				btnArr[i].x = btnArr[i - 1].x + 5 + btnArr[i - 1].width;
			}
		}
		
		private function btn_click_hander(e:MouseEvent):void 
		{
			var obj:*;
			if (e.target.selected == true)
			{
				if (ckeckBtn())
				{
					obj= dataset.collectionPrototype[int(e.target.name)];
					ArrayUtils.delObj(dataset.collection, obj);
					Container.chartRef.dataset = Container.chartRef.dataset;
				}
				else
				{
					e.target.selected = false;
				}
			}
			else
			{
				obj = dataset.collectionPrototype[int(e.target.name)];
				var collection:Array = [];
				var fleg:Boolean = false;;
				for (var i:int = 0; i < dataset.collection.length; i++)
				{
					var index:int = dataset.collectionPrototype.indexOf(dataset.collection[i]);
					if (index > int(e.target.name))
					{
						collection.push(obj);
						fleg = true;
						break;
					}
					else
					{
						collection.push(dataset.collection[i]);
					}
				}
				if (fleg == false)
				{
					collection.push(obj);
				}
				else
				{
					for (i; i < dataset.collection.length; i++)
					{
						collection.push(dataset.collection[i]);
					}
				}
				dataset.collection =ArrayUtils.clone(collection);
				//dataset.collection.push(obj);
				Container.chartRef.dataset = Container.chartRef.dataset;
			}
		}
		
		private function ckeckBtn():Boolean
		{
			var j:int = 0;
			for (var i:int = 0; i < btnArr.length; i++)
			{
				if (btnArr[i].selected == false)
				{
					j++;
				}
			}
			if (j <= 1)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		private function btnAll_click_hander(e:MouseEvent):void 
		{
			var i:int = 0;
			for (i = 0; i < btnArr.length; i++)
			{
				btnArr[i].selected = false;
			}
			dataset.collection=ArrayUtils.clone(dataset.collectionPrototype);
			Container.chartRef.dataset = Container.chartRef.dataset;
		}
		
		/**
		 * 更新显示列表
		 * @param width 宽度
		 * @param height 高度
		 *
		 */
		public function updateDisplayList(width:uint, height:uint):void
		{
		
		}
	}

}