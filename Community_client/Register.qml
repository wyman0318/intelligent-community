import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.12
import QtQuick.Controls.Styles 1.4

Rectangle {
    id:register;
    visible: true;
    signal loginbtn();
    property var base: Gradient{
        GradientStop{position: 0.0;color: "lightblue";}
        GradientStop{position: 0.5;color: "skyblue";}
        GradientStop{position: 1.0;color: "lightblue";}
        }
    property var press:Gradient{
        GradientStop{position: 0.0;color: "mediumblue";}
        GradientStop{position: 0.5;color: "mediumslateblue";}
        GradientStop{position: 1.0;color: "mediumblue";}
    }
    property var hover:Gradient{
        GradientStop{position: 0.0;color: "lightskyblue";}
        GradientStop{position: 0.5;color: "lightsteelblue";}
        GradientStop{position: 1.0;color: "lightskyblue";}
    }

    function logining(){
        if(root.qnetAccess)
        {
            root.sever.sendUdpMsg("#UserLogin#"+account.text+"#password#"+password.text);
        }
        else{
            root.sever.sendUdpMsg("#Service Request#");
            result_msg.visible=true;
            result_msg.text="连接服务器失败";
        }
    }

    Image{
        id:image1;
        anchors.fill: parent;
        source: "image/image/timg.jfif"
    }

    Text{
        id:text_title;
        z:3;
        text: "欢迎使用智能社区"
        style: Text.Raised;
        styleColor: "#AAAAAA";
        color: "navy";
        font.pointSize: 20;
        font.bold: true;
        anchors.horizontalCenter: frame_Rec.horizontalCenter;
        anchors.bottom: frame_Rec.top;
        anchors.bottomMargin: 20;
    }

    Button{
        id:btn1;
        anchors.top: frame_Rec.bottom;
        anchors.topMargin: 30;
        anchors.left: frame_Rec.left;
        text:"登陆";
        style: btnsty1;
        onClicked: {
            register.logining();
        }
    }

    Button{
        id:btn2;
        anchors.top: frame_Rec.bottom;
        anchors.topMargin: 30;
        anchors.right: frame_Rec.right;
        text:"注册";
        style: btnsty1;
        onClicked: {
            if(account.text!=""&&account.text!=undefined&&password.text!=""&&password.text!=undefined)
            {
                root.sever.sendUdpMsg("#register##user#"+account.text+"#password#"+password.text);
            }
            else{
                result_msg.visible=true;
                result_msg.text="无效注册信息！";
            }
        }
    }

    Component{
        id:btnsty1;
        ButtonStyle{
        background: Item{
            implicitWidth: 80;
            implicitHeight: 30;
            Rectangle{
                radius: 10;
                anchors.fill: parent;
                gradient: control.pressed?press:(control.hovered?hover:base);
                }
            }
        }
    } 

    Rectangle{
        id:frame_Rec;
        width: 250; height: 190;
        anchors.centerIn: parent;
        color: "lightblue";
        smooth: true;
        radius: 20;
        opacity: 0.7;

        Text {
            id: accout_text;
            text: qsTr("账号");
            font.pointSize: 15;
            font.bold: true;
            anchors.top: parent.top;
            anchors.topMargin:50;
            anchors.left: parent.left;
            anchors.leftMargin: 30;

        }

        TextField{
            id:account;
            width: 150;
            height: 30;
            text: "wyman"
            font.pointSize: 15;
            font.bold: true;
            anchors.left: accout_text.right;
            anchors.leftMargin: 10;
            anchors.verticalCenter: accout_text.verticalCenter;
            validator: RegExpValidator{
                regExp: /[a-zA-Z0-9]{5,9}/;
            }
        }

        Text{
            id:password_text;
            text:qsTr("密码");
            font.pointSize: 15;
            font.bold: true;
            anchors.top: accout_text.bottom;
            anchors.topMargin:50;
            anchors.left: parent.left;
            anchors.leftMargin: 30;
        }

        TextField{
            id:password;
            width: 150;
            height: 30;
            font.pointSize: 15;
            font.bold: true;
            anchors.left: password_text.right;
            anchors.leftMargin: 10;
            anchors.verticalCenter: password_text.verticalCenter;
            echoMode:TextInput.Password;
            validator: RegExpValidator{
                regExp: /[a-zA-Z0-9./,]{5,9}/;
            }
            Keys.enabled: true;
            Keys.onReturnPressed: {
                register.logining();
            }
        }

        Text{
            id:result_msg;
            width: parent.width;
            height: 25;
            anchors.top: password.bottom;
            anchors.topMargin: 10;
            anchors.horizontalCenter: parent.horizontalCenter;
            color: "red";
            font.pointSize: 13;
            horizontalAlignment: Text.AlignHCenter;
            visible: false;
        }
    }

    Connections{
        target: root.sever;
        onRegister_result:{
            if(flag==true)
            {
                result_msg.visible=true;
                result_msg.text="注册成功！";
            }
            else{
                result_msg.visible=true;
                result_msg.text="此用户名已被注册";
            }
        }
        onLogin_result:{
            if(flag)
            {
                root.username = account.text+":\n";
                register.loginbtn();
            }
            else
            {
                result_msg.visible=true;
                result_msg.text="用户名或密码错误";
            }
        }

    }
}
