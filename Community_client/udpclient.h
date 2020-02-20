#ifndef UDPCLIENT_H
#define UDPCLIENT_H

#include <QObject>
#include <QUdpSocket>
#include <QHostAddress>
#include <QHostInfo>
#include <QDebug>

class UdpClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QString> imagearray READ getImageUrl)
    Q_PROPERTY(QList<QString> newsarray READ getnews)
    Q_PROPERTY(QList<QString> urlarray READ getnewsUrl)
    Q_PROPERTY(QString msg READ getmsg)
public:
    explicit UdpClient(QObject *parent = nullptr);
    ~UdpClient();
    QString getmsg() const
    {
        return  msg;
    }
    QList<QString> getImageUrl() const
    {
        return ImageUrl;
    }
    QList<QString> getnews() const
    {
        return news;
    }
    QList<QString> getnewsUrl() const
    {
        return newsUrl;
    }

signals:
    void initfinish();
    void msgfinish();
    void register_result(bool flag);
    void login_result(bool flag);
    void answer(QList<QString> info);
    void answer_clear();
    void ad_set(QString info);

private:
    QUdpSocket *socket;
    QList<QHostAddress> list;
    int count;
    QList<QString> ImageUrl;
    QList<QString> news;
    QList<QString> newsUrl;
    QString msg;

public slots:
    void sendUdpMsg(QString sendinfo);
    void readyReadSlot();
    void chatmsg(QString msg);
};

#endif // UDPCLIENT_H
