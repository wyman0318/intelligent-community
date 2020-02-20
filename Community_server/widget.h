#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QHostAddress>
#include <QUdpSocket>
#include <QHostInfo>
#include <QMap>
#include <QDebug>
#include <QFile>
#include <QIODevice>
#include "imagedialog.h"
#include "useradvice.h"

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = 0);
    ~Widget();
    void RetRequest(QByteArray request,QHostAddress addr);

private slots:
    void on_startBtn_clicked();
    void readyReadSlot();

    void on_ImageSet_clicked();

    void on_userAdvice_clicked();

private:
    Ui::Widget *ui;
    QUdpSocket *socket;
    bool isListenning;
    QMap<QString,quint16> map;
    QMap<QString,QString> account_info;
    QStringList image;
    QStringList news;
    QStringList urls;
    QFile file;

    ImageDialog *myimage;
    userAdvice *myadvice;
};

#endif // WIDGET_H
