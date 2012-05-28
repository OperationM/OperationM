//	HYPE.documents["moogle_welcome"]

(function HYPE_DocumentLoader() {
	var resourcesFolderName = "moogle_welcome_Resources";
	var documentName = "moogle_welcome";
	var documentLoaderFilename = "mooglewelcome_hype_generated_script.js";

	// find the URL for this script's absolute path and set as the resourceFolderName
	try {
		var scripts = document.getElementsByTagName('script');
		for(var i = 0; i < scripts.length; i++) {
			var scriptSrc = scripts[i].src;
			if(scriptSrc != null && scriptSrc.indexOf(documentLoaderFilename) != -1) {
				resourcesFolderName = scriptSrc.substr(0, scriptSrc.lastIndexOf("/"));
				break;
			}
		}
	} catch(err) {	}

	// Legacy support
	if (typeof window.HYPE_DocumentsToLoad == "undefined") {
		window.HYPE_DocumentsToLoad = new Array();
	}
 
	// load HYPE.js if it hasn't been loaded yet
	if(typeof HYPE_108 == "undefined") {
		if(typeof window.HYPE_108_DocumentsToLoad == "undefined") {
			window.HYPE_108_DocumentsToLoad = new Array();
			window.HYPE_108_DocumentsToLoad.push(HYPE_DocumentLoader);

			var headElement = document.getElementsByTagName('head')[0];
			var scriptElement = document.createElement('script');
			scriptElement.type= 'text/javascript';
			scriptElement.src = resourcesFolderName + '/' + 'HYPE.js?hype_version=108';
			headElement.appendChild(scriptElement);
		} else {
			window.HYPE_108_DocumentsToLoad.push(HYPE_DocumentLoader);
		}
		return;
	}
	
	// guard against loading multiple times
	if(HYPE.documents[documentName] != null) {
		return;
	}
	
	var hypeDoc = new HYPE_108();
	
	var attributeTransformerMapping = {b:"i",c:"i",bC:"i",d:"i",aS:"i",M:"i",e:"f",N:"i",f:"d",aT:"i",O:"i",g:"c",aU:"i",P:"i",Q:"i",aV:"i",R:"c",aW:"f",aI:"i",S:"i",T:"i",l:"d",aX:"i",aJ:"i",m:"c",n:"c",aK:"i",X:"i",aL:"i",A:"c",aZ:"i",Y:"i",B:"c",C:"c",D:"c",t:"i",E:"i",G:"c",bA:"c",a:"i",bB:"i"};

var scenes = [{initialValues:{"10":{b:133,z:"5",K:"None",c:229,L:"None",d:147,aS:6,M:0,e:"1.000000",bD:"none",aT:6,N:0,O:0,aU:6,P:0,Q:0,aV:6,R:"#808080",j:"absolute",S:0,aI:6,k:"div",T:0,aJ:6,aK:6,X:4,aL:6,A:"#A0A0A0",Y:49,B:"#A0A0A0",aM:"10_hover",r:"inline",Z:"break-word",C:"#A0A0A0",s:"'Arial Black',Gadget,Sans-Serif",D:"#A0A0A0",t:36,aA:{type:5,goToURL:"/auth/facebook",openInNewWindow:false},F:"center",v:"bold",G:"#FF0081",aP:"pointer",w:"Log in&nbsp;<div>with</div><div>Facebook</div>",x:"visible",I:"None",a:540,y:"preserve",J:"None"},"13":{o:"content-box",h:"arrow.png",x:"visible",a:354,q:"100% 100%",b:136,j:"absolute",r:"inline",c:122,z:"6",k:"div",d:177,e:"0.000000"},"6":{o:"content-box",h:"logintv.png",x:"visible",a:492,q:"100% 100%",b:18,j:"absolute",r:"inline",c:372,z:"1",k:"div",d:366},"15":{G:"#FF8779",aU:8,c:425,bB:4,aV:8,r:"inline",d:284,e:"0.000000",s:"'Arial Black',Gadget,Sans-Serif",bC:0,t:82,Y:0,Z:"break-word",w:"Welcome to<div>Moogle</div>",j:"absolute",x:"visible",aZ:0,k:"div",y:"preserve",z:"7",aS:8,aT:8,a:35,F:"center",bA:"#000000",b:63},"14":{aV:8,w:"If you are a member&nbsp;of Music Society Group&nbsp;<div>at Facebook,<div><div>you can find and watch&nbsp;</div><div>your video, friend's video,&nbsp;</div><div>and some memories.</div><div>Let's enjoy!!&nbsp;</div></div></div>",x:"visible",a:61,Z:"break-word",y:"preserve",aS:8,r:"inline",z:"8",j:"absolute",c:298,aT:8,d:223,t:24,b:105,e:"0.000000",G:"#FF8779",aU:8,k:"div"}},timelines:{"10_hover":{framesPerSecond:30,animations:[{f:"2",t:0,d:1,i:"e",e:"1.000000",r:1,s:"1.000000",o:"10"},{f:"2",t:0,d:1,i:"B",e:"#A0A0A0",r:1,s:"#A0A0A0",o:"10"},{f:"2",t:0,d:1,i:"C",e:"#A0A0A0",r:1,s:"#A0A0A0",o:"10"},{f:"2",t:0,d:1,i:"D",e:"#A0A0A0",r:1,s:"#A0A0A0",o:"10"},{f:"2",t:0,d:1,i:"A",e:"#A0A0A0",r:1,s:"#A0A0A0",o:"10"},{f:"2",t:0,d:1,i:"G",e:"#4B6EFF",r:1,s:"#FF0081",o:"10"}],identifier:"10_hover",name:"10_hover",duration:1},kTimelineDefaultIdentifier:{framesPerSecond:30,animations:[{f:"2",t:0,d:1,i:"e",e:"1.000000",r:1,s:"0.000000",o:"15"},{f:"2",t:0,d:1,i:"Y",e:88,r:1,s:0,o:"15"},{f:"2",t:1,d:1,i:"e",e:"1.000000",s:"1.000000",o:"15"},{f:"2",t:2,d:1,i:"e",e:"0.000000",s:"1.000000",o:"15"},{f:"2",t:3,d:1.5,i:"e",e:"1.000000",r:1,s:"0.000000",o:"13"},{f:"2",t:3,d:1.5,i:"e",e:"1.000000",r:1,s:"0.000000",o:"14"}],identifier:"kTimelineDefaultIdentifier",name:"Main Timeline",duration:4.5}},sceneIndex:0,perspective:"600px",oid:"1",onSceneAnimationCompleteAction:{type:0},backgroundColor:"#000000",name:"Untitled Scene"}];


	
	var javascripts = [];


	
	var Custom = {};
	var javascriptMapping = {};
	for(var i = 0; i < javascripts.length; i++) {
		try {
			javascriptMapping[javascripts[i].identifier] = javascripts[i].name;
			eval("Custom." + javascripts[i].name + " = " + javascripts[i].source);
		} catch (e) {
			hypeDoc.log(e);
			Custom[javascripts[i].name] = (function () {});
		}
	}
	
	hypeDoc.setAttributeTransformerMapping(attributeTransformerMapping);
	hypeDoc.setScenes(scenes);
	hypeDoc.setJavascriptMapping(javascriptMapping);
	hypeDoc.Custom = Custom;
	hypeDoc.setCurrentSceneIndex(0);
	hypeDoc.setMainContentContainerID("mooglewelcome_hype_container");
	hypeDoc.setResourcesFolderName(resourcesFolderName);
	hypeDoc.setShowHypeBuiltWatermark(0);
	hypeDoc.setShowLoadingPage(true);
	hypeDoc.setDrawSceneBackgrounds(true);
	hypeDoc.setDocumentName(documentName);

	HYPE.documents[documentName] = hypeDoc.API;

	hypeDoc.documentLoad(this.body);
}());

