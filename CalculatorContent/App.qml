import QtQuick
import Calculator

Window {
    width: mainScreen.width
    height: mainScreen.height

    visible: true
    title: "Calculator"

    Calculator {
        id: mainScreen

        anchors.centerIn: parent
    }

}

