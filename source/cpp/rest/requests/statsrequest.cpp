#include "statsrequest.h"
#include <QUrlQuery>
#include <QUuid>

GetStatsRequest::GetStatsRequest()
    : BasicRequest (),
      m_username("")
{
}

void GetStatsRequest::setUsername(const QString& username) {
    m_username = username;

    QUrl url(m_baseUrl + "user/" + m_username + "/games/imagehunt/stats?utc_offset" + QString::number(m_offsetFromUtc));
    m_request->setUrl(url);
}

void GetStatsRequest::setOffsetFromUtc(const int offsetFromUtc) {
    m_offsetFromUtc = offsetFromUtc;

    QUrl url(m_baseUrl + "user/" + m_username + "/games/imagehunt/stats?utc_offset" + QString::number(m_offsetFromUtc));
    m_request->setUrl(url);
}

GetStatsRequest::~GetStatsRequest() {
}
