# iAdAttributes

Attribution API is called as per following documentation.

https://searchads.apple.com/help/pdf/attribution-api.pdf

Javascript api exposed through getAttribution and returning JSON object to event handeler "analyticsInfo".

Sample API output:

```
{
	“message” : {
	“iad-attribution” = true;
	“iad-org-name” = “Light Right”;
	“iad-campaign-id” = 15292426;
	“iad-campaign-name” = “Light Bright Launch”;
	“iad-conversion-date” = “2016-06-14T17:18:07Z”;
	“iad-click-date” = “2016-06-14T17:17:00Z”;
	“iad-adgroup-id” = 15307675;
	“iad-adgroup-name” = “LightRight Launch Group”;
	“iad-keyword” = “light right”;
	},
	...
}
```

# CommonJS Usage

```
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

win.open();

var label = Ti.UI.createLabel();
win.add(label);

var iadattributes = require('com.gaurang.iadattributes');
Ti.API.info("module is => " + iadattributes);

iadattributes.addEventListener("analyticsInfo", function(e){
  if(e.error != null){
    Ti.API.warn("iAds error: " + e.error);
  } else if(e.message != null){
    var response = JSON.stringify(e.message);
    console.log("iAds ADC attribution: " + response);
    label.text = response;
  }
});
iadattributes.getAttribution();

var removeListener = function(e){
	iadattributes.removeEventListener("analyticsInfo", eventListenerAtt);
};
win.addEventListener('close', removeListener);
```

# Alloy Usage

### index.xml

```
<Alloy>
	<Window id="win" class="container" onClose="removeListener">
		<Label id="lblText" height="Titanium.UI.SIZE" width="Titanium.UI.SIZE"></Label>
	</Window>
</Alloy>
```
### index.js

```
var iadattributes = require('com.gaurang.iadattributes');
Ti.API.info("module is => " + iadattributes);

iadattributes.addEventListener("analyticsInfo", function(e){
  if(e.error != null){
    Ti.API.warn("iAds error: " + e.error);
  } else if(e.message != null){
    var response = JSON.stringify(e.message);
    Ti.API.info("iAds ADC attribution: " + response);
    $.lblText.text = response;
  }
});
$.lblText.text = iadattributes.getAttribution();

var removeListener = function(e){
	iadattributes.removeEventListener("analyticsInfo", eventListenerAtt);
};

$.win.open();
```