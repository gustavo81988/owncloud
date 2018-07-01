#-------------------------------------------------
#
# Project created by QtCreator 2014-02-12T23:22:25
#
#-------------------------------------------------

QT += core gui
QT += widgets
QT += macextras

HEADERS += \
    $$PWD/macstandardicon.h \
    $$PWD/macpreferenceswindow.h \
    $$PWD/macwindow.h

OBJECTIVE_SOURCES += \
    $$PWD/macstandardicon.mm \
    $$PWD/macpreferenceswindow.mm \
    $$PWD/macwindow.mm

INCLUDEPATH += $$PWD

LIBS_PRIVATE += -framework AppKit
