//
// [rosewood] components/SpButton.qml
//
// Flat action button: tinted icon + label, no rounded corners.
//

import QtQuick 2.0

Item {
  id  : sp_button

  property bool enabled : true

  property alias label : sp_button_label.text
  property alias font  : sp_button_label.font

  property url   iconDefault : ""
  property url   iconHover   : ""

  property color labelColor      : "#F2D5C4"
  property color hoverLabelColor : "#F2D5C4"

  property color bgColor         : "transparent"
  property color hoverBgColor    : "#3A2E35"

  property color borderColor      : "#5C4A52"
  property color hoverBorderColor : "#C77D9A"

  property int iconSize : 20

  signal clicked()

  implicitWidth  : sp_row.implicitWidth + 20
  implicitHeight : iconSize + 16

  Rectangle {
    id    : sp_button_bg
    anchors.fill : parent

    color        : sp_button.enabled ? sp_button.bgColor : "transparent"
    border.color : sp_button.enabled ? sp_button.borderColor : "#5C4A52"
    border.width : 1
    radius       : 0
  }

  Row {
    id : sp_row
    anchors.centerIn : parent
    spacing : 8

    Image {
      id  : sp_button_icon
      width  : sp_button.iconSize
      height : sp_button.iconSize
      source : sp_button.iconDefault
      sourceSize.width  : sp_button.iconSize
      sourceSize.height : sp_button.iconSize
      fillMode : Image.Pad
      anchors.verticalCenter : parent.verticalCenter
      opacity : sp_button.enabled ? 1.0 : 0.4
    }

    Text {
      id  : sp_button_label
      color : sp_button.enabled ? sp_button.labelColor : "#5C4A52"
      font.pixelSize : 14
      verticalAlignment : Text.AlignVCenter
      anchors.verticalCenter : parent.verticalCenter
    }
  }

  MouseArea {
    anchors.fill    : parent
    hoverEnabled    : true
    cursorShape     : Qt.PointingHandCursor
    acceptedButtons : Qt.LeftButton
    enabled         : sp_button.enabled
    onClicked       : sp_button.clicked()

    onEntered : {
      sp_button_bg.color        = sp_button.hoverBgColor
      sp_button_bg.border.color = sp_button.hoverBorderColor
      sp_button_label.color     = sp_button.hoverLabelColor
      sp_button_icon.source     = sp_button.iconHover
    }

    onExited : {
      sp_button_bg.color        = sp_button.bgColor
      sp_button_bg.border.color = sp_button.borderColor
      sp_button_label.color     = sp_button.labelColor
      sp_button_icon.source     = sp_button.iconDefault
    }
  }
}
