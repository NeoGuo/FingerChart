package com.riameeting.finger.parser
{
	
	import com.riameeting.utils.StringUtils;
	
	/**
	 * CSS解析器
	 * 
	 */	
	public class CSSParser {
		
		private var _css:Object;
		
		/**
		 * 构造方法
		 */
		public function CSSParser() {
			_css = {};
		}
		
		/**
		 * 解析CSS到对象
		 * @param	cssStr
		 */
		public function parseCSS(cssStr:String):void {
			var cssArr:Array = cssStr.match(/([\w \.:\#]+\{.+?\})/gs); //split all slectors{properties:values}
			parseSelectors(cssArr);
		}
		
		/**
		 * 解析CSS选择器和属性
		 * @param	cssArr	Array<String>
		 */
		private function parseSelectors(cssArr:Array):void {
			var selector:String;
			var properties:String;
			var n:int = cssArr.length;
			for (var i:int = 0; i < n; i++) {
				selector = StringUtils.trim(cssArr[i].match(/.+(?=\{)/g)[0]); //everything before {
				properties = cssArr[i].match(/(?<=\{).+(?=\})/g)[0]; //everything inside {}
				setStyle(selector, parseProperties(properties));
			}
		}
		
		/**
		 * 转换属性的字符串到对象
		 * @param	propStr
		 */
		private function parseProperties(propStr:String):Object {
			var result:Object = {};
			var properties:Array = propStr.match(/\b\w[\w-:\#\/ ,]+/g); //split properties
			var curProp:Array;
			var n:int = properties.length;
			for (var j:int = 0; j < n; j++) {
				curProp = properties[j].split(":");
				result[StringUtils.toCamelCase(curProp[0])] = StringUtils.trim(curProp[1]);
				if(curProp[1].split(" ").length > 1) {
					result[StringUtils.toCamelCase(curProp[0])] = [];
					for each(var value:String in curProp[1].split(" ")) {
						result[StringUtils.toCamelCase(curProp[0])].push(value);
					}
				}
			}
			return result;
		}
		
		/**
		 * 获取所有选择器的引用的数组
		 */
		public function get selectors():Array {
			var selectors:Array = [];
			for (var prop:* in _css) {
				selectors.push(prop);
			}
			return selectors;
		}
		
		/**
		 * 通过选择器获取一个样式对象的引用
		 */
		public function getStyle(selector:String):Object { return _css[selector]; }
		
		/**
		 * 设置样式
		 * @param	selector
		 * @param	styleObj
		 */
		public function setStyle(selector:String, styleObj:Object):void {
			if (_css[selector] === undefined) _css[selector] = { };
			_css[selector] = styleObj;
		}
		
		/**
		 * 删除所有的选择器和属性
		 */
		public function clear():void { _css = {}; }
		
	}
	
}
