/**
* @todo：Finger Chart图形报表
* @date：2008-7-3 16:38
* @author：finger,lovejes(http://lovejes.javaeye.com/)
* @remark
			yTitle：必须，定义y轴的显示文本 
			categoryField：必须，但不可与xField同时使用，定义x轴的显示字段（类型为文本），用于线图，柱图，条图，饼图，区域图 
			xField：必须，但不可与categoryField同时使用，定义x轴的显示字段（类型必须为数值），用于散点图和气泡图 
			yField：必须，定义y轴的显示字段，可以为多个，用逗号相隔 
			zField：可选，适用于用于Z轴的图表类型，比如气泡图 
			benchmark：可选，定义参考线的显示字段，参考线为一条灰色折线
*/
finger = {
	baseURL : ""
	,params : {allowscriptaccess:"always",allowFullScreen:"true"}
	,attributes : {id:"chartSWF",name:"chartSWF"}
	,initPath : function(path){
		this.baseURL = path;
	}
	,setJSONData:function(chartType,container,obj,width,height,chartId,compare){
		var i=0;j=0;
		var labelArr=new Array();
		var dataStr=finger.objToStr(obj);
		var oElement=document.getElementById(container);
		if(chartId==null||chartId==""){chartId=container+"_chart";}
		this.attributes.id = chartId;this.attributes.name = chartId;
		oElement.innerHTML="<div id='"+chartId+"'></div>";
		finger.output(chartType,chartId,dataStr,width,height);
	}
	/**
	* @todo：输出图形报表
	* @date：2008-7-3 16:38
	* @author：finger,lovejes
	* @param chartType: 图表类型，包括：line,column,bar,pie,area,plot,bubble
	* @param container: 图表容器ID
	* @param data: 支持xml,txt...或者直接封装json数据
	* @param extendConfig: (可选)是配置对象，比如{plugin:"xx.swf"}
	*/
	,output: function(chartType,container,data,width,height,extendConfig) {
		var configObj = {legend:"selectable"};
		configObj['type']=chartType;
		if(data.indexOf("config") !=-1  && data.indexOf("dataset") !=-1) configObj["dataStr"]= encodeURI(data);
		else configObj["data"]= data;
		var swfURL = this.baseURL+"chart.swf";
		configObj.baseUrl=this.baseURL;
		for(var node in extendConfig) {configObj[node] = extendConfig[node];}
		if(configObj.id) {this.attributes.id = configObj.id;this.attributes.name = configObj.id}
		if(width==null||width==""){width="100%";}
		if(height==null||height==""){height="100%";}
		swfobject.embedSWF(swfURL,container,width ,height, "9.0.0", "playerProductInstall.swf",configObj, this.params,this.attributes);
	}
	
	/**
	* @todo：JS获取图形报表JsonData
	* @date：2010-12-20 11:04
	* @author：lovejes
	* @param config: 传入：{"yTitle":"访问数","categoryField":"日期","yField":"","benchmark":""};
					 yTitle: 必须
					 categoryField ：必须
					 yField ：""
					 benchmark ：可以"" 或者是"参考线" 那么图形就会显示出来参考线
	* @param dataset: 传入: 
						{"日期":"6月1日","参考线":"100","杭州":"110","宁波":"120","温州":"130","台州":"110","丽水":"120","绍兴":"110"}
						{"日期":"6月2日","参考线":"100","温州":"130","台州":"120","杭州":"150","宁波":"110","丽水":"110","绍兴":"130"}
						{"日期":"6月3日","参考线":"100","杭州":"130","宁波":"130","温州":"130","台州":"130","绍兴":"130"}
						{"日期":"6月4日","参考线":"100","绍兴":"130"}
						...
	* @param _defData: 这个数据主要封装成yField用，支持排序
					   传入：{"杭州":"1","丽水":"5","绍兴":"6","宁波":"2","温州":"3","台州":"4"}
					   1,2,3,4,5,6 是排序号，顺序可以乱，如果不要排序，默认可以为0
					   这样解析就是yField="杭州,宁波,温州,台州,丽水,绍兴"
	* @param _defVal:  比如6月4号 杭州,宁波,温州等没有数据,传入一个默认值:0
	* @remark 线图，柱图，条图，饼图 已经通过测试,其它会尽快更新
	*/
	,getJsonData : function(config,dataset,_defData,_defVal){
		var _defArr = new Array();
		for(pop in _defData){
			_defArr.push(_defData[pop]+"_"+pop);
		}
		_defArr.sort(function(a,b){//从小到大排序
			a = parseInt(a.split("_")[0]);
			b = parseInt(b.split("_")[0]);
			return a-b;
		})
		var yField = "";
		for(var n=0;n<_defArr.length;n++){
			//alert(_defArr[n]);
			if(n==0) yField += _defArr[n].split("_")[1];
			else yField += ","+_defArr[n].split("_")[1];
		}
		if(config["benchmark"] && config["benchmark"] != "") yField += ","+config["benchmark"];//是否需要参考线
		config["yField"]=yField;
		for(var i=0;i<dataset.length;i++){
			for(pop in _defData){
				dataset[i][pop] = (dataset[i][pop])?dataset[i][pop]:_defVal;
			}
		}
		return {config:config,dataset:dataset};
	}
	/**
	* @todo: obj转成str
	* @data: 2010-12-20 11:21
	* @author：lovejes
	*/
	,objToStr : function(obj){
	    try{
			if(obj instanceof Array){
				var r = [];
				for (var i=0;i<obj.length;i++) r.push(arguments.callee(obj[i]));
				return "[" + r.join() + "]";
			}else if (typeof obj == 'string'){
				return "\"" + obj.replace("\"", "'").replace(/([\'\"\\])/g, "\\$1").replace(/(\n)/g, "\\n").replace(/(\r)/g, "\\r").replace(/(\t)/g, "\\t") + "\"";
			}else if (typeof obj == 'number'){
				return obj.toString();
			}else if (typeof obj == 'object'){
				if(obj == null){
					return ''
				}else{
					var r = [];
					for (var i in obj) r.push("\"" + i + "\":" + arguments.callee(obj[i]));
					return "{" + r.join() + "}";
				}
			}else if(typeof obj == 'boolean'){
				return obj + '';
			}else{
				return '';
			}
	    }catch(e){
			return '';
	    }
	}
	/**
	* @todo: 动态添加数据节点
	* @data: 2010-12-26 19:23
	* @parm policy : add, replace
	* @author：Neo
	*/
	,addData:function(id,data,policy){
		var swfobj = swfobject.getObjectById(id);
		if(swfobj) swfobj.addData(data,policy);
	}
}