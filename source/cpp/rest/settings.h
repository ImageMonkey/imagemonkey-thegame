#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QQmlEngine>

class ConnectionSettings : public QObject
{
    Q_OBJECT
public:
    enum Protocol{
        HTTP,
        HTTPS
    };
    //singleton type provider function for Qt Quick
    static QObject* connectionSettingsProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
    static ConnectionSettings* instance();
    void setIpAddress(const QString& ipAddress);
    QString getIpAddress() const;
    void setPort(const quint16 port);
    quint16 getPort() const;
    void setBaseUrl(const QString& baseUrl);
    Q_INVOKABLE QString getBaseUrl() const;
    void setVerifySSL(const bool verifySSL);
    bool getVerifySSL() const;
    void setApiVersion(const quint8 apiVersion);
    void setEnforceSecureCiphers(const bool enforceSecureCiphers);
    bool enforceSecureCiphers() const;
    void setProtocol(const Protocol& protocol);
private:
    ConnectionSettings() : m_ipAddress(""), m_port(0), m_baseUrl(""), m_verifySSL(false),
                            m_enforceSecureCiphers(false), m_protocol(HTTPS) {};


    // copy constructor not implemented
    ConnectionSettings(ConnectionSettings const&); // don't Implement
    void operator=(ConnectionSettings const&); // don't implement

    QString m_ipAddress;
    quint16 m_port;
    QString m_baseUrl;
    bool m_verifySSL;
    quint8 m_apiVersion;
    bool m_enforceSecureCiphers;
    Protocol m_protocol;

};

#endif // SETTINGS_H
