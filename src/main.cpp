#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "game.h"
#include "gamelibrary.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    // Set application properties for proper data storage
    app.setApplicationName("GameBird");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("GameBird");
    
    // Register QML types
    qmlRegisterType<Game>("GameBird", 1, 0, "Game");
    qmlRegisterUncreatableType<GameLibrary>("GameBird", 1, 0, "GameLibrary", 
                                            "GameLibrary is managed by C++");

    // Create and expose GameLibrary instance to QML
    GameLibrary gameLibrary;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("gameLibrary", &gameLibrary);
    
    const QUrl url(QStringLiteral("qrc:/GameManager/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}