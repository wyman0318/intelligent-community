#include "udpclient.h"

UdpClient::UdpClient(QObject *parent) : QObject(parent)
{
    socket = new QUdpSocket(this);
    count =0;

    QString hostname = QHostInfo::localHostName();
    QHostInfo info = QHostInfo::fromName(hostname);

    list = info.addresses();
    socket->bind(QHostAddress(list[3]),QString("50002").toUShort());

    foreach(QHostAddress addr,list)
    {
        qDebug() <<addr.toString();
    }

    connect(socket,SIGNAL(readyRead()),this,SLOT(readyReadSlot()));
}

UdpClient::~UdpClient()
{
    delete socket;
}

void UdpClient::sendUdpMsg(QString sendinfo)
{
    qDebug() << "send";
    QByteArray text(sendinfo.toStdString().c_str());
    //错误会返回-1
    socket->writeDatagram(text,text.length(),
                             QHostAddress(QString("192.168.47.135")),
                             QString("50001").toUShort());

}

void UdpClient::readyReadSlot()
{
    QByteArray data;
    data.resize(socket->pendingDatagramSize());
    socket->readDatagram(data.data(),data.size());
    if(QString(data.data()).startsWith("#image#"))
    {
        ImageUrl.push_back(QString(data.data()).remove(QString("#image#")));
    }
    else if(QString(data.data()).startsWith("#news#"))
    {
        news.push_back(QString(data.data()).remove(QString("#news#")));
    }
    else if(QString(data.data()).startsWith("#url#"))
    {
        newsUrl.push_back(QString(data.data()).remove(QString("#url#")));
    }
    else if(QString(data.data()).startsWith("#ad#"))
    {
        QString text=QString(data.data()).remove("#ad#");
        emit ad_set(text);
    }
    else if(QString(data.data()).contains("#initfinish#"))
    {
        emit initfinish();
    }
    else if(QString(data.data()).contains("#registerOk#"))
    {
        emit register_result(true);
    }
    else if(QString(data.data()).contains("#registerFail#"))
    {
        emit register_result(false);
    }
    else if(QString(data.data()).contains("#LoginOk#"))
    {
        emit login_result(true);
    }
    else if(QString(data.data()).contains("#LoginFail#"))
    {
        emit login_result(false);
    }
    else if(QString(data.data()).contains("#Answer#"))
    {
        QString text=data.data();
        if(!text.contains("#list0#")) return;//说明没有信息
        emit answer_clear();
        QList<QString> info;
        text.remove("#Answer#");
        for(int i=0;;i++)
        {
            info.clear();
            text=text.mid(text.indexOf(QString("#list%1##classify#").arg(i))+
                          QString("#list%1##classify#").arg(i).length());//可能存在两位数，交给计算机判断
            info << text.left(text.indexOf("#state#"));
            text=text.mid(text.indexOf("#state#")+7);
            info << text.left(text.indexOf("#content#"));
            text=text.mid(text.indexOf("#content#")+9);
            info << text.left(text.indexOf("#reply#"));
            text=text.mid(text.indexOf("#reply#")+7);
            if(text.contains(QString("#list%1#").arg(i+1)))
            {
                info << text.left(text.indexOf(QString("#list%1#").arg(i+1)));
                emit answer(info);
            }
            else
            {
                info << text;
                emit answer(info);
                break;  //没有下一行就退出
            }
        }
    }
    else
    {
        msg=QString(data.data());
        emit msgfinish();
    }
}

void UdpClient::chatmsg(QString msg)
{
    msg.insert(0,"#chat#");
    QByteArray text(msg.toStdString().c_str());
    socket->writeDatagram(text,text.length(),QHostAddress(QString("192.168.47.135")),QString("50001").toUShort());
}



