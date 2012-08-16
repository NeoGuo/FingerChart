package com.riameeting.ui.control
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 弹出信息显示类
	 * @author Finger
	 * 
	 */
	public class Alert
	{
		/**
		 * 弹出窗口的父层容器
		 */		
		public static var container:Sprite;
		/**
		 * 窗体
		 */		
		private static var window:Window;
		/**
		 * 显示信息
		 * @param value 要显示的字符串
		 * @param title 要显示的标题
		 * 
		 */		
		public static function show(value:String,title:String="alert"):void
		{
			if(container == null) {
				throw new Error("Alert.container not allow null");
			}
			if(window == null) {
				window = new Window();
				window.closeButton.addEventListener(MouseEvent.CLICK,hide);
				window.addEventListener(MouseEvent.MOUSE_DOWN,startMove);
				window.addEventListener(MouseEvent.MOUSE_UP,stopMove);
			}
			container.addChild(window);
			window.title = title;
			window.text = value;
			window.x = (container.stage.stageWidth-window.width)/2;
			window.y = (container.stage.stageHeight-window.height)/2;
			function startMove(e:MouseEvent):void {
				window.startDrag();
			}
			function stopMove(e:MouseEvent):void {
				window.stopDrag();
			}
		}
		/**
		 * 隐藏信息
		 * @param e
		 * 
		 */		
		public static function hide(e:MouseEvent=null):void
		{
			container.removeChild(window);
		}
	}
}
import com.riameeting.ui.control.Button;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

/**
 * 窗体类
 * 
 */
class Window extends Sprite {
	private var titleField:TextField = new TextField();
	private var txtField:TextField = new TextField();
	public var closeButton:Button = new Button();
	public function Window()
	{
		buttonMode = true;
		txtField.width = 200;
		titleField.width = 200;
		txtField.mouseEnabled = false;
		titleField.mouseEnabled = false;
		txtField.y = 20;
		txtField.autoSize = TextFieldAutoSize.LEFT;
		txtField.wordWrap = true;
		addChild(txtField);
		addChild(titleField);
		addChild(closeButton);
		closeButton.x = 100-closeButton.width/2;
		closeButton.label = "Close";
	}
	/**
	 * 设置标题显示
	 * @param value
	 * 
	 */	
	public function set title(value:String):void {
		titleField.htmlText = "<b><font color='#FFFFFF'>"+value+"</font></b>";
	}
	/**
	 * 设置文本内容显示
	 * @param value
	 * 
	 */	
	public function set text(value:String):void {
		txtField.htmlText = "<font color='#FF0000'>"+value+"</font>";
		txtField.height = txtField.textHeight + 5;
		closeButton.y = txtField.y + txtField.height;
		graphics.clear();
		graphics.lineStyle(3,0xFF0000,1);
		graphics.beginFill(0xFF0000,1);
		graphics.drawRoundRect(0,0,200,24,4,4);
		graphics.endFill();
		graphics.beginFill(0x000000,1);
		graphics.drawRoundRect(0,20,200,txtField.height+closeButton.height+4,4,4);
		graphics.endFill();
	}
	
}