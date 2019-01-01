#include "loginrequest.h"

#include <QUrlQuery>
#include <QUuid>

LoginRequest::LoginRequest()
    : BasicRequest (),
      m_username(""),
      m_password("")
{
    QUrl url(m_baseUrl + "login");
    m_request->setUrl(url);
}

void LoginRequest::setUsername(const QString& username){
    m_username = username;
    m_request->setRawHeader("Authorization", "Basic " + QByteArray(QString("%1:%2").arg(m_username).arg(m_password).toUtf8()).toBase64());
}

void LoginRequest::setPassword(const QString& password){
    m_password = password;
    m_request->setRawHeader("Authorization", "Basic " + QByteArray(QString("%1:%2").arg(m_username).arg(m_password).toUtf8()).toBase64());
}

LoginRequest::~LoginRequest() {
}
