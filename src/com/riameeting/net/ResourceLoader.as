package com.riameeting.net
{
	import com.riameeting.ui.control.Alert;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * 资源加载类
	 * @author Finger
	 *
	 */
	public class ResourceLoader
	{
		private var callBackFunc:Function;
		private var assetsArr:Array;
		private var loadedArr:Array=[];
		/**
		 * 资源哈希表
		 */
		public var fileDict:Dictionary = new Dictionary();
		
		/**
		 * 加载资源
		 * @param assets 资源地址列表
		 * @param callBack 回调
		 *
		 */
		public function loadAssets(assets:Array, callBack:Function):void
		{
			callBackFunc = callBack;
			assetsArr = assets;
			for (var i:int = 0; i < assetsArr.length; i++)
			{
				load(assetsArr[i]);
				assetsArr.splice(i, 1);
				break;
			}
		}
		
		private function load(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			if (getFileExtension(url) == "swf")
			{
				loader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(url));
			fileDict[loader] = url;
		}
		
		/**
		 * 获取文件扩展名
		 * @param fileName
		 * @return
		 *
		 */
		public function getFileExtension(fileName:String):String
		{
			var dotSpitArr:Array = fileName.split(".");
			return dotSpitArr[dotSpitArr.length - 1];
		}
		
		/**
		 * 加载成功
		 * @param e
		 *
		 */
		private function completeHandler(e:Event):void
		{
			var url:String = fileDict[e.currentTarget];
			fileDict[url] = e.currentTarget.data;
			checkStatus();
		}
		
		/**
		 * 加载失败
		 * @param e
		 *
		 */
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			Alert.show(e.toString()+e.text, "IOError");
		}
		
		/**
		 * 检查整体加载状况
		 *
		 */
		private function checkStatus():void
		{
			for each (var url:String in assetsArr)
			{
				if (fileDict[url] == null)
					loadAssets(assetsArr, callBackFunc);
					return;
			}
			callBackFunc.apply();
		}
	}
}