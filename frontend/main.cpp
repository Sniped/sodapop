#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "datamanager.h"
#include "logsmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DataManager dataManager;
    dataManager.start();

    qmlRegisterType<DataManager>("com.example.backend", 1, 0, "DataManager");

    qmlRegisterType<LogsModel>("QtAthon.Models", 1, 0, "LogsModel");

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
