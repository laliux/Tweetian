/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import "." 1.1

Item {
    id: root

    default property alias content: menu.content
    property Item visualParent: null
    property alias status: popup.status
    property bool platformInverted: false

    function open() {
        popup.open()
    }

    function close() {
        popup.close()
    }

    visible: false

    Popup {
        id: popup
        objectName: "OptionsMenu"

        y: ((root.height ? root.height : screen.height) - popup.height ) / 2

        animationDuration: 100
        state: "Hidden"
        visible: status != DialogStatus.Closed
        enabled: status == DialogStatus.Open
        width: root.width ? root.width : screen.width
        height: menuContainer.height
        clip: false
        platformInverted: root.platformInverted

        onFaderClicked: {
            privateStyle.play(Symbian.PopUp)
            close()
        }

        Rectangle {
            id: menuContainer

            property int borderSize: Math.round(platformStyle.borderSizeMedium * 1.5)

            color: "#111111"
            //source: privateStyle.imagePath("qtg_fr_popup_options", root.platformInverted)
            //border { left: borderSize; top: borderSize; right: borderSize; bottom: borderSize }

            anchors.right: parent.right
            width: parent.width * 0.75
            height: menu.height + 2 * platformStyle.paddingLarge

            MenuContent {
                id: menu
                containingPopup: popup
                anchors { top: parent.top; left: parent.left; right: parent.right
                          topMargin: platformStyle.paddingLarge
                          leftMargin: root.platformInverted?0:platformStyle.paddingLarge
                          rightMargin: root.platformInverted?0:platformStyle.paddingLarge}
                platformInverted: root.platformInverted
                onItemClicked: popup.close()

                // Use root size as menu size as screen size if explicitly set.
                // This is a workaround for situations when application locks screen
                // and handles rotations itself, which may lead to invalid screen sizes.
                screenWidth: root.width ? root.width : screen.width
                screenHeight: root.height ? root.height : screen.height
            }
        }


        states: [
            State {
                name: "Hidden"
                when: status == DialogStatus.Closing || status == DialogStatus.Closed

            },
            State {
                name: "Visible"
                when: status == DialogStatus.Opening || status == DialogStatus.Open

            }
        ]


        transitions: [
            Transition {
                from: "Visible"; to: "Hidden"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: menuContainer
                            property: "x"
                            duration: popup.animationDuration
                            easing.type: Easing.Linear
                        }
                    }
                    PropertyAction { target: popup; property: "status"; value: DialogStatus.Closed }
                }
            },
            Transition {
                from: "Hidden"; to: "Visible"
                SequentialAnimation {
                    //ParallelAnimation {
                        NumberAnimation {
                            target: menuContainer
                            property: "x"
                            duration: popup.animationDuration
                            easing.type: Easing.Linear
                        }
                    PropertyAction { target: popup; property: "status"; value: DialogStatus.Open }
                }
            }
        ]
    }
}
