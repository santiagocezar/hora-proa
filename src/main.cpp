#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <data.h>
#include <QQmlContext>

#include <iostream>
using namespace std;

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Data p;
    p.open("aa");
    engine.rootContext()->setContextProperty("dta", &p);

    QFontDatabase::addApplicationFont(":assets/material-icons.ttf");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    auto r = app.exec();
    p.save("aa");
    return r;
}
