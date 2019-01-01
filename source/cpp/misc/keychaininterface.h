#ifndef KEYCHAININTERFACE_H
#define KEYCHAININTERFACE_H

#include <QObject>

class KeyChainInterface : public QObject{
    Q_OBJECT
public:
    KeyChainInterface(QObject* parent = 0)
        : QObject(parent)
    {}
    virtual void setJwt(const QString& jwt) = 0;
    virtual QString getJwt() const = 0;
    virtual ~KeyChainInterface() {}
};

#endif // KEYCHAININTERFACE_H
