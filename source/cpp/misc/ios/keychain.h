#ifndef IOSKEYCHAIN_H
#define IOSKEYCHAIN_H

#include <QString>
#include <QImage>
#include <QQmlEngine>
#include "../source/cpp/misc/keychaininterface.h"

namespace ios {
    class KeyChain : public KeyChainInterface{
        Q_OBJECT
        Q_PROPERTY(QString jwt READ getJwt WRITE setJwt NOTIFY jwtChanged)
    public:
        KeyChain(QObject* parent = 0);
        bool add(const QString& key, const QString& value);
        bool update(const QString& key, const QString& value);
        bool addOrUpdate(const QString& key, const QString& value);
        bool remove(const QString& key);
        bool contains(const QString& key) const;
        QString get(const QString& key) const;
        Q_INVOKABLE void setJwt(const QString& jwt);
        Q_INVOKABLE QString getJwt() const;
        ~KeyChain();
    private:
        QString m_jwt;
    signals:
        void jwtChanged();
    };

}


#endif // IOSKEYCHAIN_H
