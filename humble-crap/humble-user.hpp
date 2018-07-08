/****************************************************************************
* Copyright © 2015 Luke Salisbury
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
#include "humble-network.hpp"
#include "local-cookie-jar.hpp"


class HumbleUser: public QObject
{
	Q_OBJECT

public:
	explicit HumbleUser(QObject *parent= 0);

	Q_INVOKABLE QString getErrorMessage();

	Q_INVOKABLE void gatherLoginToken();
	Q_INVOKABLE void login(QString email, QString password, QString pin);

	Q_INVOKABLE void updateOrders();
	Q_INVOKABLE QString getOrders();

	Q_INVOKABLE QString getUser();
	Q_INVOKABLE QString getCaptcha();

	Q_INVOKABLE void setUser(QString email);
	Q_INVOKABLE void setCaptcha(QString challenge, QString response);
	Q_INVOKABLE void setHumbleGuard(QString pin);

	Q_INVOKABLE	void clearUserCookies();

	Q_INVOKABLE	int retrieveSignedDownloadURL(QString ident, QString machine_name, QString filename);

	private:
	QString getCsrfValue();
	void clearRequestSignals();



signals:
	void signedDownloadError(QString ident, QString error);
	void signedDownloadSuccess(QString ident, QString url);

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
	bool loginSuccessful = 0;
	bool testMode = 0;
	bool signedDownloadRequesting = 0;
	QString signedDownloadIdent = "";
	QString errorMessage;

};

#endif // HUMBLEUSER_HPP
