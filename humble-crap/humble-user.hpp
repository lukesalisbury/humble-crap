/****************************************************************************
* Copyright © Luke Salisbury
*
* This software is provided 'as-is', without any express or implied
* warranty. In no event will the authors be held liable for any damages
* arising from the use of this software.
*
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
*
* 1. The origin of this software must not be misrepresented; you must not
*    claim that you wrote the original software. If you use this software
*    in a product, an acknowledgement in the product documentation would be
*    appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
*    misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
****************************************************************************/

#ifndef HUMBLEUSER_HPP
#define HUMBLEUSER_HPP

#include <QObject>
#include <QQmlEngine>
#include <QtSql>
#include "humble-network.hpp"
#include "local-cookie-jar.hpp"
#include "humble-database.hpp"

class HumbleUser: public QObject
{
	Q_OBJECT

public:
	explicit HumbleUser(QObject *parent= nullptr);
	~HumbleUser();
	Q_INVOKABLE QString getErrorMessage();

	Q_INVOKABLE void gatherLoginToken();
	Q_INVOKABLE void login(QString email, QString password, QString pin);

	Q_INVOKABLE void updateOrders();
	Q_INVOKABLE QString getOrders();

	Q_INVOKABLE QString getTrove();
	Q_INVOKABLE QString getOrder(QString id, bool useCachedVersion);

	Q_INVOKABLE QString getUser();
	Q_INVOKABLE QString getCaptcha();

	Q_INVOKABLE void setUser(QString email);
	Q_INVOKABLE void setCaptcha(QString challenge, QString response);
	Q_INVOKABLE void setHumbleGuard(QString pin);

	Q_INVOKABLE void clearUserCookies();

	Q_INVOKABLE int retrieveSignedDownloadURL(QString ident, QString cat, QString machine_name, QString filename);

	Q_INVOKABLE QVariantList updateOrder(QString key, QString content);
	Q_INVOKABLE void insertOrder(QString key, QString content);
	Q_INVOKABLE void installProduct(QString ident, QString executable, QString path);
	Q_INVOKABLE QVariantList getItems(QString page, qint32 bits);
	Q_INVOKABLE QVariantMap getItem(QString ident);
	Q_INVOKABLE QVariantList getItemDownloads(QString ident, QString platform);

	QJsonDocument getOrdersJSON();
	QJsonDocument getOrderJSON(QString key);
	private:
	QString getCsrfValue();
	void clearRequestSignals();

signals:
	void signedDownloadError(QString ident, QString cat, QString error);
	void signedDownloadSuccess(QString ident, QString cat, QString url);

	void loginError();
	void loginSuccess();

	void orderError();
	void orderSuccess();

	void loginRequired();
	void captchaRequired();
	void guardRequired();
	void sslMissing();


public slots:
	void signedDownloadReturned( QByteArray content );
	void signedDownloadRejected( QString errorMessage, QByteArray content, qint16 httpCode);

	void loginReturned( QByteArray content );
	void loginRejected( QString errorMessage, QByteArray content, qint16 httpCode);

	void ordersReturned( QByteArray content );
	void ordersRejected( QString errorMessage, QByteArray content, qint16 httpCode);


protected:
	LocalCookieJar * cookies;
	HumbleNetworkRequest request;
	QString currentPassword = "";
	QString currentUser = "";
	QString currentCaptcha = "";
	QByteArray orderContent;
	QString currentSkipCaptcha = "";

private:
	HumbleUserDatabase * db = nullptr;
	bool loginSuccessful = 0;

	bool signedDownloadRequesting = 0;
	QString signedDownloadIdent = "";
	QString signedDownloadCategory = "";
	QString errorMessage;
public:
	bool testMode = 0;

	void userDatabaseLoaded();
};

#endif // HUMBLEUSER_HPP
