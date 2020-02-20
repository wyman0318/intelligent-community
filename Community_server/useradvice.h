#ifndef USERADVICE_H
#define USERADVICE_H

#include <QDialog>
#include <QStringList>
#include <QMap>

namespace Ui {
class userAdvice;
}

class userAdvice : public QDialog
{
    Q_OBJECT

public:
    explicit userAdvice(QWidget *parent = 0);
    ~userAdvice();
    void addNewAdvice(QStringList list);
    QString getAnswer(QString addr);

private slots:
    void on_finishbtn_clicked();

    void on_replyBtn_clicked();

    void on_quitBtn_clicked();

private:
    Ui::userAdvice *ui;

    int row;
    QMap<int,QString> answer;

};

#endif // USERADVICE_H
