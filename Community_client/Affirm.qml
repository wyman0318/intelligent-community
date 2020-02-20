import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.12
import QtQuick.Controls.Styles 1.4

Window {
    id:affirm_root;
    width: 600;
    height: 380;
    title: "确认进度";

    property var background: "#d7e3bc";
    property var alterBackground: "white";
    property var highlight: "#e4f7d6";
    property var headerBkgnd: "#F0F0F0";
    property var normalG: Gradient {
        GradientStop { position: 0.0; color: "#c7d3ac" }
        GradientStop { position: 1.0; color: "#F0F0F0" }
    }
    property var hoverG: Gradient {
        GradientStop { position: 0.0; color: "white"; }
        GradientStop { position: 1.0; color: "#d7e3bc"; }
    }
    property var pressG: Gradient {
        GradientStop { position: 0.0; color: "#d7e3bc"; }
        GradientStop { position: 1.0; color: "white"; }
    }

    TableView {
        id: phoneTable;
        anchors.fill: parent;
        TableViewColumn{ role: "classfy"  ; title: "分类" ; width: 120;}
        TableViewColumn{ role: "content" ; title: "内容" ; width: 200; }
        TableViewColumn{ role: "state" ; title: "状态" ; width: 100; }
        TableViewColumn{ role: "reply" ; title: "回复" ; width: 220; }

        itemDelegate: Text {
            text: styleData.value;
            font.pointSize: 13;
            color: styleData.selected ? "red" : styleData.textColor;
            elide: styleData.elideMode;
        }

        rowDelegate: Rectangle {
            color: styleData.selected ? affirm_root.highlight :
                                        (styleData.alternate ? affirm_root.alterBackground : affirm_root.background);
        }

        headerDelegate: Rectangle {
            implicitWidth: 10;
            implicitHeight: 24;
            gradient: styleData.pressed ? affirm_root.pressG : (styleData.containsMouse ? affirm_root.hoverG: affirm_root.normalG);
            border.width: 1;
            border.color: "gray";
            Text {
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: 4;
                anchors.right: parent.right;
                anchors.rightMargin: 4;
                text: styleData.value;
                font.pointSize: 13;
                color: styleData.pressed ? "red" : "blue";
                font.bold: true;
            }
        }

        model: ListModel {
            id:mymodel;
        }
    }

    Connections{
        target: root.sever;
        onAnswer:{
            phoneTable.model.append({"classfy":info[0],"state":info[1],
                                        "content":info[2],"reply":info[3]});
        }
        onAnswer_clear:{
            phoneTable.model.clear();
        }
    }
}
