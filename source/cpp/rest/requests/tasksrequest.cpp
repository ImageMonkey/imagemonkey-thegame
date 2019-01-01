#include "tasksrequest.h"
#include <QFile>
#include <QUrlQuery>
#include <QUuid>

GetTasksRequest::GetTasksRequest()
    : BasicRequest (),
      m_username("")
{
}

void GetTasksRequest::setUsername(const QString& username) {
    QUrl url(m_baseUrl + "user/" + username + "/games/imagehunt/tasks");
    m_request->setUrl(url);
    m_username = username;
}

GetTasksRequest::~GetTasksRequest() {
}
