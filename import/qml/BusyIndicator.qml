/*
 * Copyright 2021 by Aditya Mehra <aix.m@outlook.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls

Controls.BusyIndicator {
    id: control
    width: 200
    height: 200
    padding: 0

    //Allow animations to be run at a slower speed if required
    property real speed: 1

    onRunningChanged: {
        if(!running) {
            changeStage()
        }
    }

    function changeStage() {
        canvas.startDeg = 0
        canvas.endDeg = 2
    }

    contentItem: Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        visible: control.visible

        renderTarget: Canvas.FramebufferObject
        property int startDeg: 0
        property int endDeg: 2
        property color primaryColor: '#22A7F0'

        Behavior on primaryColor {
            ColorAnimation { duration: 200 }
        }

        onStartDegChanged: requestPaint()
        onEndDegChanged: requestPaint()
        onPrimaryColorChanged: requestPaint()

        onPaint: {
            function deg2Rad(deg) {
                return (deg / 180) * Math.PI;
            }

            var ctx = canvas.getContext('2d');
            ctx.strokeStyle = primaryColor;
            ctx.lineWidth = 20;
            ctx.lineCap="round";
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.beginPath();
            ctx.arc(canvas.width / 2, canvas.height / 2, (canvas.height > canvas.width ? canvas.width : canvas.height) / 2 - 20, deg2Rad(startDeg - 90), deg2Rad(endDeg - 90), false);
            ctx.stroke();
        }
    }

    SequentialAnimation {
        id: seqAnimator
        running: control.running
        loops: Animation.Infinite

        ParallelAnimation {

            NumberAnimation {
                target: canvas
                property: "endDeg"
                to: 360
                duration: 600 * control.speed
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: canvas
                property: "startDeg"
                to: 360
                duration: 900 * control.speed
                easing.type: Easing.InOutQuad
            }
        }

        ScriptAction {
            script: changeStage()
        }

        ParallelAnimation {

            NumberAnimation {
                target: canvas
                property: "endDeg"
                to: 360
                duration: 900 * control.speed
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                loops: 1
                target: canvas
                property: "rotation"
                duration: 1200 * control.speed
                from: 0
                to: 720
            }

            NumberAnimation {
                target: canvas
                property: "startDeg"
                to: 360
                duration: 1200 * control.speed
                easing.type: Easing.InOutQuad
            }
        }

        ScriptAction {
            script: changeStage()
        }
    }
}
