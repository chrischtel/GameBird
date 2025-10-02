#include "game.h"

Game::Game(QObject *parent)
    : QObject(parent)
    , m_isFavorite(false)
{
}

Game::Game(const QString &title, const QString &executablePath, QObject *parent)
    : QObject(parent)
    , m_title(title)
    , m_executablePath(executablePath)
    , m_isFavorite(false)
{
}

void Game::setTitle(const QString &title)
{
    if (m_title != title) {
        m_title = title;
        emit titleChanged();
    }
}

void Game::setExecutablePath(const QString &path)
{
    if (m_executablePath != path) {
        m_executablePath = path;
        emit executablePathChanged();
    }
}

void Game::setIconPath(const QString &path)
{
    if (m_iconPath != path) {
        m_iconPath = path;
        emit iconPathChanged();
    }
}

void Game::setIsFavorite(bool favorite)
{
    if (m_isFavorite != favorite) {
        m_isFavorite = favorite;
        emit isFavoriteChanged();
    }
}

QJsonObject Game::toJson() const
{
    QJsonObject json;
    json["title"] = m_title;
    json["executablePath"] = m_executablePath;
    json["iconPath"] = m_iconPath;
    json["isFavorite"] = m_isFavorite;
    return json;
}

void Game::fromJson(const QJsonObject &json)
{
    setTitle(json["title"].toString());
    setExecutablePath(json["executablePath"].toString());
    setIconPath(json["iconPath"].toString());
    setIsFavorite(json["isFavorite"].toBool());
}