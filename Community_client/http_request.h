#ifndef HTTP_REQUEST_H
#define HTTP_REQUEST_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QMap>
#include <QTimer>

class Http_Request : public QObject
{
    Q_OBJECT
//    Q_PROPERTY(QList<QString> weather_info READ get_weather)
public:
    explicit Http_Request(QObject *parent = nullptr);
    ~Http_Request();
    void WeatherToImage();

//    QList<QString> get_weather(){return weather_info;}

signals:
    void weather_finish(QList<QString> info);

private:
    QNetworkAccessManager *mange;
    QNetworkRequest request;
    QNetworkReply *reply; // 虚基类

    QList<QString> weather_info;
    QMap<QString,QString> WeatherKey;
    QTimer request_time;

private slots:
    void replyFinish(QNetworkReply *reply);
    void TimeRequest();
};

#endif // HTTP_REQUEST_H
