import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.12
import QtQuick.Controls.Styles 1.4

Window {
    id:chatroom;
    title: "社区聊天"
    width: 700;
    height: 520;

    color: "skyblue";


    Rectangle{
        width: parent.width-15;
        height: parent.height-inputfield.height-20;
        anchors.top: parent.top;
        anchors.topMargin: 10;
        anchors.horizontalCenter: parent.horizontalCenter;
        color: "lightskyblue";
        opacity: 0.5;
        TextArea{
            id:chatrec;
            anchors.fill: parent;
            font.bold: true;
            font.pointSize: 15;
            wrapMode: TextEdit.WrapAnywhere;
            readOnly: true;

        }
    }

    TextField{
        id:inputfield;
        width: parent.width/1.2-10;
        height: parent.height/10;
        font.bold: true;
        font.pointSize: 15;
        opacity: 0.5;
        anchors.left: parent.left;
        anchors.leftMargin: 6;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin:  5;

        Keys.enabled: true;
        Keys.onReturnPressed: {
            root.sever.chatmsg(root.username+inputfield.text+"\n\n");
            inputfield.text="";
        }
    }

    Button{
        id:send_btn;
        anchors.verticalCenter: inputfield.verticalCenter;
        anchors.left: inputfield.right;
        anchors.leftMargin: 5;

        onClicked: {
            root.sever.chatmsg(root.username+inputfield.text+"\n\n");
            inputfield.text="";
        }
        style: ButtonStyle{
            background: Item{
                implicitWidth:  chatroom.width-inputfield.width-20;
                implicitHeight: inputfield.height;
                Rectangle{
                    anchors.fill:parent;
                    border.width: 3;
                    border.color: "cyan";
                    color: control.pressed?"blue":"deepskyblue";
                    opacity: 0.7;
                }
                Text{
                    font.bold: true;
                    font.pointSize: 12;
                    anchors.centerIn: parent;
                    text:"发送(回车)";
                }
            }
        }
    }



    Connections{
        target: root.sever;
        onMsgfinish:{
            chatrec.append(root.sever.msg);
        }
    }
}
