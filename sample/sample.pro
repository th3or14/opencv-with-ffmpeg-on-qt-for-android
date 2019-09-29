QT += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = sample
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        widget.cpp

HEADERS += \
        widget.hpp

FORMS += \
        widget.ui

CONFIG += mobility
MOBILITY = 

QMAKE_CXXFLAGS += -Wall -Wextra

defineTest(booleanFind) {
    res = $$find($$1, $$2)
    !count(res, 0): return(true)
    return(false)
}

defineReplace(extractArchitectureFromKit) {
    booleanFind(QMAKESPEC, android_armv7): return (armeabi-v7a)
    booleanFind(QMAKESPEC, android_x86): return (x86)
}

ARCHITECTURE = $$extractArchitectureFromKit()

OPENCV_BUILD_DIR = $$(OPENCV_SRC_DIR)/build-android-$$ARCHITECTURE
FFMPEG_BUILD_DIR = $$(FFMPEG_SRC_DIR)/build-android-$$ARCHITECTURE

INCLUDEPATH += \
    $$OPENCV_BUILD_DIR/install/sdk/native/jni/include

LIBS += \
    -L$$OPENCV_BUILD_DIR/install/sdk/native/libs/$$ARCHITECTURE \
    -lopencv_world \
    -lopencv_img_hash

ANDROID_EXTRA_LIBS += \
    $$OPENCV_BUILD_DIR/install/sdk/native/libs/$$ARCHITECTURE/libopencv_world.so \
    $$OPENCV_BUILD_DIR/install/sdk/native/libs/$$ARCHITECTURE/libopencv_img_hash.so
