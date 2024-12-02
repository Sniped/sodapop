#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "datamanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DataManager dataManager;
    engine.rootContext()->setContextProperty("dataManager", &dataManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QtAthon", "Main");

    return app.exec();
}
