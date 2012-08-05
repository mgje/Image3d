/**
* Parses RSS, ATOM and XSPF lists and returns them as a numerical array:
* [title,author,file,link,image,category,id,start,description,date,latitude,longitude]
* An onParseComplete event is broadcasted upon succesful completion.
*
* @example
* var prs = new com.jeroenwijering.utils.FeedParser();
* prs.onParseComplete = function() { trace(this.parseArray.length); };
* prs.parse("http://www.jeroenwijering.com/rss/");
*
* @author	Jeroen Wijering
* @version	1.19
**/


class com.jeroenwijering.utils.FeedParser {


	/** URL of the xml file to parse. **/
	private var parseURL:String;
	/** The array the XML is parsed into **/
	public var parseArray:Array; 
	/** Flash XML object the file is loaded into. **/
	private var parseXML:XML;
	/** Tags allowed for RSS Format **/
	private var RSS_TAGS:Object = {
		title:"title",
		author:"author",
		link:"link",
		guid:"id",
		category:"category"
	};
	/** Tags allowed for ATOM Format **/
	private var ATOM_TAGS:Object = {
		title:"title",
		id:"id"
	};
	/** Tags allowed for XSPF Format **/
	private var XSPF_TAGS:Object = {
		title:"title",
		creator:"author",
		info:"link",
		location:"file",
		image:"image",
		identifier:"id",
		album:"category"
	};
	/** Supporting array to translate RFC2822 months to number. **/
	private var MONTHS_TO_INTEGERS:Object = {
		January:0,February:1,March:2,April:3,May:4,June:5,
		July:6,August:7,September:8,October:9,November:10,December:11,
		Jan:0,Feb:1,Mar:2,Apr:3,May:4,Jun:5,Jul:6,Aug:7,Sep:8,Oct:9,Nov:10,Dec:11
	};
	/** Timezone abbreviation offsets **/
	private var TIMEZONE_OFFSETS:Object = {
		IDLW:-12,NT:-11,AHST:-10,CAT:-10,HST:-10,YST:-9,PST:-8,MST:-7,PDT:-7,CST:-6,EST:-5,
		EDT:-4,ADT:-3,WBT:-4,AST:-4,NT:-3.5,EBT:-3,AT:-2,WAT:-1,UTC:0,UT:0,GMT:0,WET:0,CET:1,
		CEST:1,EET:2,EEDT:3,MSK:3,IRT:3.5,SAMT:4,YEKT:5,TMT:5,TJT:5,OMST:6,NOVT:6,LKT:6,
		MMT:6.5,KRAT:7,ICT:7,WIT:7,WAST:7,IRKT:8,ULAT:8,CST:8,CIT:8,BNT:8,YAKT:9,JST:9,KST:9,
		EIT:9,ACST:9.5,VLAT:10,ACDT:10.5,SAKT:10,GST:10,MAGT:11,IDLE:12,PETT:12,NZST:12
	};


	/** Constructor. Nothing there but a crappy hack to support tags with a ':' included **/
	function FeedParser() {
		RSS_TAGS["itunes:author"] = "author";
		RSS_TAGS["geo:lat"] = "latitude";
		RSS_TAGS["geo:long"] = "longitude"; 
		ATOM_TAGS["geo:lat"] = "latitude";
		ATOM_TAGS["geo:long"] = "longitude";
	};


	/** 
	* Parse an XML list.
	*
	* @param url	URL of the playlist that should be parsed.
	**/
	public function parse(url:String):Void {
		var ref = this;
		parseURL = url;
		parseArray = new Array();
		parseXML = new XML();
		parseXML.ignoreWhite = true;
		parseXML.onLoad = function(success:Boolean) {
			if(success) {
				var fmt = this.firstChild.nodeName.toLowerCase();
				if( fmt == 'rss') {	ref.parseRSS();} 
				else if (fmt == 'feed') { ref.parseASF(); } 
				else if (fmt == 'playlist') { ref.parseXSPF(); } 
				else { parseArray.push({title:"Feed not understood: "+ref.parseURL}); }
			} else {
				parseArray.push({title:"Feed not found: "+ref.parseURL});
			}
			parseArray.length == 0 ? parseArray.push({title:"Empty feed: "+ref.parseURL}):null;
			delete ref.parseXML;
			ref.onParseComplete();
		};
		if(_root._url.indexOf("file://") > -1) { parseXML.load(parseURL); } 
		else if(parseURL.indexOf('?') > -1) { parseXML.load(parseURL+'&'+random(999)); } 
		else { parseXML.load(parseURL+'?'+random(999)); }
	};


	/** Convert RSS structure to array. **/
	private function parseRSS():Void {
		var tpl = parseXML.firstChild.firstChild.firstChild;
		while(tpl != null) { 
			if (tpl.nodeName.toLowerCase() == "item") {
					var obj = new Object();
					for(var j=0; j<tpl.childNodes.length; j++) {
						var nod:XMLNode = tpl.childNodes[j];
						if(RSS_TAGS[nod.nodeName.toLowerCase()] != undefined) {
							obj[RSS_TAGS[nod.nodeName.toLowerCase()]] = nod.firstChild.nodeValue;
						} else if(nod.nodeName.toLowerCase() == "description") {
							obj["description"] = stripTagsBreaks(nod.firstChild.nodeValue);
						} else if(nod.nodeName.toLowerCase() == "pubdate") {
							obj["date"] = rfc2Date(nod.firstChild.nodeValue);
						} else if(nod.nodeName.toLowerCase() == "dc:date") {
							obj["date"] = iso2Date(nod.firstChild.nodeValue);
						} else if(nod.nodeName.toLowerCase() == "media:thumbnail") {
							obj["image"] = nod.attributes.url;
						} else if(nod.nodeName.toLowerCase() == "itunes:image") {
							obj["image"] = nod.attributes.href;
						} else if((nod.nodeName.toLowerCase() == "enclosure" || nod.nodeName.toLowerCase() == "media:content") && 
								 (nod.attributes.type == "audio/mpeg" || nod.attributes.type == "video/x-flv"
								 || nod.attributes.type == "image/jpeg" || nod.attributes.type == "image/png"
								 || nod.attributes.type == "image/gif")) {
							obj["file"] = nod.attributes.url;
						} else if(nod.nodeName.toLowerCase() == "media:group") { 
							for(var k=0; k< nod.childNodes.length; k++) {
								nod.childNodes[k].attributes.type == "video/x-flv" ? obj["file"] = nod.childNodes[k].attributes.url: null;
								nod.childNodes[k].nodeName.toLowerCase() == "media:thumbnail" ? obj["image"] = nod.childNodes[k].attributes.url: null;
							}
						}
					}
					if(obj["latitude"] == undefined && lat != undefined) {
						obj["latitude"] = lat;
						obj["longitude"] = lng;
					} 
					obj["image"] == undefined && obj["file"].indexOf(".jpg") > 0 ? obj["image"] = obj["file"]: null;
					obj["author"] == undefined ? obj["author"] = ttl: null;
					parseArray.push(obj);
			} else if (tpl.nodeName == "title") { var ttl = tpl.firstChild.nodeValue; }
			else if (tpl.nodeName == "geo:lat") { var lat = tpl.firstChild.nodeValue; }
			else if (tpl.nodeName == "geo:long") { var lng = tpl.firstChild.nodeValue; }
			tpl = tpl.nextSibling;
		}
	};


	/** Convert ATOM structure to array **/
	private function parseASF():Void {
		var tpl = parseXML.firstChild.firstChild;
		while(tpl != null) {
			if (tpl.nodeName.toLowerCase() == "entry") {
					var obj = new Object();
					for(var j=0; j<tpl.childNodes.length; j++) {
						var nod:XMLNode = tpl.childNodes[j];
						if(ATOM_TAGS[nod.nodeName.toLowerCase()] != undefined) {
							obj[ATOM_TAGS[nod.nodeName.toLowerCase()]] = nod.firstChild.nodeValue;
						} else if(nod.nodeName.toLowerCase() == "link" && nod.attributes.rel == "alternate") {
							obj["link"] =  nod.attributes.href;
						} else if(nod.nodeName.toLowerCase() == "summary") {
							obj["description"] = stripTagsBreaks(nod.firstChild.nodeValue);
						} else if(nod.nodeName.toLowerCase() == "published") {
							obj["date"] = iso2Date(nod.firstChild.nodeValue);
						} else if(nod.nodeName.toLowerCase() == "updated") {
							obj["date"] = iso2Date(nod.firstChild.nodeValue);
						} else if(nod.nodeName.toLowerCase() == "modified") {
							obj["date"] = iso2Date(nod.firstChild.nodeValue);
						} else if(nod.nodeName.toLowerCase() == "category") {
							obj["category"] = nod.attributes.term;
						} else if(nod.nodeName.toLowerCase() == "author") { 
							for(var k=0; k< nod.childNodes.length; k++) {
								nod.childNodes[k].nodeName.toLowerCase() == "name" ? obj["author"] = nod.childNodes[k].firstChild.nodeValue: null;
							}
						} else if((nod.nodeName.toLowerCase() == "link" && nod.attributes.rel == "enclosure") &&   
								 (nod.attributes.type == "audio/mpeg" || nod.attributes.type == "video/x-flv"
								 || nod.attributes.type == "image/jpeg" || nod.attributes.type == "image/png"
								 || nod.attributes.type == "image/gif")) {
							obj["file"] = nod.attributes.href;
						} 
					}
					obj["author"] == undefined ? obj["author"] = ttl: null;
					parseArray.push(obj);
			} else if (tpl.nodeName == "title") { var ttl = tpl.firstChild.nodeValue; }
			tpl = tpl.nextSibling;
		}
	};


	/** Convert XSPF structure to array. **/
	private function parseXSPF():Void {
		var tpl = parseXML.firstChild.firstChild;
		while(tpl != null) { 
			if (tpl.nodeName == 'trackList') {
				for(var i=0; i<tpl.childNodes.length; i++) {
					var obj = new Object();
					for(var j=0; j<tpl.childNodes[i].childNodes.length; j++) {
						var nod:XMLNode = tpl.childNodes[i].childNodes[j];
						if(XSPF_TAGS[nod.nodeName.toLowerCase()] != undefined) {
							obj[XSPF_TAGS[nod.nodeName.toLowerCase()]] = nod.firstChild.nodeValue;
						} else if( nod.nodeName.toLowerCase() == "meta" && nod.attributes.rel == "http://www.jeroenwijering.com/start") {
							obj["start"] = nod.firstChild.nodeValue;
						} else if(nod.nodeName.toLowerCase() == "annotation") {
							obj["description"] = stripTagsBreaks(nod.firstChild.nodeValue);
						}
					}
					parseArray.push(obj);
				} 
			}
			tpl = tpl.nextSibling;
		}
	};


	/** Strip tags and breaks from a string **/
	private function stripTagsBreaks(str:String):String {
		var tmp:Array = str.split("\n");
		str = tmp.join("");
		var tmp:Array = str.split("\r");
		str = tmp.join("");
		var i:Number = str.indexOf("<");
		while(i != -1 && i != undefined) {
			var j = str.indexOf(">",i+1);
			j == -1 ? j = str.length-1: null;
			if(str.substr(i,3) == "<br" || str.substr(i,2) == "<p" || str.substr(i,3) == "</p") {
				str = str.substr(0,i)+str.substr(i,j-i+1)+str.substr(j+1,str.length);
			} else {
				str = str.substr(0,i) + str.substr(j+1,str.length);
			}
			i = str.indexOf("<",j);
		}
		return str;
	};


	/** Translate RFC2822 date strings (used in RSS) to timestamp. **/
	private function rfc2Date(dat):Number {
		if(isNaN(dat)) {
			var darr:Array = dat.split(' ');
			darr[1] == "" ? darr.splice(1,1) : null;
			var month:Number = MONTHS_TO_INTEGERS[darr[2]];
			var date:Number = darr[1].substring(0,2);
			var year:Number = darr[3];
			var zone = darr[5];
			var tarr:Array = darr[4].split(':');
			var myDate:Date = new Date(year,month,date,tarr[0],tarr[1],tarr[2]);
			var stamp = Math.round(myDate.valueOf()/1000) - myDate.getTimezoneOffset()*60;
			if(isNaN(zone)) { stamp -= 3600*TIMEZONE_OFFSETS[zone]; }
			else { stamp -= 3600*Number(zone.substring(1,3)); }
			var dat = new Date(stamp*1000);
			return stamp;
		} else {
			return dat;
		}
	};


	/** Translate ISO8601 date strings (used in ATOM) to timestamp. **/
	private function iso2Date(dat):Number {
		if(isNaN(dat)) {
			while(dat.indexOf(" ") > -1) {
				var idx = dat.indexOf(" ");
				dat = dat.substr(0,idx) + dat.substr(idx+1);
			}
			var myDate:Date = new Date(dat.substr(0,4),dat.substr(5,2)-1,dat.substr(8,2),dat.substr(11,2),dat.substr(14,2),dat.substr(17,2));
			var stamp = Math.round(myDate.valueOf()/1000) - myDate.getTimezoneOffset()*60;
			if(dat.length > 20) { 
				var hr:Number = Number(dat.substr(20,2));
				var mn:Number = Number(dat.substr(23,2));
				if(dat.charAt(19) == "-") {
					stamp = stamp - hr*3600 - mn*60;
				} else {
					stamp += hr*3600 + mn*60;
					trace(stamp);
				}
				var dat = new Date(stamp*1000);
			}
			return stamp;
		} else {
			return dat;
		}
	};


	/** Invoked when parsing is completed. **/
	public function onParseComplete() { };


}