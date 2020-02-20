#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    //对账号和密码的管理
    file.setFileName("account.txt");
    if(!file.open(QIODevice::ReadWrite|QIODevice::Text))
    {
        qDebug()<<"file error";
    }
    while(!file.atEnd())
    {
        //格式都为#user#*****#password#****
        QString str = file.readLine();
        QString name = str.mid(str.indexOf("#user#")+6);
        name = name.left(name.indexOf("#password#"));
        QString password=str.mid(str.indexOf("#password#")+10);

        account_info[name]=password;
    }
    qDebug()<<"读取用户数据完毕";

    //新闻和轮播图
    myimage = new ImageDialog(this);
    myadvice = new userAdvice(this);

    socket = new QUdpSocket(this);

    //获取主机名字
    QString hostname = QHostInfo::localHostName();
    QHostInfo info = QHostInfo::fromName(hostname);

    //获取所有ＩＰ放入下拉框
    QList<QHostAddress> list = info.addresses();
    foreach(QHostAddress addr,list)
    {
        ui->HostCb->addItem(addr.toString());
    }
    //对局域网要这样用ＩＰＶ４
    ui->HostCb->addItem(QString("192.168.47.135"));

    ui->sortLe->setText("50001");
    isListenning = false;

    image=myimage->get_imagelist();
    news =myimage->get_newslist();
    urls =myimage->get_urllist();
}

Widget::~Widget()
{
    delete ui;
    if(file.isOpen())
    {
        file.close();
    }
}

void Widget::RetRequest(QByteArray request,QHostAddress addr)
{
    if(QString(request.data()).contains("#Service Request#"))
    {
        for(int i=0;i<image.length();i++)
        {
            QByteArray text(image[i].toStdString().c_str());
            text.insert(0,"#image#");
            socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
        }
        for(int i=0;i<news.length();i++)
        {
            QByteArray text(news[i].toStdString().c_str());
            QByteArray text2(urls[i].toStdString().c_str());
            text.insert(0,"#news#");
            text2.insert(0,"#url#");
            socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
            socket->writeDatagram(text2,text2.length(),addr,map[addr.toString()]);
        }
        QByteArray text(myimage->get_ad().toStdString().c_str());
        text.insert(0,"#ad#");
        socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
        text=QByteArray("#initfinish#");
        socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
    }
    else if(QString(request.data()).contains("#chat#"))
    {
        for(QMap<QString,quint16>::iterator i=map.begin();i!=map.end();++i)
        {
            QByteArray text(QString(request.data()).mid(6).toStdString().c_str());
            socket->writeDatagram(text,text.length(),QHostAddress(i.key()),i.value());
        }
    }
    else if(QString(request.data()).contains("#register#"))
    {
        QString text(QString(request.data()).remove("#register#").append("\n"));
//        qDebug() <<text.remove("#user#").left(text.indexOf("password")-7);
        QString name = text.mid(text.indexOf("#user#")+6);
        name = name.left(name.indexOf("#password#"));
        QString password=text.mid(text.indexOf("#password#")+10);
        if(account_info.value(name,"failed")=="failed")
        {
            file.write(text.toStdString().c_str());
            qDebug()<<"注册成功";
            account_info[name]=password;
            qDebug() << name;
            qDebug() << password;
            QByteArray text(QString("#registerOk#").toStdString().c_str());
            socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
        }
        else
        {
            QByteArray text(QString("#registerFail#").toStdString().c_str());
            socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
        }
    }
    else if(QString(request.data()).contains("#UserLogin#"))
    {
        QString text(QString(request.data()).remove("#UserLogin#").append("\n"));
        QString name=text.left(text.indexOf("#password#"));
        QString password=text.mid(text.indexOf("#password#")+10);
        if(account_info[name]==password)
        {
            QByteArray text(QString("#LoginOk#").toStdString().c_str());
            socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
        }
        else
        {
            QByteArray text(QString("#LoginFail#").toStdString().c_str());
            socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
        }
    }
    else if(QString(request.data()).contains("#RepirApply#"))
    {
        QString text(QString(request.data()).remove("#RepirApply#"));
        QString classify=text.left(text.indexOf("#content#"));
        QString content=text.mid(text.indexOf("#content#")+9);
        QStringList list;
        list << addr.toString() << classify <<"待确认" << content;
        myadvice->addNewAdvice(list);
    }
    else if(QString(request.data()).contains("#Affirm#"))
    {
        QString ret=myadvice->getAnswer(addr.toString());
        ret.insert(0,"#Answer#");
        qDebug()<< ret;
        QByteArray text(ret.toStdString().c_str());
        socket->writeDatagram(text,text.length(),addr,map[addr.toString()]);
    }
}

void Widget::on_startBtn_clicked()
{
    if(isListenning)
    {
        socket->close();

        ui->startBtn->setText("启动服务器");
        isListenning=false;
    }
    else
    {
        //需要绑定ｉｐｖ４才能被本地地址访问
        socket->bind(QHostAddress(ui->HostCb->currentText()),ui->sortLe->text().toUShort());
        connect(socket,SIGNAL(readyRead()),this,SLOT(readyReadSlot()));

        ui->startBtn->setText("关闭服务器");
        isListenning=true;
    }
}

void Widget::readyReadSlot()
{
    qDebug() << "rec";
    QHostAddress targetaddr;
    quint16 targetport;
    QByteArray data;
    data.resize(socket->pendingDatagramSize());
    socket->readDatagram(data.data(),data.size(),&targetaddr,&targetport);

    //根据键值对判断是否同一用户
    if(map.value(targetaddr.toString(),0)==0)
    {
        map[targetaddr.toString()]=targetport;
        ui->userList->addItem(targetaddr.toString());
    }
    ui->reciveTb->append(QString(data.data()));
    RetRequest(data,targetaddr);
}

void Widget::on_ImageSet_clicked()
{
    myimage->show();
}

void Widget::on_userAdvice_clicked()
{
    myadvice->show();
}
