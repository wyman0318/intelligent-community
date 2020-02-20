import QtQuick 2.12
import QtQuick.Window 2.12
import UdpClient.module 1.0
import QtQuick.Controls 1.4

Window {
    id:root;
    visible: true;
    x:300; y:200;
    width: 600
    height: 480
    title: qsTr("Welcome!")
    //    flags: Qt.FramelessWindowHint;

    property var sever: sevice;
    property var username;
    property bool qnetAccess:false;
    property int count:4;

    Loader{
        id:registerLoader;
        visible: true;
        anchors.fill:parent;
        source: "Register.qml";
    }

    Connections{
        target: registerLoader.item;
        onLoginbtn:{
            if(qnetAccess)
            {
                console.debug("recive sig");
                root.width=1080;
                root.height=720;
                registerLoader.visible=false;
                registerLoader.source="";//销毁
                root_rec.visible=true;//广告
                ad_timer.start();
            }
        }
    }

    Loader{
        id:userLoader;
        visible: false;
        anchors.fill:parent;
        source: "UserWindow.qml";
    }

    Rectangle{
        id:root_rec;
        anchors.fill: parent;
        visible: false;
        Image{
            id:root_img;
            source: "";
            anchors.fill: parent;
        }
        Text{
            id:root_ad;
            anchors.right: parent.right;
            anchors.rightMargin: 5;
            anchors.top: parent.top;
            anchors.topMargin: 5;
            color: "white";
            font.bold: true;
            font.pointSize: 15;
        }
        Timer{
            id:ad_timer;
            repeat: true;
            interval: 1000;
            onTriggered: {
                root_ad.text="广告时间剩余"+(count-1).toString()+"秒";
                if(count==0)
                {
                    ad_timer.stop();
                    root_img.source="";//销毁
                    root_rec.visible=false;
                    userLoader.visible=true;
                }
                count--;
            }
        }
    }

    UdpClient{
        id:sevice;
        onInitfinish: {
            qnetAccess=true;
        }
        onAd_set: {
            root_img.source=info;
        }
    }

    Behavior on width {
               NumberAnimation { duration: 600; }
           }
    Behavior on height {
               NumberAnimation { duration: 600; }
           }
}
