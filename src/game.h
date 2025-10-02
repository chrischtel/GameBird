#ifndef GAME_H
#define GAME_H

#include <QObject>
#include <QString>
#include <QJsonObject>

class Game : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString executablePath READ executablePath WRITE setExecutablePath NOTIFY executablePathChanged)
    Q_PROPERTY(QString iconPath READ iconPath WRITE setIconPath NOTIFY iconPathChanged)
    Q_PROPERTY(bool isFavorite READ isFavorite WRITE setIsFavorite NOTIFY isFavoriteChanged)

public:
    explicit Game(QObject *parent = nullptr);
    Game(const QString &title, const QString &executablePath, QObject *parent = nullptr);
    
    // Getters
    QString title() const { return m_title; }
    QString executablePath() const { return m_executablePath; }
    QString iconPath() const { return m_iconPath; }
    bool isFavorite() const { return m_isFavorite; }
    
    // Setters
    void setTitle(const QString &title);
    void setExecutablePath(const QString &path);
    void setIconPath(const QString &path);
    void setIsFavorite(bool favorite);
    
    // JSON serialization
    QJsonObject toJson() const;
    void fromJson(const QJsonObject &json);

signals:
    void titleChanged();
    void executablePathChanged();
    void iconPathChanged();
    void isFavoriteChanged();

private:
    QString m_title;
    QString m_executablePath;
    QString m_iconPath;
    bool m_isFavorite;
};

#endif // GAME_H