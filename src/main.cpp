#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <planilladb.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QFontDatabase::addApplicationFont(":assets/material-icons.ttf");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    PlanillaDB p;

    p.savePlanilla("aa");

    return app.exec();
}
