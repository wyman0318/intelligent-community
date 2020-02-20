import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.12
import QtQuick.Controls.Styles 1.4
import HttpRequest.module 1.0
import QtMultimedia 5.9

Rectangle {
    id:userwindow;
    property var i: 0;
    property bool video_run: false;
    property var web_open;

    //加载本体字体
    FontLoader{
        id:myfont;
        source: "other/other_style/Snow-Kei-2.ttf";
    }
    FontLoader{
        id:fontsoul;
        source: "other/other_style/zisoul.ttf";
    }

    //    天气等请求组件
    HttpWeather{
        id:weather;
        onWeather_finish: {
            weather_image.source="wea_icon/weathercn/"+info[2]+".png";
            weather_text.text = "气温:"+info[0]+"°  湿度:"+info[1]+"%";
        }
    }

    //标题框
    Rectangle{
        id:top_title;
        anchors.top: parent.top;
        width: parent.width;
        height: 40;
        color: "white"
        opacity: 0.4
        z:3;
    }
    Image{  //天气图标
        id:weather_image;
        z:3;
        anchors.top: top_title.top;
        anchors.left: top_title.left;
        anchors.leftMargin: 10;
        width: top_title.width/15;
        height: top_title.height;
    }
    Text{   //温度湿度
        id:weather_text;
        z:3;
        anchors.left: weather_image.right;
        anchors.leftMargin: 60;
        anchors.verticalCenter: top_title.verticalCenter;
        width: weather_image.width;
        horizontalAlignment: Text.AlignHCenter;
        font.pointSize: 17;
        font.family: myfont.name;
        font.bold: true;
        style: Text.Sunken;
        styleColor: "skyblue";
    }
    Text{//标题
        id:user_title;
        z:3;
        anchors.horizontalCenter: top_title.horizontalCenter;
        anchors.verticalCenter: top_title.verticalCenter;
        horizontalAlignment: Text.AlignHCenter;
        font.pointSize: 22;
        font.family: fontsoul.name;
        style: Text.Raised;
        styleColor: "white";
        text: "欢迎使用智能社区";
    }


    Text{//日期
        id:date_text;
        z:3;
        height: top_title.height/3-5;
        anchors.top: top_title.top;
        anchors.right: top_title.right;
        anchors.rightMargin: 6;
        horizontalAlignment: Text.AlignHCenter;
        font.pointSize: 13;
        font.bold: true;
        style: Text.Sunken;
        styleColor: "white";
        renderType:Text.NativeRendering
    }
    Text{//时间
        id:time_text;
        z:3;
        height: top_title.height/3*2-5;
        anchors.bottom: top_title.bottom;
        anchors.right: top_title.right;
        anchors.rightMargin: 5;
        horizontalAlignment: Text.AlignHCenter;
        font.pointSize: 17;
        font.bold: true;
        style: Text.Outline;
        styleColor: "grey";
        renderType:Text.NativeRendering
    }
    Timer{
        id:date_timer;
        interval: 1000;
        repeat: true;
        onTriggered: {
            var today=new Date();
            date_text.text=today.toLocaleString(Qt.locale("zh_CN"), "yyyy-MM-dd");
            time_text.text=today.toLocaleString(Qt.locale("zh_CN"), "HH:mm:ss");
        }
    }





    //轮播图组件
    Component{
        id:swipeImage;
        Image{
            asynchronous: true;
        }
    }

    Image{
        id:userbackground;
        z:0;
        source: "image/image/back.jpg";
        anchors.fill: parent;
    }

    //透明轮廓
    Rectangle{
        id:outline;
        width: parent.width/1.5;
        height: parent.height;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: top_title.bottom;
        color: "white";
        opacity: 0.3;
    }

    //轮播图
    Rectangle{
        id:rect;
        z:1
        width: parent.width/1.5;
        height: parent.height/2;
        anchors.top: top_title.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        clip: true;
        SwipeView{
            id:swipeview;
            anchors.fill: parent;

            Timer{
                id:imageSwitch;
                interval: 3500;
                repeat: true;
                onTriggered: {
                    swipeview.currentIndex=(swipeview.currentIndex+1)%3;
                    indicator.currentIndex=swipeview.currentIndex;
                }
            }
        }

        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: {
                imageSwitch.stop();
            }
            onExited: {
                imageSwitch.start();
            }
        }

        PageIndicator{
            id:indicator;
            z:3;
            //            count:imagelist.length;
            interactive: true;//可点击
            anchors.bottom: rect.bottom;
            anchors.bottomMargin: 4;
            anchors.horizontalCenter: rect.horizontalCenter;

            onCurrentIndexChanged: {
                swipeview.currentIndex=currentIndex;
            }
        }
    }

    //初始化
    Connections{
        target: root.sever;
        onInitfinish:{
            var myimage = root.sever.imagearray;
            var mynews = root.sever.newsarray;
            web_open = root.sever.urlarray;
            for(i;i<myimage.length;i++)
            {
                swipeImage.createObject(swipeview,{"source":myimage[i],"x":swipeview.x,"y":swipeview.y,
                                            "width":swipeview.width,"height":swipeview.height});
            }
            for(i=0;i<mynews.length;i++)
            {
                newslist.model.append({"news":mynews[i]});
            }
            indicator.count = myimage.length;
            swipeview.currentIndex=0;
            imageSwitch.start();
        }
    }

    //小区宣传视频
    Rectangle{
        id:publicity;
        width: 175+2;
        height: 100+2;
        anchors.left: outline.left;
        anchors.leftMargin: 20;
        anchors.top: rect.bottom;
        anchors.topMargin: 25;
        color: "skyblue";
        z:3;
        border.color: "black";
        border.width: 2;
        MediaPlayer{
            id:player;
            autoPlay: false;
            source: "D:/qtprogram/Qml_pro/Intelligent_Community_Manage/video.flv";
            onError: {
                console.debug(errorString);
            }
        }
        VideoOutput{
            width: 175; height: 150;
            anchors.centerIn: parent;
            source: player;
        }
        MouseArea{
            hoverEnabled: true;
            anchors.fill: parent;
            onClicked: {
                if(!video_run){
                    media_control.source="image/image/ic_pause.png";
                    media_control.visible=false;
                    player.play();
                    video_run=true;
                }
                else{
                    media_control.source="image/image/ic_play.png";
                    media_control.visible=true;
                    player.pause();
                    video_run=false;
                }
            }
            onEntered: {
                if(video_run)
                {
                    media_control.visible=true;
                }
            }
            onExited: {
                if(video_run)
                {
                    media_control.visible=false;
                }
            }
        }
        Image{
            id:media_control;
            anchors.centerIn: parent;
            z:4;
            visible: true;
            source: "image/image/ic_play.png"
        }
    }

    //小区新闻
    Component{
        id:newsDelegate;
        Item{
            id:wrapper;
            width: parent.width;
            height: 25;
            MouseArea{
                anchors.fill: parent;
                hoverEnabled: true;
                onClicked: {
                    //点击会出现相应的网页
                    Qt.openUrlExternally(web_open[index]);
                }
                onEntered: {
                    wrapper.ListView.view.currentIndex=index;
                }
            }

            RowLayout{
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                spacing: 5;
                Text{
                    text:news;
                    color:"black";
                    font.bold: true;
                    font.pointSize: 15;
                    font.family: myfont.name;
                    font.underline: true;
                    elide: Text.ElideRight;
                    Layout.fillWidth: true;
                }
            }
        }
    }
    ListView{
        id:newslist;
        z:3;
        width: outline.width-publicity.width-50;
        height: publicity.height;
        anchors.left: publicity.right;
        anchors.leftMargin: 5;
        anchors.top: publicity.top;
        delegate: newsDelegate;
        model:ListModel{
            id:newsModel;
        }
        focus:true;
        highlight: Rectangle{
            color: "lightskyblue";
        }
    }

    Row{
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 20;
        anchors.left: rect.left;
        anchors.leftMargin: 20;
        spacing: 58;
        //物业服务
        Button{
            id:tenement;
            style:ButtonStyle{
                background: Rectangle{
                    implicitWidth: 125;
                    implicitHeight: 125;
                    border.width: 3;
                    border.color: "black";
                    Image {
                        width: parent.width-3;
                        height: parent.height-3;
                        anchors.centerIn: parent;
                        source: "image/image/wuye.jfif"
                        smooth: true;
                        BrightnessContrast{
                            anchors.fill: parent;
                            source: parent;
                            brightness: control.pressed?0.3:0;
                            contrast: control.pressed?0.3:0;
                        }
                    }
                    Text{
                        text:"物业服务";
                        anchors.bottom: parent.bottom;
                        anchors.bottomMargin: 2;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        font.bold: true;
                        font.pointSize: 15;
                    }
                }
            }
        }

        //聊天室
        Button{
            id:intellgent_chat;
            style:ButtonStyle{
                background: Rectangle{
                    implicitWidth: 125;
                    implicitHeight: 125;
                    border.width: 3;
                    border.color: "black";
                    Image {
                        width: parent.width-3;
                        height: parent.height-3;
                        anchors.centerIn: parent;
                        source: "image/image/chat.jpg"
                        smooth: true;
                        BrightnessContrast{
                            anchors.fill: parent;
                            source: parent;
                            brightness: control.pressed?0.3:0;
                            contrast: control.pressed?0.3:0;
                        }
                    }
                    Text{
                        text:"社区聊天";
                        anchors.bottom: parent.bottom;
                        anchors.bottomMargin: 2;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        font.bold: true;
                        font.pointSize: 15;
                    }
                }
            }
            onClicked: {
                room.show();
            }
        }

        //报修服务
        Button{
            id:repairs;
            style:ButtonStyle{
                background: Rectangle{
                    implicitWidth: 125;
                    implicitHeight: 125;
                    border.width: 3;
                    border.color: "black";
                    Image {
                        width: parent.width-3;
                        height: parent.height-3;
                        anchors.centerIn: parent;
                        source: "image/image/repairs.jpg"
                        smooth: true;
                        BrightnessContrast{
                            anchors.fill: parent;
                            source: parent;
                            brightness: control.pressed?0.3:0;
                            contrast: control.pressed?0.3:0;
                        }
                    }
                    Text{
                        text:"报修申请";
                        anchors.bottom: parent.bottom;
                        anchors.bottomMargin: 2;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        font.bold: true;
                        font.pointSize: 15;
                    }
                }
            }
            onClicked: {
                apply.show();
            }
        }

        Button{
            id:repairs_ack;
            style:ButtonStyle{
                background: Rectangle{
                    implicitWidth: 125;
                    implicitHeight: 125;
                    border.width: 3;
                    border.color: "black";
                    Image {
                        width: parent.width-3;
                        height: parent.height-3;
                        anchors.centerIn: parent;
                        source: "image/image/ack.jpg"
                        smooth: true;
                        BrightnessContrast{
                            anchors.fill: parent;
                            source: parent;
                            brightness: control.pressed?0.3:0;
                            contrast: control.pressed?0.3:0;
                        }
                    }
                    Text{
                        text:"申请进度";
                        anchors.bottom: parent.bottom;
                        anchors.bottomMargin: 2;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        font.bold: true;
                        font.pointSize: 15;
                    }
                }
            }
            onClicked: {
                root.sever.sendUdpMsg("#Affirm#");
                affirm.show();
            }
        }
    }

    Chat_room{
        id:room;
    }

    Repir_apply{
        id:apply;
    }

    Affirm{
        id:affirm;
    }

    Component.onCompleted: {
        root.sever.sendUdpMsg("#Service Request#");
        date_timer.start();
    }

}
