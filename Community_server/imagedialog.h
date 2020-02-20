#ifndef IMAGEDIALOG_H
#define IMAGEDIALOG_H

#include <QDialog>

namespace Ui {
class ImageDialog;
}

class ImageDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ImageDialog(QWidget *parent = 0);
    ~ImageDialog();
    QStringList get_imagelist();
    QStringList get_newslist();
    QStringList get_urllist();
    QString get_ad();

private slots:
    void on_addBtn_clicked();

    void on_delBtn_clicked();

    void on_newsaddBtn_clicked();

    void on_newsdelBtn_clicked();

    void on_urladdBtn_clicked();

    void on_urldelBtn_clicked();

    void on_quitBtn_clicked();

    void on_okBtn_clicked();

private:
    Ui::ImageDialog *ui;

signals:
    void finished();
};

#endif // IMAGEDIALOG_H
