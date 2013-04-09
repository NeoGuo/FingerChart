package  {
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.printing.PrintJob;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	
	import com.riameeting.finger.config.ChartGlobal;
	import com.riameeting.finger.parser.CSVParser;
	import com.riameeting.finger.vo.DatasetVO;
	
	import flash.display.MovieClip;
	import com.riameeting.finger.plugin.IChartPlugin;
	import com.riameeting.finger.display.container.IPluginContainer;
	import flash.display.DisplayObject;
	import com.riameeting.finger.display.chart.IChart;
	
	
	public class context_menu extends MovieClip implements IChartPlugin {
		
		private var container:IPluginContainer;
		private var myContextMenu:ContextMenu;
		private var dataset:DatasetVO;
		private var chartRef:IChart;
		
		public function context_menu() {
			
		}
		
		public function initPlugin(container:IPluginContainer):void {
			this.container = container;
			chartRef = container.chartRef;
			dataset = container.dataset;
			myContextMenu = new ContextMenu();
			(chartRef as Sprite).contextMenu = myContextMenu;
			myContextMenu.hideBuiltInItems();
			var versionMenu:ContextMenuItem = new ContextMenuItem("Finger Chart, version: "+ChartGlobal.version);
			versionMenu.enabled = false;
			myContextMenu.customItems.push(versionMenu);
			var fullscreenMenu:ContextMenuItem = new ContextMenuItem("全屏",true);
			fullscreenMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fullscreenHandler);
			myContextMenu.customItems.push(fullscreenMenu);
			var saveMenu:ContextMenuItem = new ContextMenuItem("保存为位图",false);
			saveMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, saveHandler);
			myContextMenu.customItems.push(saveMenu);
			var saveCSVMenu:ContextMenuItem = new ContextMenuItem("保存为CSV",false);
			saveCSVMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, saveCSVHandler);
			myContextMenu.customItems.push(saveCSVMenu);
			var printMenu:ContextMenuItem = new ContextMenuItem("打印",false);
			printMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, printHandler);
			myContextMenu.customItems.push(printMenu);
			var viewDataMenu:ContextMenuItem = new ContextMenuItem("查看源数据",false);
			viewDataMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, viewDataSource);
			myContextMenu.customItems.push(viewDataMenu);
			var helpMenu:ContextMenuItem = new ContextMenuItem("www.riameeting.com/fingerchart",true);
			helpMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, getHelpLink);
			myContextMenu.customItems.push(helpMenu);
			var dateMenu:ContextMenuItem = new ContextMenuItem("最后更新日期:"+ChartGlobal.buildDate,true);
			dateMenu.enabled = false;
			myContextMenu.customItems.push(dateMenu);
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK,fullscreenHandler);
		}
		
		private function fullscreenHandler(e:Event):void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		private function saveHandler(e:ContextMenuEvent):void {
			var bmd:BitmapData = new BitmapData(stage.width,stage.height);
			bmd.draw(chartRef as DisplayObject);
			var bmdBytes:ByteArray = PNGEncoder.encode(bmd);
			var saveFile:FileReference = new FileReference();
			saveFile.save(bmdBytes,getDate()+".png");
		}
		
		private function saveCSVHandler(e:ContextMenuEvent):void {
			var csvStr:String = CSVParser.encode(dataset);
			var csvBytes:ByteArray = new ByteArray();
			csvBytes.writeUTFBytes(csvStr);
			var saveFile:FileReference = new FileReference();
			saveFile.save(csvBytes,getDate()+".csv");
		}
		
		private function printHandler(e:ContextMenuEvent):void {
			var myPrintJob:PrintJob=new PrintJob();
			if(myPrintJob.start()) {
				try{
					myPrintJob.addPage(chartRef as Sprite);
				}catch(error:Error){
					trace("Print Error");
				}
				myPrintJob.send();
			}		
		}
		
		private function viewDataSource(e:ContextMenuEvent):void {
			navigateToURL(new URLRequest(chartRef.chartConfig["data"]));
		}
		
		private function getHelpLink(e:ContextMenuEvent):void {
			navigateToURL(new URLRequest("http://www.riameeting.com/fingerchart"),"_blank");
		}
		
		private function getDate():String {
			var dateStr:String = "finger_";
			var date:Date = new Date();
			dateStr += date.getFullYear()+"-";
			dateStr += date.getMonth()+1+"-";
			dateStr += date.getDate();
			return dateStr;
		}
		
		public function updateDisplayList(w:uint,h:uint):void {
			
		}
		
	}
	
}
