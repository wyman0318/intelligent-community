#include "http_request.h"
#include <QUrlQuery>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

Http_Request::Http_Request(QObject *parent) : QObject(parent)
{
    mange = new QNetworkAccessManager(this);

    //生成键值对方便转换天气图片名字
    WeatherToImage();

    //接口的url
    QUrl url("http://jisutqybmf.market.alicloudapi.com/weather/query?city=%E4%B8%9C%E8%8E%9E");

    //接口的参数
    QUrlQuery query;
    query.addQueryItem("city","东莞");
    url.setQuery(query);

    connect(mange,SIGNAL(finished(QNetworkReply*)),this,SLOT(replyFinish(QNetworkReply*)));

    //报文头部设置
    request.setUrl(url);
//    request.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");
    request.setRawHeader(QByteArray("Host"),QByteArray("jisutqybmf.market.alicloudapi.com"));
    request.setRawHeader(QByteArray("Authorization"),QByteArray("APPCODE 1bc3da8b617343ea83b40c9e5e68116c"));

    //请求
    mange->get(request);

    //一个小时更新一次天气
    request_time.start(3600000);
    connect(&request_time,SIGNAL(timeout()),this,SLOT(TimeRequest()));
}

Http_Request::~Http_Request()
{
    delete mange;
}

void Http_Request::WeatherToImage()
{
    WeatherKey["晴"]=QString().number(0);
    WeatherKey["多云"]=QString().number(1);
    WeatherKey["阴"]=QString().number(2);
    WeatherKey["阵雨"]=QString().number(3);
    WeatherKey["雷阵雨"]=QString().number(4);
    WeatherKey["雷阵雨伴有冰雹"]=QString().number(5);
    WeatherKey["雨夹雪"]=QString().number(6);
    WeatherKey["小雨"]=QString().number(7);
    WeatherKey["中雨"]=QString().number(8);
    WeatherKey["大雨"]=QString().number(9);
    WeatherKey["暴雨"]=QString().number(10);
    WeatherKey["大暴雨"]=QString().number(11);
    WeatherKey["特大暴雨"]=QString().number(12);
    WeatherKey["阵雪"]=QString().number(13);
    WeatherKey["小雪"]=QString().number(14);
    WeatherKey["中雪"]=QString().number(15);
    WeatherKey["大雪"]=QString().number(16);
    WeatherKey["暴雪"]=QString().number(17);
    WeatherKey["雾"]=QString().number(18);
    WeatherKey["冻雨"]=QString().number(19);
    WeatherKey["沙尘暴"]=QString().number(20);

}



void Http_Request::replyFinish(QNetworkReply *reply)
{
    qDebug() << __LINE__;
    QByteArray js(reply->readAll());
    static bool first=true;

    QJsonParseError err;
    QJsonDocument root = QJsonDocument::fromJson(js,&err);

    if(err.error!=QJsonParseError::NoError)
    {
        qDebug() <<"Json格式错误";
        return;
    }
    else
    {
        QJsonObject result = root.object();
        QJsonObject result_obj = result.value("result").toObject();
        qDebug() <<"格式正确";
        if(first)
        {
            weather_info.push_back(result_obj.value("temp").toString());
            weather_info.push_back(result_obj.value("humidity").toString());
            weather_info.push_back(WeatherKey[result_obj.value("weather").toString()]);
        }
        else
        {
            weather_info[0]=result_obj.value("temp").toString();
            weather_info[1]=result_obj.value("humidity").toString();
//            weather_info[2]=result_obj.value("weather").toString();
            weather_info[2]=WeatherKey[result_obj.value("weather").toString()];
        }

        emit weather_finish(weather_info);
    }
}

void Http_Request::TimeRequest()
{
    mange->get(request);
}
