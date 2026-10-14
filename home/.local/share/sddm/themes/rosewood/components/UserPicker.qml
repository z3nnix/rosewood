//
// [rosewood] components/UserPicker.qml
//
// Username selector bound to SDDM's userModel. Opens a menu *downward*
// (raised above later siblings via `z`) so the card column stays readable.
//

import QtQuick 2.0

FocusScope {
  id : root

  width  : 380
  height : 40

  property variant model
  property int     index : -1

  property font  font    : Qt.font({ pixelSize: 14 })
  property color color       : "#3A2E35"
  property color borderColor : "#5C4A52"
  property color focusColor  : "#C77D9A"
  property color hoverColor  : "#C77D9A"
  property color menuColor   : "#1A1418"
  property color textColor   : "#F2D5C4"
  property url   arrowIcon   : ""
  property int   rowHeight   : 36
  property int   maxMenuHeight : 260

  signal valueChanged(int id)

  property bool popupOpen : false

  property var    nameList  : ([])
  property string currentName : ""

  function refreshName() {
    currentName = (root.index >= 0 && root.index < nameList.length && nameList[root.index] !== undefined)
                    ? nameList[root.index] : ""
  }

  // Collect user login names (roles are exposed inside the delegate).
  Repeater {
    model : root.model
    Item {
      Component.onCompleted : {
        var a = root.nameList.slice()
        a[index] = name
        root.nameList = a
        root.refreshName()
      }
    }
  }

  onIndexChanged : refreshName()

  // --- Closed button ---
  Rectangle {
    id : main
    anchors.fill : parent

    color        : root.color
    border.width : 1
    border.color : (mouseArea.containsMouse || root.activeFocus)
                     ? root.focusColor : root.borderColor

    Behavior on border.color { ColorAnimation { duration: 120 } }

    Text {
      anchors.left           : parent.left
      anchors.right          : arrow.left
      anchors.verticalCenter : parent.verticalCenter
      anchors.leftMargin     : 12
      anchors.rightMargin    : 6

      text  : root.currentName
      color : root.textColor
      font  : root.font
      elide : Text.ElideRight
      verticalAlignment : Text.AlignVCenter
    }

    Rectangle {
      id : arrow
      anchors.right  : parent.right
      anchors.top    : parent.top
      anchors.bottom : parent.bottom
      width : 28
      color : "transparent"

      Image {
        anchors.centerIn : parent
        width  : 16
        height : 16
        source : root.arrowIcon
        sourceSize.width  : 16
        sourceSize.height : 16
        fillMode : Image.Pad
      }
    }

    MouseArea {
      id : mouseArea
      anchors.fill : parent
      hoverEnabled : true
      cursorShape  : Qt.PointingHandCursor
      onClicked    : root.popupOpen = !root.popupOpen
    }
  }

  // --- Menu, opens downward ---
  Rectangle {
    id : popup
    z : 10
    anchors.top : main.bottom
    width  : main.width
    height : root.popupOpen
               ? Math.min(root.nameList.length * root.rowHeight + 2, root.maxMenuHeight)
               : 0
    visible : height > 0

    color        : root.menuColor
    border.color : root.borderColor
    border.width : 1
    clip : true

    Behavior on height { NumberAnimation { duration: 100 } }

    ListView {
      id : listView
      anchors.fill     : parent
      anchors.margins  : 1
      model            : root.model
      currentIndex     : root.index
      boundsBehavior   : Flickable.StopAtBounds

      delegate : Rectangle {
        width  : listView.width
        height : root.rowHeight
        color  : (rowMouse.containsMouse || ListView.isCurrentItem)
                   ? root.hoverColor : "transparent"

        Text {
          anchors.fill        : parent
          anchors.leftMargin  : 12
          anchors.rightMargin : 12
          verticalAlignment   : Text.AlignVCenter
          elide : Text.ElideRight
          color : root.textColor
          font  : root.font
          text  : name
        }

        MouseArea {
          id : rowMouse
          anchors.fill : parent
          hoverEnabled : true
          cursorShape  : Qt.PointingHandCursor
          onClicked : {
            root.index = index
            root.popupOpen = false
            root.valueChanged(index)
          }
        }
      }
    }
  }

  onActiveFocusChanged : if (!activeFocus) popupOpen = false
  Keys.onEscapePressed  : popupOpen = false
}
