import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: rectangle
    width: 640
    height: 480
    color: "#1e1e1e"

    property string display: "0"
    property real currentValue: 0
    property string pendingOperator: ""
    property bool startNewNumber: true

    function inputDigit(digit) {
        if (startNewNumber) {
            display = digit
            startNewNumber = false
        } else {
            display = display === "0" ? digit : display + digit
        }
    }

    function inputDecimal() {
        if (startNewNumber) {
            display = "0."
            startNewNumber = false
        } else if (display.indexOf(".") === -1) {
            display = display + "."
        }
    }

    function setOperator(op) {
        if (pendingOperator !== "" && !startNewNumber) {
            calculate()
        }
        currentValue = parseFloat(display)
        pendingOperator = op
        startNewNumber = true
    }

    function calculate() {
        var second = parseFloat(display)
        var result = currentValue
        switch (pendingOperator) {
            case "+": result = currentValue + second; break
            case "-": result = currentValue - second; break
            case "*": result = currentValue * second; break
            case "/":
                if (second === 0) {
                    display = "Error"
                    startNewNumber = true
                    pendingOperator = ""
                    return
                }
                result = currentValue / second
                break
            default: result = second
        }
        display = String(result)
        currentValue = result
        pendingOperator = ""
        startNewNumber = true
    }

    function clearAll() {
        display = "0"
        currentValue = 0
        pendingOperator = ""
        startNewNumber = true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // Дисплей
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "#2d2d2d"
            radius: 8

            Text {
                anchors.fill: parent
                anchors.margins: 10
                text: display
                color: "white"
                font.pixelSize: 32
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Кнопки
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 4
            rowSpacing: 8
            columnSpacing: 8

            Repeater {
                model: [
                    "C", "±", "%", "/",
                    "7", "8", "9", "*",
                    "4", "5", "6", "-",
                    "1", "2", "3", "+",
                    "0", ".", "="
                ]

                Button {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: modelData === "0" ? 2 : 1
                    text: modelData
                    font.pixelSize: 20

                    background: Rectangle {
                        color: {
                            if (["/", "*", "-", "+", "="].includes(modelData))
                                return "#ff9500"
                            if (["C", "±", "%"].includes(modelData))
                                return "#a5a5a5"
                            return "#333333"
                        }
                        radius: 8
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        if (modelData >= "0" && modelData <= "9") {
                            inputDigit(modelData)
                        } else if (modelData === ".") {
                            inputDecimal()
                        } else if (modelData === "C") {
                            clearAll()
                        } else if (modelData === "=") {
                            calculate()
                        } else if (modelData === "±") {
                            display = String(parseFloat(display) * -1)
                        } else if (modelData === "%") {
                            display = String(parseFloat(display) / 100)
                        } else {
                            setOperator(modelData)
                        }
                    }
                }
            }
        }
    }
}
