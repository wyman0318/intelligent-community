#include "useradvice.h"
#include "ui_useradvice.h"
#include <QTableWidgetItem>

userAdvice::userAdvice(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::userAdvice)
{
    ui->setupUi(this);

    row=0;

    QStringList header;
    ui->userlist->setRowCount(20);
    ui->userlist->setColumnCount(4);
    header<<"用户"<<"问题分类"<<"状态"<<"描述";
    ui->userlist->setHorizontalHeaderLabels(header);//标题头
    ui->userlist->setEditTriggers(QAbstractItemView::NoEditTriggers);//不能被编辑
    ui->userlist->setColumnWidth(3,300);
}

userAdvice::~userAdvice()
{
    delete ui;
}

void userAdvice::addNewAdvice(QStringList list)
{
    for(int i=0;i<4;i++)
    {
        ui->userlist->setItem(row,i,new QTableWidgetItem(list[i]));
    }
    row++;
}

QString userAdvice::getAnswer(QString addr)
{
    QString list;
    for(int i=0,j=0;i<row;i++)
    {
        if(ui->userlist->item(i,0)->text().contains(addr))
        {
            list.append(QString("#list%1#").arg(j++));
            list.append(QString("#classify#%1#state#%2#content#%3#reply#%4")
                           .arg(ui->userlist->item(i,1)->text())
                           .arg(ui->userlist->item(i,2)->text())
                           .arg(ui->userlist->item(i,3)->text())
                           .arg(answer.value(i,"")));
        }
    }
    return list;
}

void userAdvice::on_finishbtn_clicked()
{
    ui->userlist->setItem(ui->userlist->currentRow(),2,new QTableWidgetItem("已完成"));
}

void userAdvice::on_replyBtn_clicked()
{
    ui->userlist->setItem(ui->userlist->currentRow(),2,new QTableWidgetItem("进行中"));
    answer[ui->userlist->currentRow()]=ui->remsg->document()->toPlainText();
}

void userAdvice::on_quitBtn_clicked()
{
    this->hide();
}
