#include <QString>
#include <QImage>
#include <QDebug>
#include <QQmlEngine>
#include <QtAndroid>
#include "keychain.h"

namespace android {
    KeyChain::KeyChain(QObject *parent)
        : KeyChainInterface(parent),
          m_jwt("")
    {
    }

    void KeyChain::setJwt(const QString &jwt){
        QAndroidJniObject activity =  QtAndroid::androidActivity();
        QAndroidJniObject appContext = activity.callObjectMethod("getApplicationContext","()Landroid/content/Context;");
        QAndroidJniObject jwtStr = QAndroidJniObject::fromString(jwt);
        QAndroidJniObject result = QAndroidJniObject::callStaticObjectMethod("io/imagemonkey/thegame/JavaNatives",
                                                  "encrypt",
                                                  "(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;",
                                                  appContext.object<jobject>(), jwtStr.object<jstring>());


        if(result.toString() != "")
            set("jwt", result.toString()); //save encoded string

        m_jwt = jwt; //cache plain jwt in member variable
    }

    QString KeyChain::getJwt(const bool fromService) const{
        if(m_jwt != "") //if jwt already cached, return cached jwt
            return m_jwt;

        //if not cached, get encoded jwt and decode it
        QString jwt = get("jwt");
        QAndroidJniObject jwtStr = QAndroidJniObject::fromString(jwt);
        QAndroidJniObject result;

        if(!fromService){
            QAndroidJniObject activity =  QtAndroid::androidActivity();
            QAndroidJniObject appContext = activity.callObjectMethod("getApplicationContext","()Landroid/content/Context;");
            result = QAndroidJniObject::callStaticObjectMethod("io/imagemonkey/thegame/JavaNatives",
                                                      "decrypt",
                                                      "(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;",
                                                      appContext.object<jobject>(), jwtStr.object<jstring>());
        }
        else{
            QAndroidJniObject service =  QtAndroid::androidService();
            result = QAndroidJniObject::callStaticObjectMethod("io/imagemonkey/thegame/JavaNatives",
                                                      "decrypt",
                                                      "(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;",
                                                      service.object<jobject>(), jwtStr.object<jstring>());
        }
        return result.toString();
    }

    QString KeyChain::getJwt() const{
        return getJwt(false);
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

