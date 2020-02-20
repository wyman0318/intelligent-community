#-------------------------------------------------
#
# Project created by QtCreator 2020-02-16T10:12:00
#
#-------------------------------------------------

QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Community_server
TEMPLATE = app


SOURCES += main.cpp\
        widget.cpp \
    imagedialog.cpp \
    useradvice.cpp

HEADERS  += widget.h \
    imagedialog.h \
    useradvice.h

FORMS    += widget.ui \
    imagedialog.ui \
    useradvice.ui
