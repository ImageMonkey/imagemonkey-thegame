#ifndef __DONATE_H__
#define __DONATE_H__

#include "sslrequest.h"
#include "basicrequest.h"

class DonateImageAndLabel : public BasicRequest {
    Q_OBJECT
public:
    DonateImageAndLabel();
    Q_INVOKABLE void set(const QByteArray& imageData, const QString& label);
    ~DonateImageAndLabel();
};

#endif //__DONATE_H__
