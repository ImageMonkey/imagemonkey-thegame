#include "donate.h"
#include <QUrlQuery>
#include <QUuid>

DonateImageAndLabel::DonateImageAndLabel()
    : BasicRequest ()
{
    QUrl url(m_baseUrl + "games/imagehunt/donate");
    m_request->setUrl(url);
}

void DonateImageAndLabel::set(const QByteArray& imageData, const QString& label) {
    QString uuid = QUuid::createUuid().toByteArray();
    QString boundary = "boundary_.oOo._" + uuid.mid(1,36).toUpper();

    QByteArray data(QString("--" + boundary + "\r\n").toUtf8());
    data.append("Content-Disposition: form-data; name=\"label\"\r\n\r\n");
    data.append((label + "\r\n"));
    data.append("--" + boundary + "\r\n"); //according to rfc 1867
    data.append("Content-Disposition: form-data; name=\"image\"; filename=\"file.jpg\"\r\n");
    data.append("Content-Type: image/jpeg\r\n\r\n"); //data type

    data.append(imageData);
    data.append("\r\n");
    data.append("--" + boundary + "--\r\n"); //closing boundary according to rfc 1867

    setData(data);

    m_request->setRawHeader(QString("Content-Type").toUtf8(), QString("multipart/form-data; boundary=" + boundary).toUtf8());
    m_request->setRawHeader(QString("Content-Length").toUtf8(), QString::number(data.length()).toUtf8());
}

DonateImageAndLabel::~DonateImageAndLabel() {
}
