//
// [rosewood] Main.qml
//
// Warm plum / rose-gold SDDM greeter theme.
// Palette derived from sway/rofi/mako + foot configs.
//

import QtQuick 2.0
import SddmComponents 2.0

import "./components"

Rectangle {
  id : rosewood_root

  // --- Palette (overridable via theme.conf / theme.conf.user) ---
  property color bgTop   : config.bgTop      ? config.bgTop      : "#1A1418"
  property color bgBottom: config.bgBottom   ? config.bgBottom   : "#1F1122"

  property color cardBg  : config.cardBg     ? config.cardBg     : "#1A1418"
  property color surface : config.surface    ? config.surface    : "#3A2E35"
  property color muted   : config.muted      ? config.muted      : "#5C4A52"

  property color fgColor : config.text       ? config.text       : "#F2D5C4"
  property color mutedFg : config.mutedText  ? config.mutedText  : "#5C4A52"

  property color accent    : config.accent    ? config.accent    : "#C77D9A"
  property color accentAlt : config.accentAlt ? config.accentAlt : "#6A8A9A"
  property color gold      : config.gold      ? config.gold      : "#E8B87A"
  property color danger    : config.danger    ? config.danger    : "#D9534F"

  property color loginBg      : config.loginBg      ? config.loginBg      : "#C77D9A"
  property color loginBgHover : config.loginBgHover ? config.loginBgHover : "#F2D5C4"
  property color loginText    : config.loginText    ? config.loginText    : "#1A1418"

  property color rebootHover : config.rebootHover ? config.rebootHover : "#E8B87A"
  property color powerHover  : config.powerHover  ? config.powerHover  : "#D9534F"

  property string fontFamily : "Iosevka Term"

  readonly property int cardWidth  : 380
  readonly property int cardPad    : 28
  readonly property int fieldH     : 40
  readonly property int accentBar  : 3

  LayoutMirroring.enabled : Qt.locale().textDirection == Qt.RightToLeft
  LayoutMirroring.childrenInherit : true

  TextConstants { id: textConstants }

  // --- Background gradient, per screen ---
  Repeater {
    model : screenModel

    Rectangle {
      x      : geometry.x
      y      : geometry.y
      width  : geometry.width
      height : geometry.height
      gradient : Gradient {
        GradientStop { position: 0.0; color: rosewood_root.bgTop }
        GradientStop { position: 1.0; color: rosewood_root.bgBottom }
      }
    }
  }

  // --- Clock above the card ---
  SpClock {
    id : rosewood_clock

    anchors.horizontalCenter : parent.horizontalCenter
    y : (parent.height - card.height) / 2 - 64

    tColor : rosewood_root.fgColor
    tFont.family    : rosewood_root.fontFamily
    tFont.pixelSize : 18
  }

  // --- Login card ---
  Rectangle {
    id : card

    anchors.centerIn : parent
    width  : cardWidth
    height : card_column.implicitHeight + (cardPad * 2) + accentBar

    color        : rosewood_root.cardBg
    border.color : rosewood_root.muted
    border.width : 1
    radius       : 0

    // top accent bar
    Rectangle {
      anchors.top   : parent.top
      anchors.left  : parent.left
      width         : parent.width
      height        : accentBar
      color         : rosewood_root.accent
    }

    Column {
      id : card_column

      anchors.top    : parent.top
      anchors.left   : parent.left
      anchors.right  : parent.right
      anchors.margins : rosewood_root.cardPad
      anchors.topMargin : rosewood_root.cardPad + accentBar
      spacing : 14

      // Hostname / welcome
      Text {
        width : parent.width
        text  : textConstants.welcomeText.arg("the Rosè Wood")
        color : rosewood_root.fgColor
        font.family    : rosewood_root.fontFamily
        font.pixelSize : 16
        elide : Text.ElideRight
      }

      // Username label
      Text {
        text  : textConstants.userName
        color : rosewood_root.accent
        font.family    : rosewood_root.fontFamily
        font.pixelSize : 12
      }

      UserPicker {
        id     : rosewood_username
        width  : parent.width
        height : fieldH

        model : userModel
        index : userModel.lastIndex

        color       : rosewood_root.surface
        borderColor : rosewood_root.muted
        focusColor  : rosewood_root.accent
        hoverColor  : rosewood_root.accent
        menuColor   : rosewood_root.cardBg
        textColor   : rosewood_root.fgColor
        font.family    : rosewood_root.fontFamily
        font.pixelSize : 14

        arrowIcon : "images/arrow.svg"
      }

      // Password label
      Text {
        text  : textConstants.password
        color : rosewood_root.accent
        font.family    : rosewood_root.fontFamily
        font.pixelSize : 12
      }

      PasswordBox {
        id    : rosewood_password
        width : parent.width
        height : fieldH

        color       : rosewood_root.surface
        borderColor : rosewood_root.muted
        focusColor  : rosewood_root.accent
        hoverColor  : rosewood_root.accent
        textColor   : rosewood_root.fgColor
        font.family    : rosewood_root.fontFamily
        font.pixelSize : 14

        image : "images/warning.svg"

        tooltipEnabled : true
        tooltipText    : textConstants.capslockWarning
        tooltipFG      : rosewood_root.loginText
        tooltipBG      : rosewood_root.danger

        KeyNavigation.tab     : rosewood_login
        KeyNavigation.backtab : rosewood_session

        Keys.onPressed : {
          if ((event.key === Qt.Key_Return) || (event.key === Qt.Key_Enter)) {
            rosewood_root.tryLogin()
            event.accepted = true
          }
        }
      }

      // Login button
      Button {
        id    : rosewood_login
        width : parent.width
        height : fieldH

        text : textConstants.login

        color        : rosewood_root.loginBg
        textColor    : rosewood_root.loginText
        borderColor  : rosewood_root.loginBg
        pressedColor : rosewood_root.loginBgHover
        activeColor  : rosewood_root.loginBgHover

        font.family    : rosewood_root.fontFamily
        font.pixelSize : 15
        font.weight    : Font.DemiBold

        KeyNavigation.tab     : rosewood_reboot
        KeyNavigation.backtab : rosewood_password

        onClicked : rosewood_root.tryLogin()
      }

      // Power / reboot row
      Row {
        width : parent.width
        spacing : 10

        SpButton {
          id    : rosewood_reboot
          width : (parent.width - 10) / 2

          label   : textConstants.reboot
          font.family    : rosewood_root.fontFamily
          font.pixelSize : 13

          iconDefault : "images/refresh.svg"
          iconHover   : "images/refresh_hover.svg"

          labelColor      : rosewood_root.fgColor
          hoverLabelColor : rosewood_root.fgColor
          borderColor     : rosewood_root.muted
          hoverBorderColor: rosewood_root.gold
          hoverBgColor    : rosewood_root.surface

          KeyNavigation.tab     : rosewood_power
          KeyNavigation.backtab : rosewood_login

          onClicked : sddm.reboot()
        }

        SpButton {
          id    : rosewood_power
          width : (parent.width - 10) / 2

          label   : textConstants.shutdown
          font.family    : rosewood_root.fontFamily
          font.pixelSize : 13

          iconDefault : "images/power.svg"
          iconHover   : "images/power_hover.svg"

          labelColor      : rosewood_root.fgColor
          hoverLabelColor : rosewood_root.fgColor
          borderColor     : rosewood_root.muted
          hoverBorderColor: rosewood_root.danger
          hoverBgColor    : rosewood_root.surface

          KeyNavigation.tab     : rosewood_session
          KeyNavigation.backtab : rosewood_reboot

          onClicked : sddm.powerOff()
        }
      }
    }
  }

  // --- Status prompt (login failed / succeed / info) ---
  Rectangle {
    id : rosewood_prompt

    anchors.horizontalCenter : parent.horizontalCenter
    anchors.top : card.bottom
    anchors.topMargin : 16
    width : card.width
    height : 40

    color : "transparent"

    Text {
      id : rosewood_prompt_text
      anchors.fill : parent
      color : rosewood_root.fgColor
      text  : textConstants.prompt
      font.family    : rosewood_root.fontFamily
      font.pixelSize : 14
      horizontalAlignment : Text.AlignHCenter
      verticalAlignment   : Text.AlignVCenter
    }

    SequentialAnimation on color {
      id : anim_success
      running : false
      ColorAnimation { from: "transparent"; to: rosewood_root.accentAlt; duration: 200 }
    }

    SequentialAnimation on color {
      id : anim_failure
      running : false
      ColorAnimation { from: "transparent"; to: rosewood_root.danger; duration: 200 }
      PauseAnimation { duration: 1200 }
      ColorAnimation { from: rosewood_root.danger; to: "transparent"; duration: 500 }
      onStopped : {
        rosewood_prompt_text.color = rosewood_root.fgColor
        rosewood_prompt_text.text  = textConstants.prompt
      }
    }
  }

  // --- Session selector, bottom-left corner ---
  Column {
    id : rosewood_session_box

    anchors.left   : parent.left
    anchors.bottom : parent.bottom
    anchors.leftMargin   : 20
    anchors.bottomMargin : 20
    spacing : 4

    Text {
      text  : textConstants.session
      color : rosewood_root.accent
      font.family    : rosewood_root.fontFamily
      font.pixelSize : 12
    }

    SessionPicker {
      id    : rosewood_session
      width : 220
      height : fieldH

      model : sessionModel
      index : sessionModel.lastIndex

      color       : rosewood_root.surface
      borderColor : rosewood_root.muted
      focusColor  : rosewood_root.accent
      hoverColor  : rosewood_root.accent
      textColor   : rosewood_root.fgColor
      menuColor   : rosewood_root.cardBg
      font.family    : rosewood_root.fontFamily
      font.pixelSize : 14

      arrowIcon  : "images/arrow.svg"

      KeyNavigation.tab     : rosewood_password
      KeyNavigation.backtab : rosewood_power
    }
  }

  // --- Signals / wiring ---
  signal tryLogin()

  onTryLogin : {
    sddm.login(rosewood_username.currentName, rosewood_password.text, rosewood_session.index)
  }

  Connections {
    target : sddm

    onLoginSucceeded : {
      rosewood_prompt_text.color = rosewood_root.loginText
      rosewood_prompt_text.text  = textConstants.loginSucceeded
      anim_success.start()
    }
    onLoginFailed : {
      rosewood_prompt_text.color = rosewood_root.loginText
      rosewood_prompt_text.text  = textConstants.loginFailed
      anim_failure.start()
    }
    onInformationMessage : {
      rosewood_prompt_text.color = rosewood_root.loginText
      rosewood_prompt_text.text  = message
      anim_failure.start()
    }
  }

  Component.onCompleted : {
    rosewood_password.focus = true
  }
}
