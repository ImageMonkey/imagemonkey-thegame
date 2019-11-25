#include <QString>
#include <QQmlEngine>
#include "keychain.h"

namespace linux1 {
    KeyChain::KeyChain(QObject *parent)
        : KeyChainInterface(parent),
          m_jwt("")
    {
    }

    void KeyChain::setJwt(const QString &jwt){
        set("jwt", jwt);
        m_jwt = jwt;
    }

    QString KeyChain::getJwt() const{
        if(m_jwt != "")
            return m_jwt;
        return get("jwt");
    }

    QString KeyChain::get(const QString& key) const{
        return m_settings.value(key, "").toString();
    }

    void KeyChain::set(const QString& key, const QString& value){
        m_settings.setValue(key, value);
    }

    KeyChain::~KeyChain(){
    }
}

