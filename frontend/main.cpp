#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
//#include "sensordatagenerator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //SensorDataGenerator dataGenerator;
    //engine.rootContext()->setContextProperty("sensorData", &dataGenerator);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QtAthon", "Main");

    //dataGenerator.startGenerating();

    return app.exec();
}
