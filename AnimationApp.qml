//
// Animation! v1.2.2 by Oepi-Loepi
//

import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0
import FileIO 1.0

App {
	id: animationApp

	property url tileUrl : "AnimationTile.qml"
	property url thumbnailIcon: "qrc:/tsc/BalloonIcon.png"
	property AnimationConfigScreen animationConfigScreen
	property url animationConfigScreenUrl : "AnimationConfigScreen.qml"
	property bool optIN : false
	property string tmpOPTIN : "No"

	property variant onkyocontrollerSettingsJson : {
		'tmpOPTIN': ""
	}


	FileIO {
		id: animationSettingsFile
		source: "file:///mnt/data/tsc/animation_userSettings.json"
 	}


	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: qsTr("Animation!"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", animationConfigScreenUrl, this, "animationConfigScreen");
	}

	Component.onCompleted: {
		try {
			animationSettingsJson = JSON.parse(animationSettingsFile.read());
			
			if (animationSettingsJson['tmpOPTIN'] == "Yes") {
				optIN= true
			} else {
				optIN = false
			}

		} catch(e) {
		}
	}

	function saveSettings() {
		if (optIN == true) {
			tmpOPTIN = "Yes";
		} else {
			tmpOPTIN = "No";
		}

 		var setJson = {
			"tmpOPTIN" : tmpOPTIN
		}
  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/animation_userSettings.json");
   		doc3.send(JSON.stringify(setJson));
	}





}
