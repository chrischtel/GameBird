#include "gamelibrary.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QFileDialog>
#include <QApplication>
#include <QCoreApplication>
#include <QDebug>
#include <QFileInfo>

GameLibrary::GameLibrary(QObject *parent)
    : QAbstractListModel(parent)
{
    loadLibrary();
}

GameLibrary::~GameLibrary()
{
    qDeleteAll(m_games);
}

int GameLibrary::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_games.size();
}

QVariant GameLibrary::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_games.size())
        return QVariant();

    const Game *game = m_games.at(index.row());

    switch (role) {
    case TitleRole:
        return game->title();
    case ExecutablePathRole:
        return game->executablePath();
    case IconPathRole:
        return game->iconPath();
    case IsFavoriteRole:
        return game->isFavorite();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> GameLibrary::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[ExecutablePathRole] = "executablePath";
    roles[IconPathRole] = "iconPath";
    roles[IsFavoriteRole] = "isFavorite";
    return roles;
}

void GameLibrary::addGame(const QString &title, const QString &executablePath)
{
    // Check if game already exists
    for (const Game *game : m_games) {
        if (game->executablePath() == executablePath) {
            emit errorOccurred("Game already exists in library");
            return;
        }
    }

    beginInsertRows(QModelIndex(), m_games.size(), m_games.size());
    
    Game *newGame = new Game(title, executablePath, this);
    
    // Try to extract icon from executable
    extractIconFromExecutable(newGame);
    
    m_games.append(newGame);
    endInsertRows();
    
    emit countChanged();
    emit gameAdded(title);
    
    // Auto-save when game is added
    saveLibrary();
}

void GameLibrary::removeGame(int index)
{
    if (index < 0 || index >= m_games.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    Game *game = m_games.takeAt(index);
    delete game;
    endRemoveRows();
    
    emit countChanged();
    saveLibrary();
}

void GameLibrary::launchGame(int index)
{
    if (index < 0 || index >= m_games.size())
        return;

    const Game *game = m_games.at(index);
    QString executable = game->executablePath();
    
    if (!QFile::exists(executable)) {
        emit errorOccurred("Executable not found: " + executable);
        return;
    }

    bool launched = QProcess::startDetached(executable);
    if (launched) {
        emit gameLaunched(game->title());
    } else {
        emit errorOccurred("Failed to launch: " + game->title());
    }
}

void GameLibrary::toggleFavorite(int index)
{
    if (index < 0 || index >= m_games.size())
        return;

    Game *game = m_games.at(index);
    bool oldFavorite = game->isFavorite();
    game->setIsFavorite(!oldFavorite);
    
    qDebug() << "Toggling favorite for" << game->title() << "from" << oldFavorite << "to" << game->isFavorite();
    
    QModelIndex modelIndex = this->index(index, 0);
    emit dataChanged(modelIndex, modelIndex, {IsFavoriteRole});
    
    saveLibrary();
}

QString GameLibrary::openFileDialog()
{
    return QFileDialog::getOpenFileName(
        nullptr,
        "Select Game Executable",
        QStandardPaths::standardLocations(QStandardPaths::ApplicationsLocation).first(),
        "Executable Files (*.exe);;All Files (*)"
    );
}

void GameLibrary::saveLibrary()
{
    QString filePath = getLibraryFilePath();
    
    QJsonArray gamesArray;
    for (const Game *game : m_games) {
        gamesArray.append(game->toJson());
    }
    
    QJsonObject rootObject;
    rootObject["games"] = gamesArray;
    rootObject["version"] = "1.0";
    
    QJsonDocument doc(rootObject);
    
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
    } else {
        emit errorOccurred("Failed to save library: " + file.errorString());
    }
}

void GameLibrary::loadLibrary()
{
    QString filePath = getLibraryFilePath();
    
    QFile file(filePath);
    if (!file.exists())
        return; // No library file yet, that's okay
    
    if (!file.open(QIODevice::ReadOnly)) {
        emit errorOccurred("Failed to load library: " + file.errorString());
        return;
    }
    
    QByteArray data = file.readAll();
    file.close();
    
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(data, &error);
    
    if (error.error != QJsonParseError::NoError) {
        emit errorOccurred("Invalid library file format");
        return;
    }
    
    QJsonObject rootObject = doc.object();
    QJsonArray gamesArray = rootObject["games"].toArray();
    
    beginResetModel();
    qDeleteAll(m_games);
    m_games.clear();
    
    for (const QJsonValue &value : gamesArray) {
        Game *game = new Game(this);
        game->fromJson(value.toObject());
        m_games.append(game);
    }
    
    endResetModel();
    emit countChanged();
}

QList<int> GameLibrary::getFavoriteIndices() const
{
    QList<int> indices;
    for (int i = 0; i < m_games.size(); ++i) {
        if (m_games.at(i)->isFavorite()) {
            indices.append(i);
        }
    }
    return indices;
}

QList<int> GameLibrary::getRecentlyAddedIndices() const
{
    QList<int> indices;
    // For MVP, just return the last 10 games added (simple approach)
    int startIndex = qMax(0, m_games.size() - 10);
    for (int i = startIndex; i < m_games.size(); ++i) {
        indices.append(i);
    }
    return indices;
}

QString GameLibrary::getLibraryFilePath() const
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(dataPath);
    }
    return dir.filePath("games.json");
}

QString GameLibrary::getLibraryPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}

QString GameLibrary::getAppVersion() const
{
    return QCoreApplication::applicationVersion() + " (MVP)";
}

void GameLibrary::extractIconFromExecutable(Game* game)
{
    // For MVP, we'll set a default icon path
    // Later we can implement proper icon extraction from Windows executables
    game->setIconPath("qrc:/icons/default-game.png");
    
    // TODO: Implement proper Windows icon extraction
    // This would involve using Windows API to extract .ico from .exe files
}