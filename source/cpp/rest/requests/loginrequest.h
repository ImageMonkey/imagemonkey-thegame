#ifndef LOGINREQUEST_H
#define LOGINREQUEST_H


#include "sslrequest.h"
#include "basicrequest.h"

class LoginRequest : public BasicRequest {
    Q_OBJECT
public:
    LoginRequest();
    Q_INVOKABLE void setUsername(const QString& username);
    Q_INVOKABLE void setPassword(const QString& password);
    ~LoginRequest();
private:
    QString m_username;
    QString m_password;
};


#endif // LOGINREQUEST_H
