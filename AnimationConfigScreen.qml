import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0;

Screen {
	id: animationConfigScreen
	screenTitle: "Animation app Setup"


	onShown: {

		enableOPTINToggle.isSwitchedOn = app.optIN;
		addCustomTopRightButton("Save");
	}

	onCustomButtonClicked: {
		app.saveSettings();
		hide();
	}

	Text {
		id: myLabel
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name
		text: "Opt-In to have TSC team trigger animations on special events."
		anchors {
			left: parent.left
			top: parent.top			
			leftMargin: 20
			topMargin: 10
		}
	}

	Text {
		id: myLabel2
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name
		text: "For this a website will be polled each 5 minutes to check special anaimation events."
		anchors {
			left: parent.left
			top: myLabel.bottom			
			leftMargin: 20
			topMargin: 10
		}
	}

	Text {
		id: optINText
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name
		width:  160
		text: "Opt in"
		anchors {
			left: parent.left
			top: myLabel2.bottom
			leftMargin: 20
			topMargin: 30
		}
	}

	OnOffToggle {
		id: enableOPTINToggle
		height:  30
		anchors.left: optINText.right
		anchors.leftMargin: 10
		anchors.top: optINText.top
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				app.optIN = true;
			} else {
				app.optIN = false;
			}
		}
	}


}

