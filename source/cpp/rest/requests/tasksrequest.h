#ifndef TASKSREQUEST_H
#define TASKSREQUEST_H

#include "sslrequest.h"
#include "basicrequest.h"

class GetTasksRequest : public BasicRequest {
    Q_OBJECT
public:
    GetTasksRequest();
    Q_INVOKABLE void setUsername(const QString& username);
    ~GetTasksRequest();
private:
    QString m_username;
};

#endif // TASKSREQUEST_H
