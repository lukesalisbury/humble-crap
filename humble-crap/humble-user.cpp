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
#include "global.hpp"
#include "humble-user.hpp"
#include "local-cookie-jar.hpp"

#include <QJsonDocument>
/**
 * @brief
 * @return
 */
HumbleUser::HumbleUser(QObject *parent): QObject(parent)
{
	this->testMode = false;

}

/**
 * @brief HumbleUser::getErrorMessage
 * @return
 */
QString HumbleUser::getErrorMessage()
{
	return this->errorMessage;
}

/**
 * @brief HumbleUser::gatherLoginToken
 */
void HumbleUser::gatherLoginToken()
{
	this->clearRequestSignals();
	this->request.makeRequest( QUrl(HUMBLEURL_LOGIN) );
}

/**
 * @brief Set
 * @param email
 */
void HumbleUser::setUser(QString email)
{
	this->currentUser = email;
	this->cookies = new LocalCookieJar(this->currentUser);

	this->request.setCookies(static_cast<QNetworkCookieJar*>(cookies));

	if ( !this->testMode ) {
		//Check if orders page can be access, if not emit login required
		this->updateOrders();
	}

}

/**
 * @brief HumbleUser::setCaptcha
 * @param challenge
 * @param response
 */
void HumbleUser::setCaptcha(QString challenge, QString response)
{
	Q_UNUSED(challenge)
	this->currentCaptcha = response;
}

/**
	Currently Stored Captcha value
 */
QString HumbleUser::getCaptcha()
{
	return this->currentCaptcha;
}

/**
 * @brief HumbleUser::setHumbleGuard
 * @param pin
 */
void HumbleUser::setHumbleGuard(QString pin)
{
	Q_UNUSED(pin)
}

/**
 * @brief HumbleUser::login
 * @param email
 * @param password
 */
void HumbleUser::login( QString email, QString password, QString pin  )
{
	if (this->request.sslMissing)
	{
		emit sslMissing( );
		return;
	}

	if ( email.length() < 4 || password.length() < 6 )
	{
		this->errorMessage = "Please enter correct email and/or password";
		emit loginError( );
		return;
	}
	this->setUser(email);

	QString csrf = this->getCsrfValue();
	if ( csrf.length() < 10 )
	{
		this->errorMessage = "Have not received token yet.";
		emit loginError( );
		return;
	}

	this->cookies->SaveToDisk();

	/* Make requests */
	this->clearRequestSignals();
	connect( &this->request, SIGNAL(requestSuccessful(QByteArray)), this, SLOT(loginReturned(QByteArray)));
	connect( &this->request, SIGNAL(requestError(QString, QByteArray, qint16)), this, SLOT(loginRejected(QString, QByteArray, qint16)) );

	/* POST */
	quint8 loginVersion = 1; // 1: hb_android_app, 2: Website
	if ( loginVersion == 1 )
	{
		this->request.appendPost("recaptcha_challenge_field", "");
		this->request.appendPost("recaptcha_response_field", this->currentCaptcha);
		this->request.appendPost("authy-token", pin);
		this->request.appendPost("code", pin);
		this->request.appendPost("username", email );
		this->request.appendPost("password", password );
		this->request.appendPost("goto", "/");
		this->request.appendPost("_le_csrf_token", csrf);

		this->request.makeRequest( QUrl(HUMBLEURL_PROCESSLOGIN), "hb_android_app" );
	} else if ( loginVersion == 2 ) {
		//Unsupported, I believe captcha workaround does not work with this
		this->request.appendPost("username", email );
		this->request.appendPost("password", password );
		this->request.appendPost("goto", "/home");

		if ( !this->currentSkipCaptcha.isEmpty() ) {
			this->request.appendPost("captcha-skip-code", this->currentSkipCaptcha);
			this->request.appendPost("code", pin);
		} else {
			this->request.appendPost("g-recaptcha-response", this->currentCaptcha);
			this->request.appendPost("captcha-invisible", "true");
		}

		this->request.csrfPreventionToken = csrf;
		this->request.makeRequest( QUrl(HUMBLEURL_PROCESSLOGIN), "XMLHttpRequest" );
	}

}

/**
   @brief
   @param ident product name, often stored as machine_name
   @param filename requested file
 */
int HumbleUser::retrieveSignedDownloadURL(QString ident, QString machine_name, QString filename)
{
	// Humble download must have a token so we
	// use https://www.humblebundle.com/api/v1/user/download/sign with
	// machine_name and filename as post data, returning json object with
	// signed_url and signed_torrent (optional)

	// Limit the request so we can store the ident for the download
	if ( this->signedDownloadRequesting ) {
		emit signedDownloadError(this->signedDownloadIdent, "An Signed Download is already in progress");
		return 0;
	}

	this->signedDownloadRequesting = true;
	this->signedDownloadIdent = ident;

	/* Make requests */
	this->clearRequestSignals();
	connect( &this->request, SIGNAL(requestError(QString, QByteArray, qint16)), this, SLOT(signedDownloadRejected(QString, QByteArray, qint16)) );
	connect( &this->request, SIGNAL(requestSuccessful(QByteArray)), this, SLOT(signedDownloadReturned(QByteArray)));

	this->request.appendPost("machine_name", machine_name);
	this->request.appendPost("filename", filename );

	this->request.makeRequest( QUrl(HUMBLEURL_DOWNLOADSIGN), "XMLHttpRequest" );


	return 1;
}


/**
 * @brief HumbleUser::getOrders
 * @return
 */
QString HumbleUser::getOrders(  )
{
	QString string;

	if ( testMode )
	{
		QString path = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
		QString filepath = QDir(path).filePath("example-order.json");
		QFile file(filepath);
		if ( file.open(QIODevice::ReadOnly | QIODevice::Text) )
		{
			string = QString( file.readAll() );
			file.close();
		}
	}
	else
	{
		string = QString( this->orderContent.data() );
	}

	return string;
}

/**
 * @brief HumbleUser::getUser
 * @return
 */
QString HumbleUser::getUser()
{
	return this->currentUser;
}

/**
 * @brief HumbleUser::updateOrdersPage
 */
void HumbleUser::updateOrders()
{
	if (this->request.sslMissing)
	{
		emit sslMissing( );
		return;
	}
	this->request.setCookies(static_cast<QNetworkCookieJar*>(cookies));

	this->clearRequestSignals();
	connect( &this->request, SIGNAL(requestSuccessful(QByteArray)), this, SLOT(ordersReturned(QByteArray)));
	connect( &this->request, SIGNAL(requestError(QString, QByteArray, qint16)), this, SLOT(ordersRejected(QString, QByteArray, qint16)) );

	this->request.makeRequest( QUrl(HUMBLEURL_LIBRARY) );
}

/**
 * @brief HumbleUser::ordersReturned
 * @param content
 */
void HumbleUser::ordersReturned( QByteArray content )
{
	this->orderContent = content;
	this->loginSuccessful = true;

	this->cookies->SaveToDisk();

	// Cache page content
	QString path = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
	QString filepath = QDir(path).filePath("orders-" + this->currentUser);
	QFile file(filepath);
	if ( file.open(QIODevice::WriteOnly | QIODevice::Text) ) {
		file.write(content);
		file.close();
	}

	emit orderSuccess();
}

/**
 * @brief Check if users is already logged in
 * @param errorMessage
 */
void HumbleUser::ordersRejected(QString errorMessage, QByteArray content, qint16 httpCode)
{
	Q_UNUSED(content);
	Q_UNUSED(httpCode);
	qDebug() << "ordersRejected" << errorMessage;
	this->loginSuccessful = false;

	emit orderError();
}

/**
 * @brief HumbleUser::loginReturned
 * @param content
 */
void HumbleUser::loginReturned( QByteArray content )
{
	//200: forward
	qDebug() << "loginReturned:" << content;

	this->loginSuccessful = true;

	// Login was successful, download latest order page
	this->updateOrders();

	emit loginSuccess();
}

/**
 * @brief HumbleUser::loginRejected
 * @param errorMessage
 */
void HumbleUser::loginRejected( QString errorMessage, QByteArray content, qint16 httpCode )
{
	this->errorMessage = errorMessage;
	if (httpCode == 401)
	{
		//401: {"errors": {"username": ["Email and password don't match"]}, "success": false}
		//401: {"skip_code": ["--", "--"], "two_factor_required": true, "twofactor_type": "google", "errors": {"authy-input": ["Token is required."]}, "success": false}
		//401: {"errors": {"captcha":["Are you sure you're not a robot? Please try again."]}, "captcha_required": true, "success": false}"
		qDebug() << content;

		QJsonDocument responsed = QJsonDocument::fromJson(content);
		if ( responsed["errors"].isObject() )
		{
			QJsonObject errorObject = responsed["errors"].toObject();
			if ( errorObject.contains("captcha") ) {
				this->errorMessage = errorObject["captcha"].toArray().at(0).toString();
				emit captchaRequired();
				return;
			}
			else if ( errorObject.contains("authy-input") ) {
				// Uses the 2nd skip code
				this->currentSkipCaptcha = errorObject["skip_code"].toArray().at(1).toString();
				this->errorMessage = errorObject["authy-input"].toArray().at(0).toString();
				emit guardRequired();
				return;
			}
			else if ( errorObject.contains("username") ) {
				this->errorMessage = errorObject["username"].toArray().at(0).toString();
			}
		}
	}
	emit loginError();
}


/**
 * @brief HumbleUser::signedDownloadReturned
 * @param content JSON response
 */
void HumbleUser::signedDownloadReturned( QByteArray content )
{
	QJsonDocument responsed = QJsonDocument::fromJson(content);
	//"{\n"signed_url":"https://dl.humble.com/necrosoftgames/oh_deer_1.2.1.win.zip?key="... (379)
	if ( responsed["signed_url"].isString() ) {
		emit signedDownloadSuccess(this->signedDownloadIdent, responsed["signed_url"].toString());
	} else {
		emit signedDownloadError(this->signedDownloadIdent, "Signed Download URL wasn't returned");
	}
	this->signedDownloadRequesting = false;
	this->signedDownloadIdent = "";
}

/**
 * @brief
 * @param errorMessage
 */
void HumbleUser::signedDownloadRejected(QString errorMessage, QByteArray content, qint16 httpCode)
{
	Q_UNUSED(httpCode);

	QJsonDocument responsed = QJsonDocument::fromJson(content);
	if ( responsed["_message"].isString() ) {
		errorMessage = responsed["_message"].toString();
	}
	qDebug() << "signedDownloadRejected" << httpCode << errorMessage;

	emit signedDownloadError(this->signedDownloadIdent, errorMessage);
	this->signedDownloadRequesting = false;
	this->signedDownloadIdent = "";
}

/**
 * @brief Gather the Cross-site request forgery value
 * @return Csfr
 */
QString HumbleUser::getCsrfValue()
{
	QString value = "";
	QList<QNetworkCookie> list = cookies->cookiesForUrl( QUrl(HUMBLEURL_COOKIE) );

	for (int i = 0; i < list.size(); ++i)
	{
		if ( list.at(i).name() == "csrf_cookie" )
		{
			value = list.at(i).value();
		}
	}
	return value;
}

/**
 * @brief Empty cookie jar for the current user
 */
void HumbleUser::clearUserCookies() {
	cookies->empty();
	cookies->SaveToDisk();
}


/**
 * @brief Remove Successful and error Signal from request
 */
void HumbleUser::clearRequestSignals()
{
	disconnect(&this->request, SIGNAL(requestSuccessful(QByteArray)), NULL, NULL);
	disconnect(&this->request, SIGNAL(requestError(QString, QByteArray, qint16)), NULL, NULL );
}
