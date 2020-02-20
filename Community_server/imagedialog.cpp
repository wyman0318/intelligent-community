#include "imagedialog.h"
#include "ui_imagedialog.h"
#include <QInputDialog>

ImageDialog::ImageDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ImageDialog)
{
    ui->setupUi(this);
    QStringList list;

    //轮播图默认（懒得手动加了，反正添加的功能也有）
    list << "https://tu1.whhost.net/uploads/20181011/23/1539271568-CDgeBNfqrn.jpg"
         << "http://pic.haixia51.com/pic/?p=/qianqianhua/20180518/03/1526585503-fisYUGPeyv.jpg"
         << "http://img.juimg.com/tuku/yulantu/110111/292-110111035J3100.jpg";
    ui->ImageList->addItems(list);

    list.clear();
    QStringList urllist;
    list << "加强沪住宅小区、商务楼宇疫情防控检查"
         << "\"第一届邻里杯\"社区趣味运动会圆满"
         << "重回武汉肺炎起点：卖野味的华南市场老板是谁？"
         << "吉林松原：白衣战士血誓驰援武汉";
    urllist << "https://www.thepaper.cn/newsDetail_forward_6040888"
            << "http://news.iwuye.com/XiaoQu/201911/123755.shtml"
            << "http://www.csvs.net.cn/news/105298301/80703.html"
            << "http://www.csvs.net.cn/news/105298301/80750.html";
    ui->newsList->addItems(list);
    ui->urlList->addItems(urllist);
    ui->ad->setText("https://img.zcool.cn/community/01323158a14c43a8012060c83cec8b.jpg@1280w_1l_2o_100sh.jpg");
}

ImageDialog::~ImageDialog()
{
    delete ui;
}

QStringList ImageDialog::get_imagelist()
{
    QStringList list;
    for(int i=0;i<ui->ImageList->count();i++)
    {
        list << ui->ImageList->item(i)->text();
    }
    return list;
}

QStringList ImageDialog::get_newslist()
{
    QStringList list;
    for(int i=0;i<ui->newsList->count();i++)
    {
        list << ui->newsList->item(i)->text();
    }
    return list;
}

QStringList ImageDialog::get_urllist()
{
    QStringList list;
    for(int i=0;i<ui->urlList->count();i++)
    {
        list << ui->urlList->item(i)->text();
    }
    return list;
}

QString ImageDialog::get_ad()
{
    return ui->ad->text();
}

void ImageDialog::on_addBtn_clicked()
{
    QString text=QInputDialog::getText(this,"请输入轮播图URL","轮播图URL");
    if(!(text.isEmpty()||text.isNull()))
    {
        ui->ImageList->addItem(text);
    }
}

void ImageDialog::on_delBtn_clicked()
{
    ui->ImageList->removeItemWidget(ui->ImageList->currentItem());
}

void ImageDialog::on_newsaddBtn_clicked()
{
    QString text=QInputDialog::getText(this,"请输入新闻标题","标题");
    if(!(text.isEmpty()||text.isNull()))
    {
        ui->newsList->addItem(text);
    }
}

void ImageDialog::on_newsdelBtn_clicked()
{
    ui->newsList->removeItemWidget(ui->ImageList->currentItem());
}

void ImageDialog::on_urladdBtn_clicked()
{
    QString text=QInputDialog::getText(this,"请输入新闻url","URL");
    if(!(text.isEmpty()||text.isNull()))
    {
        ui->urlList->addItem(text);
    }
}

void ImageDialog::on_urldelBtn_clicked()
{
    ui->urlList->removeItemWidget(ui->ImageList->currentItem());
}

void ImageDialog::on_quitBtn_clicked()
{
    this->hide();
}

void ImageDialog::on_okBtn_clicked()
{
    emit finished();
    this->hide();
}
