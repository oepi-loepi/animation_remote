import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0


//		animationscreen.animationInterval = interval between new sprites to show
//		animationscreen.qmlAnimationURL = animationtype by url ( like >>>>    "qrc:/qb/components/Balloon.qml"    <<<<)
//		animationscreen.animationRunning =true or false to start and stop the animation (current animation will be finished
//		animationscreen.visibleindimstate =true or falsewill choose if the animation is visible in the dimstate
//		animationscreen.animationDuration = maximum time for the animation will last after the start command has finished and no stop command is given (in ms)


Tile {
	id: balloonTile
	property bool dimState: screenStateController.dimmedColors
	property string baseurl : "https://raw.githubusercontent.com/ToonSoftwareCollective/toonanimations/master/"
	property string triggerurl : "https://raw.githubusercontent.com/ToonSoftwareCollective/toonanimations/master/trigger/triggerfile"
	property int  numberofItems :0

	Timer {
		id: loadTimer
		running: true
		repeat: true
		triggeredOnStart: true
		interval: 86400000
		onTriggered: {
			getData()		
		}
	}

	Timer {
		id: animationcheckTimer
		running: true
		repeat: true
		triggeredOnStart: true
		interval: 300000
		onTriggered: {
			checkforAnimation();
		}
	}


	function checkforAnimation() {
		try {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.onreadystatechange=function() {
				if (xmlhttp.readyState == XMLHttpRequest.DONE) {
					if (xmlhttp.status == 200) {
							var JsonString = xmlhttp.responseText;
        						var JsonObject= JSON.parse(JsonString);

							var animationmode = JsonObject['animationmode'];
							var animationtype = JsonObject['animationtype'];
	
							if (animationmode  == 'Start') {
								animation(animationtype);							
							}
							if (animationmode  == 'Stop') {
								animationscreen.animationRunning= false;
								animationscreen.isVisibleinDimState= false;
							}
					}
				}
			}
			xmlhttp.open("GET", triggerurl);
			xmlhttp.send();
		} catch(e) {
		}
	}


        function getData() {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
                    var obj = JSON.parse(xmlhttp.responseText);
                    numberofItems =  obj.length
		    model.clear()
                    for (var i = 0; i < obj.length; i++){
                      listview1.model.append({name: obj[i].name})
                    }
                }
            }
            xmlhttp.open("GET", baseurl + "nameindex.json", true);
            xmlhttp.send();
        }



       function animation(animationName) {
           var xmlhttp = new XMLHttpRequest();
	   var url = baseurl +  animationName + ".json"
           xmlhttp.onreadystatechange=function() {
               if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
				   var obj = JSON.parse(xmlhttp.responseText);
				   animationscreen.animationRunning= true;
				   animationscreen.qmlAnimationURL= obj.component;
				   if (isNxt) {
						animationscreen.animationInterval= obj.Toon2time
					}
					else{
					animationscreen.animationInterval= obj.Toon1time
					}
				   if (obj.visibleindimstate==="yes"){animationscreen.isVisibleinDimState= true}
				   if (obj.visibleindimstate==="no"){animationscreen.isVisibleinDimState= false}
				}
           }
           xmlhttp.open("GET", url, true);
           xmlhttp.send();
       }

	NewTextLabel {
		id: startText
		width: isNxt ? 100 : 96;  
		height: isNxt ? 35 : 28
		buttonActiveColor: "lightgrey"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Start"
		anchors {
			top: parent.top
			topMargin: 1
			left: parent.left
			leftMargin:2
			}
		onClicked: {
			animation(model.get(listview1.currentIndex).name);
		}
		visible: !dimState
	}

	NewTextLabel {
		id: stopText
		width: isNxt ? 100 : 96;  
		height: isNxt ? 35 : 30
		buttonActiveColor: "lightgrey"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		textDisabledColor : "grey"
		buttonText:  "Stop!"
		anchors {
			top: startText.top
			topMargin: 1
			left: startText.right
			leftMargin:2

		}
		onClicked: {
			animationscreen.animationRunning= false;
			animationscreen.isVisibleinDimState= false;
		}
		visible: !dimState
	}

	NewTextLabel {
		id: configText
		width: isNxt ? 100 : 96;  
		height: isNxt ? 35 : 30
		buttonActiveColor: "lightgrey"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		textDisabledColor : "grey"
		buttonText:  "Setup"
		anchors {
			top: startText.top
			topMargin: 1
			left: stopText.right
			leftMargin:2

			}
		onClicked: {stage.openFullscreen(app.animationConfigScreenUrl)}		
		visible: !dimState
	}





/////////////////////////////////////////////////////////////////////////
	Rectangle{
		width: isNxt ? 240 : 188
		height: isNxt ? 145 : 116
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 5 : 4
		anchors {
			bottom: downButton.bottom
			left:   startText.left
		}

		Component {
			id: aniDelegate
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: 22
				Text {
					id: tst
					 text: name
				font.pixelSize: isNxt ? 22 : 17
				font.family: labelTitle.font.family
				}
			}
		}

		ListModel {
				id: model
		}


		ListView {
			id: listview1
			anchors {
				top: parent.top
				topMargin:isNxt ? 20 : 16
				leftMargin: isNxt ? 12 : 9
				left: parent.left
			}
			width: parent.width
			height: isNxt ? (parent.height-50) : (parent.height-40)
			model:model
			delegate: aniDelegate
			highlight: Rectangle { 
				color: "lightsteelblue"; 
				radius: isNxt ? 5 : 4
			}
			focus: true
			MouseArea {
				anchors.fill: parent
				onClicked: {
				animation(model.get(listview1.currentIndex).name);
				}
			}
		}
		visible: !dimState
	}

/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton
		anchors {
			bottom: refreshButton.top
			bottomMargin: isNxt ? 5 : 4
			right:  parent.right
			rightMargin : 3
		}

		iconSource: "qrc:/tsc/up.png"
		onClicked: {
		    if (listview1.currentIndex>0){
                        listview1.currentIndex  = listview1.currentIndex -1;
            }
		}	
		visible: !dimState
	}


	IconButton {
		id: refreshButton
		anchors {
			bottom: downButton.top
			bottomMargin: isNxt ? 5 : 4
			left:   upButton.left
			}

		iconSource: "qrc:/tsc/refresh.png"
		onClicked: {
			getData()
		}	
		visible: !dimState
	}


	IconButton {
		id: downButton
		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt ? 5 : 4
			left:   upButton.left
		}

		iconSource: "qrc:/tsc/down.png"
		onClicked: {
		    if (numberofItems>=listview1.currentIndex){
                        listview1.currentIndex  = listview1.currentIndex +1;
            }
		}	
		visible: !dimState
	}

}