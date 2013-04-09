package com.riameeting.ui.control
{
	import com.riameeting.utils.DPIReset;
	import flash.text.TextFormatAlign;
	
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 文本标签，对TextTield的简单封装
	 * @author Finger
	 * 
	 */	
	public class Label extends Sprite
	{
		public var lastColor:uint;
		/**
		 * 内部的TextField对象
		 */		
		protected var innerTxt:TextField;		
		private var _text:String;
		private var _color:uint;
		/**
		 * 是否采用HTML方式显示文本
		 */		
		public var htmlMode:Boolean;
		/**
		 * 要显示的文本
		 * @return 文本
		 * 
		 */
		public function get text():String{return _text;}
		public function set text(value:String):void
		{
			_text = value;
			if(htmlMode) {
				innerTxt.htmlText = _text;
			} else {
				innerTxt.text = _text;
			}
			innerTxt.width = innerTxt.textWidth + 8;
			innerTxt.height = innerTxt.textHeight + 8;
			this.width=innerTxt.width;
			this.height = innerTxt.height;
		}
		/**
		 * 文本颜色
		 * @return 颜色值
		 * 
		 */
		public function get color():uint{return _color;}
		public function set color(value:uint):void{_color = value;innerTxt.textColor = value;}
		/**
		 * 构造方法
		 * @param htmlMode 是否启用HTML显示模式
		 * 
		 */		
		public function Label(htmlMode:Boolean=false)
		{
			this.htmlMode = htmlMode;
			innerTxt = new TextField();
			innerTxt.width = innerTxt.height = 20;
			innerTxt.selectable = false;
			innerTxt.mouseEnabled = false;
			var tf:TextFormat = innerTxt.defaultTextFormat;
			tf.size = 11;  //DPIReset.getNumber(16);
			/*for each(var f:* in Font.enumerateFonts()) {
				tf.font = f.fontName;
				innerTxt.embedFonts = true;
			}*/
			//innerTxt.embedFonts = true; 
			tf.font = "Tahoma";
			innerTxt.defaultTextFormat = tf;
			addChild(innerTxt);
			this.width=innerTxt.width;
			this.height = innerTxt.height;
		}
		
		public function setPadding(padding:String):void
		{
			var tf:TextFormat = innerTxt.defaultTextFormat;
			tf.align = padding;
			innerTxt.defaultTextFormat = tf;
		}
		
		public function setWidth(w:Number):void
		{
			innerTxt.width = w;
		}
		
		public function setFontSize(size:int):void
		{
			var tf:TextFormat = innerTxt.defaultTextFormat;
			tf.size = size;
			innerTxt.defaultTextFormat = tf;
		}
		
		public function setFont(fontName:String):void
		{
			var tf:TextFormat = innerTxt.defaultTextFormat;
			tf.font = fontName;
			innerTxt.defaultTextFormat = tf;
		}
		
		/**
		 * 执行清理动作
		 * 
		 */		
		public function clear():void {
			color = 0x000000;
			text = "";
			x = y = 0;
			name = "";
			visible = true;
		}
		
	}
}