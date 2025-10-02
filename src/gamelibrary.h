#ifndef GAMELIBRARY_H
#define GAMELIBRARY_H

#include <QObject>
#include <QAbstractListModel>
#include <QQmlListProperty>
#include <QJsonObject>
#include <QJsonArray>
#include <QProcess>
#include "game.h"

class GameLibrary : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum GameRoles {
        TitleRole = Qt::UserRole + 1,
        ExecutablePathRole,
        IconPathRole,
        IsFavoriteRole
    };

    explicit GameLibrary(QObject *parent = nullptr);
    virtual ~GameLibrary();

    // QAbstractListModel interface
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // Properties
    int count() const { return m_games.size(); }

    // Game management methods
    Q_INVOKABLE void addGame(const QString &title, const QString &executablePath);
    Q_INVOKABLE void removeGame(int index);
    Q_INVOKABLE void launchGame(int index);
    Q_INVOKABLE void toggleFavorite(int index);
    Q_INVOKABLE QString openFileDialog();
    
    // Persistence methods
    Q_INVOKABLE void saveLibrary();
    Q_INVOKABLE void loadLibrary();
    
    // Filter methods
    Q_INVOKABLE QList<int> getFavoriteIndices() const;
    Q_INVOKABLE QList<int> getRecentlyAddedIndices() const;
    
    // Settings/Info methods
    Q_INVOKABLE QString getLibraryPath() const;
    Q_INVOKABLE QString getAppVersion() const;

signals:
    void countChanged();
    void gameAdded(const QString &title);
    void gameLaunched(const QString &title);
    void errorOccurred(const QString &message);

private:
    QList<Game*> m_games;
    QString getLibraryFilePath() const;
    void extractIconFromExecutable(Game* game);
};

#endif // GAMELIBRARY_H