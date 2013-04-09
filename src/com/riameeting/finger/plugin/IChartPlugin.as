package com.riameeting.finger.plugin
{
	import com.riameeting.finger.display.container.IPluginContainer;
	/**
	 * 图表插件的接口
	 * @author Finger
	 * 
	 */
	public interface IChartPlugin
	{
		/**
		 * 初始化插件
		 * @param container 插件容器
		 * 
		 */		
		function initPlugin(container:IPluginContainer):void;
		/**
		 * 更新显示列表
		 * @param width 宽度
		 * @param height 高度
		 * 
		 */		
		function updateDisplayList(width:uint,height:uint):void;
	}
}