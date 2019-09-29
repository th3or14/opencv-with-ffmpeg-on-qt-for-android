#include "widget.hpp"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    ui->video_path->setText(QStandardPaths::writableLocation(QStandardPaths::DownloadLocation) +
                            "/hello-world.mp4");
    connect(ui->write_video, &QPushButton::clicked, this, &Widget::slot_write_video_clicked);
}

Widget::~Widget()
{
    delete ui;
}

void Widget::slot_write_video_clicked()
{
    static const QString write_permission = "android.permission.WRITE_EXTERNAL_STORAGE";
    if (QtAndroid::checkPermission(write_permission) == QtAndroid::PermissionResult::Denied)
        QtAndroid::requestPermissionsSync(QStringList() << write_permission);
    static const int frame_width = 320;
    static const int frame_height = 240;
    cv::VideoWriter vw;
    if (!vw.open(ui->video_path->text().toStdString(), CV_FOURCC('M', 'P', '4', 'V'), 60,
                 cv::Size(frame_width, frame_height)))
    {
        QMessageBox::warning(this, "Status", "Can't open file for writing!", QMessageBox::Ok);
        return;
    }
    for (int i = 0; i < 256; ++i)
    {
        cv::Mat frame(frame_height, frame_width, CV_8UC3, cv::Scalar(i, 255 - i, 90));
        cv::putText(frame, "Hello, world!", cv::Size(20, 20), cv::FONT_HERSHEY_COMPLEX_SMALL, 1,
                    cv::Scalar(255, 255, 255));
        vw.write(frame);
    }
    QMessageBox::information(this, "Status", "Success!", QMessageBox::Ok);
}
