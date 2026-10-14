//
// [rosewood] components/SpClock.qml
//
// Date + time display.
//

import QtQuick 2.0

Item {
  id : sp_clock

  property date  value  : new Date()
  property color tColor : "#F2D5C4"
  property alias tFont  : sp_clock_text.font

  implicitWidth  : sp_clock_text.implicitWidth
  implicitHeight : sp_clock_text.implicitHeight

  Timer {
    interval    : 1000
    running     : true
    repeat      : true
    onTriggered : sp_clock.value = new Date()
  }

  Text {
    id  : sp_clock_text

    text  : Qt.formatDateTime(sp_clock.value, "dddd, dd MMMM yyyy  -  HH:mm")
    color : sp_clock.tColor

    font.pixelSize : 18

    horizontalAlignment : Text.AlignHCenter
    verticalAlignment   : Text.AlignVCenter
  }
}
