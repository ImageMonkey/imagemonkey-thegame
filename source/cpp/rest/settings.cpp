#include "settings.h"

QObject* ConnectionSettings::connectionSettingsProvider(QQmlEngine *engine, QJSEngine *scriptEngine){
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    return ConnectionSettings::instance();
}

ConnectionSettings* ConnectionSettings::instance() {
    static ConnectionSettings* connectionSettings = new ConnectionSettings();
    return connectionSettings;
}

void ConnectionSettings::setIpAddress(const QString& ipAddress){
    m_ipAddress = ipAddress;
    m_baseUrl = QString("https://") + m_ipAddress + QString(":") +
                    QString::number(m_port) + QString("/v") + QString::number(m_apiVersion) + "/";
}

QString ConnectionSettings::getIpAddress() const{
    return m_ipAddress;
}

QString ConnectionSettings::getBaseUrl() const{
    return m_baseUrl;
}

void ConnectionSettings::setBaseUrl(const QString& baseUrl){
    m_baseUrl = baseUrl;
}

quint16 ConnectionSettings::getPort() const{
    return m_port;
}

void ConnectionSettings::setPort(const quint16 port){
    m_port = port;
    m_baseUrl = ((m_protocol == HTTPS) ? QString("https://") : QString("http://")) + m_ipAddress + QString(":") +
                    QString::number(m_port) + QString("/v") + QString::number(m_apiVersion) + "/";
}

void ConnectionSettings::setVerifySSL(const bool verifySSL){
    m_verifySSL = verifySSL;
}

bool ConnectionSettings::getVerifySSL() const{
    return m_verifySSL;
}

void ConnectionSettings::setApiVersion(const quint8 apiVersion){
    m_apiVersion = apiVersion;
    m_baseUrl = ((m_protocol == HTTPS) ? QString("https://") : QString("http://")) + m_ipAddress + QString(":") +
                    QString::number(m_port) + QString("/v") + QString::number(m_apiVersion) + "/";
}

void ConnectionSettings::setProtocol(const Protocol &protocol){
    m_protocol = protocol;

    setApiVersion(m_apiVersion);
    setIpAddress(m_ipAddress);
}

void ConnectionSettings::setEnforceSecureCiphers(const bool enforceSecureCiphers){
    m_enforceSecureCiphers = true;
}

bool ConnectionSettings::enforceSecureCiphers() const{
    return m_enforceSecureCiphers;
}
