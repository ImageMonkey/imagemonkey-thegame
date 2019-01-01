#ifndef __MAIN__H__
#define __MAIN__H__

#include "executiontargetdef.h"
#include "rest/requests/statsrequest.h"
#include "rest/requests/loginrequest.h"
#include "rest/httpsrequestworker.h"
#include "models/tasksmodel.h"
#include "misc/file.h"
#include "misc/imageprocessor.h"
#include "rest/requests/donate.h"
#include "misc/base64imageprovider.h"
#include "rest/requests/tasksrequest.h"

#ifdef Q_OS_IOS
#include "misc/ios/keychain.h"
#endif

#ifdef Q_OS_WIN32
#include "misc/windows/keychain.h"
#endif

#ifdef Q_OS_OSX
#include "misc/osx/keychain.h"
#endif

#ifdef Q_OS_ANDROID
#include "misc/android/keychain.h"
#endif

#endif /*#ifndef __MAIN__H__*/
