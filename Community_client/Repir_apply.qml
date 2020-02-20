import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.12
import QtQuick.Controls.Styles 1.4

Window {
    id:repirapply;
    width: 500;
    height: 320;

    title: "报修申请";

    Image{
        id:background1;
        anchors.fill: parent;
        smooth: true;
        source: "image/image/repair_apply.jpg"
    }

    Text{
        id:text1;
        width: 120;
        text: "请选择报修种类"
        anchors.top: parent.top;
        anchors.topMargin: 15;
        anchors.left:parent.left;
        anchors.leftMargin: 15;
        font.bold: true;
        font.pointSize: 13;
    }

    ComboBox {
        id:cb;
        anchors.top: text1.bottom;
        anchors.topMargin: 10;
        anchors.left: text1.left;
        width: 140;
        //editable: true;
        model: ["水电类" , "木制类" , "油漆类","地板类","其他"];
        style: ComboBoxStyle {
            dropDownButtonWidth: 20;
            background: Rectangle {
                implicitHeight: 24;
                border.width: control.editable ? 0 : 1;
                border.color: (control.hovered || control.pressed)? "blue" : "gray";
                color: (control.hovered || control.pressed)? "#e0e0e0" : "#c0c0c0";
                Canvas {
                    width: 16;
                    height: 18;
                    anchors.right: parent.right;
                    anchors.rightMargin: 2;
                    anchors.top: parent.top;
                    anchors.topMargin: 1;
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.save();
                        ctx.strokeStyle = "black";
                        ctx.lineWidth = 2;
                        ctx.beginPath();
                        ctx.moveTo(1, 8);
                        ctx.lineTo(8, 16);
                        ctx.lineTo(15, 8);
                        ctx.stroke();
                        ctx.restore();
                    }
                }
            }
            label: Text {
                anchors.centerIn: parent;
                width: parent.width - 22;
                height: parent.height;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
                text: control.currentText;
                color: (control.hovered || control.pressed) ? "blue" : "black";
            }
        }
    }

    Text{
        id:text2;
        width: 120;
        text: "请输入问题描述"
        anchors.top: cb.bottom;
        anchors.topMargin: 15;
        anchors.left:cb.left;
        font.bold: true;
        font.pointSize: 13;
    }
    TextArea
    {
        id:txa;
        width: parent.width-20;
        height: parent.height/3;
        anchors.top: text2.bottom;
        anchors.left: parent.left;
        anchors.margins: 15;
        opacity: 0.6;
    }
    Button{
        id:btn1;
        height: 40;
        width: 100;
        anchors.top: txa.bottom;
        anchors.topMargin: 15;
        anchors.horizontalCenter: parent.horizontalCenter;
        text: "确认并发送请求";
        onClicked: {
            root.sever.sendUdpMsg("#RepirApply#"+cb.currentText+"#content#"+txa.text);
            rusult.visible=true;
        }
    }
    Text{
        id:rusult;
        visible: false;
        font.bold: true;
        font.pointSize: 12;
        anchors.top:btn1.bottom;
        anchors.topMargin: 5;
        anchors.horizontalCenter: btn1.horizontalCenter;
        color: "red";
        text: "已成功发送请求，请过一段时间在主界面的进度中确认";
    }

}
