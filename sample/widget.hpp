#ifndef WIDGET_HPP
#define WIDGET_HPP

#include <QWidget>
#include <QMessageBox>
#include <QStandardPaths>

#include <opencv2/opencv.hpp>
#include <opencv2/videoio/videoio_c.h>

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = 0);
    ~Widget();

private slots:
    void slot_write_video_clicked();

private:
    Ui::Widget *ui;
};

#endif // WIDGET_HPP
