#ifndef STATSREQUEST_H
#define STATSREQUEST_H

#include "sslrequest.h"
#include "basicrequest.h"

class GetStatsRequest : public BasicRequest {
    Q_OBJECT
public:
    GetStatsRequest();
    Q_INVOKABLE void setUsername(const QString& username);
    Q_INVOKABLE void setOffsetFromUtc(const int offsetFromUtc);
    ~GetStatsRequest();
private:
    QString m_username;
    int m_offsetFromUtc;
};


#endif // STATSREQUEST_H
