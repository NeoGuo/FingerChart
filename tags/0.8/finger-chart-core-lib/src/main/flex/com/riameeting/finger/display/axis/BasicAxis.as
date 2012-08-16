package com.riameeting.finger.display.axis
{
	import com.riameeting.finger.display.chart.IChart;
	import com.riameeting.finger.factory.ObjectFactory;
	import com.riameeting.finger.vo.DatasetVO;
	import com.riameeting.ui.control.Alert;
	import com.riameeting.ui.control.Label;
	import com.riameeting.utils.ColorUtils;
	import com.riameeting.utils.DrawTool;
	import com.riameeting.utils.NumberTool;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 基础坐标系，支持X和Y方向的定位
	 * @author Finger
	 * 
	 */
	public class BasicAxis extends Sprite implements IAxis
	{
		private var _dataset:DatasetVO;
		private var _chartRef:IChart;
		/**
		 * 对Chart的 引用
		 * @return 
		 * 
		 */	
		public function get chartRef():IChart {return _chartRef;}
		public function set chartRef(value:IChart):void {_chartRef=value;}
		/**
		 * 坐标系宽度
		 */		
		public var axisWidth:uint;
		/**
		 * 坐标系高度
		 */		
		public var axisHeight:uint;
		/**
		 * 数据在2个轴上的最小值（X轴，Y轴）
		 */		
		public var minValueX:Number = 0,minValueY:Number = 0;
		/**
		 * 数据在2个轴上的最大值（X轴，Y轴）
		 */		
		public var maxValueX:Number = 0,maxValueY:Number = 0;
		/**
		 * 在X轴方向上划分的区块数量
		 */		
		public var countX:uint = 0;
		/**
		 * 在Y轴方向上划分的区块数量
		 */	
		public var countY:uint = 0;
		/**
		 * Y轴定义的数据显示字段，可以为1个或多个
		 */		
		public var yFields:Array;
		/**
		 * X轴定义的数据显示字段，只能是一个
		 */		
		public var xField:String;
		/**
		 * 绘制时，最后计算所得的单元格高度
		 */		
		public var realGridHeight:Number;
		/**
		 * 绘制时，最后计算所得的单元格宽度
		 */		
		public var realGridWidth:Number;
		/**
		 * 坐标系的图形绘制范围
		 */		
		public var graphicArea:Rectangle = new Rectangle(0,0,0,0);
		
		private var _style:Object = {gridHeight:50,paddingLeft:40,paddingTop:30,paddingRight:20,paddingBottom:50,offsetV:20,color:0x000000,lineColors:[0x000000,0x000000],lineAlphas:[0,100],lineWidth:2};
		private var _skin:MovieClip;
		/**
		 * 设置为true,则偏移与单元格相同
		 */		
		public var ignoreOffsetV:Boolean;
		
		/**
		 * 坐标系的CSS样式定义
		 * @return 对象
		 * 
		 */
		public function get style():Object{return _style;}
		public function set style(value:Object):void{_style = value;}
		/**
		 * 皮肤定义
		 * @return 
		 * 
		 */		
		public function get skin():MovieClip {return _skin;}
		public function set skin(value:MovieClip):void {if(_skin != null) removeChild(_skin);_skin = value;_skin.hostComponent=this;addChildAt(_skin,0);}
		/**
		 * 宽度
		 * @return 
		 * 
		 */		
		override public function get width():Number {return axisWidth;}
		override public function set width(value:Number):void {axisWidth = value;}
		/**
		 * 高度
		 * @return 
		 * 
		 */		
		override public function get height():Number {return axisHeight;}
		override public function set height(value:Number):void {axisHeight = value;}
		/**
		 * 坐标系中对数据源的引用
		 * @return DatasetVO引用
		 * 
		 */
		public function get dataset():DatasetVO{return _dataset;}
		public function set dataset(value:DatasetVO):void
		{
			_dataset = value;
			xField = _dataset.config["xField"];
			yFields = _dataset.config["yField"].split(",");
		}
		/**
		 * 当数据传入之后，需要计算各个轴上的取值范围（最小为0，最大则需要循环计算）
		 * 
		 */
		protected function calculateMaxValue():void {
			var i:uint=0,j:uint=0,obj:Object;
			if(_dataset.config["minValueX"] != null) {
				minValueX = _dataset.config["minValueX"];
			} else {
				minValueX = 0;
			}
			if(_dataset.config["maxValueX"] != null) {
				maxValueX = _dataset.config["maxValueX"];
			} else {
				maxValueX = 0;
			}
			if(_dataset.config["minValueY"] != null) {
				minValueY = _dataset.config["minValueY"];
			} else {
				minValueY = 0;
			}
			if(_dataset.config["maxValueY"] != null) {
				maxValueY = _dataset.config["maxValueY"];
			} else {
				maxValueY = 0;
			}
			//x
			if(xField != null) {
				if(yFields.length != 1) {
					Alert.show("you must define 1 y fileds with xField mode","Error");
					throw new Error("you must define 1 y fileds with xField mode");
				}
				countX = (graphicArea.width-int(style["offsetV"])*2)/int(style["gridHeight"]);
				//maxXValue
				for(j=0;j<dataset.collection.length;j++) {
					obj = dataset.collection[j];
					if(obj[xField] > maxValueX) {
						maxValueX = obj[xField];
					}
					if(obj[xField] < minValueX) {
						minValueX = obj[xField];
					}
				}
				maxValueX = NumberTool.getMaxNumber(maxValueX);
				minValueX = NumberTool.getMinNumber(minValueX);
			} else {
				countX = dataset.collection.length;
			}
			//y
			for(i=0;i<yFields.length;i++) {
				for(j=0;j<dataset.collection.length;j++) {
					obj = dataset.collection[j];
					obj.doubleArbor = false;
					if(obj[yFields[i]] > maxValueY) {
						maxValueY = obj[yFields[i]];
					}
					if(obj[yFields[i]] < minValueY) {
						minValueY = obj[yFields[i]];
					}
				}
			}
			maxValueY = NumberTool.getMaxNumber(maxValueY);
			minValueY = NumberTool.getMinNumber(minValueY);
			countY = graphicArea.height/int(style["gridHeight"]);
			//ignoreOffsetV
			if(ignoreOffsetV) {
				style["offsetH"] = graphicArea.width/(countX+1);
			}
		}
		/**
		 * 构造方法
		 * 
		 */		
		public function BasicAxis(chartRef:IChart,ignoreOffsetV:Boolean = false)
		{
			_chartRef = chartRef;
			this.ignoreOffsetV = ignoreOffsetV;
			this.cacheAsBitmap = true;
			mouseChildren = false;
			mouseEnabled = false;
		}
		/**
		 * 设置坐标系的宽度和高度
		 * @param w 宽度
		 * @param h 高度
		 * 
		 */		
		protected function initSize(w:uint,h:uint):void {
			axisWidth = w;
			axisHeight = h;
			graphicArea.x = int(style["paddingLeft"]);
			graphicArea.y = int(style["paddingTop"]);
			graphicArea.width = w - int(style["paddingLeft"]) - int(style["paddingRight"]);
			graphicArea.height = h - int(style["paddingTop"]) - int(style["paddingBottom"]);
		}
		/**
		 * 更新显示列表的方法，当Flash场景尺寸发生改变，将调用此方法重绘坐标系
		 * @param w 宽度
		 * @param h 高度
		 * 
		 */		
		public function updateDisplayList(w:uint,h:uint):void {
			initSize(w,h);
			calculateMaxValue();
			//clear
			clear();
			skin.updateDisplayList();
		}
		/**
		 * 获取一个数据对象在坐标系上的坐标点（映射），包含x和y
		 * @param vo 数据对象
		 * @param yField Y轴字段
		 * @return 坐标点
		 * 
		 */	
		public function getPoint(vo:Object,yField:String):Point {
			var targetX:Number;
			var targetY:Number;
			var objIndex:int = dataset.collection.indexOf(vo);
			var currentOffset:Number = ignoreOffsetV ? style["offsetH"]:style["offsetV"];
			if(xField != null) {
				var rw:uint = graphicArea.width - currentOffset*2;
				targetX = graphicArea.x + currentOffset + (vo[xField] - minValueX)/(maxValueX-minValueX)*rw;
			} else {
				targetX = graphicArea.x + currentOffset + objIndex*realGridWidth;
			}
			targetY = graphicArea.y + graphicArea.height*(1-(vo[yField]-minValueY)/(maxValueY-minValueY));
			return new Point(targetX,targetY);
		}
		/**
		 * 基础坐标系不实现此方法
		 * @param vo
		 * @param yField
		 * @return 
		 * 
		 */		
		public function getAngle(vo:Object,yField:String):Object {return null}
		/**
		 * 获取坐标系可见区域的范围
		 * @return 矩形区域
		 * 
		 */	
		public function getAxisRect():Rectangle {
			return graphicArea;
		}
		/**
		 * 当需重绘坐标系的时候，调用此方法
		 * 
		 */		
		public function clear():void {
			this.graphics.clear();
			(_skin as Object).clear();
		}
		
	}
}