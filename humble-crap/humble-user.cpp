/****************************************************************************
* Copyright (c) 2015 Luke Salisbury
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

#include "humble-user.hpp"
#include "global.hpp"

#include "local-cookie-jar.hpp"

/**
 * @brief HumbleUser::getErrorMessage
 * @return
 */
HumbleUser::HumbleUser(QObject *parent)
{
    currentCaptcha = "";

}

QString HumbleUser::getErrorMessage()
{
	return errorMessage;
}

void HumbleUser::setUser(QString email)
{
	if ( !testMode )
	{
		this->cookies = new LocalCookieJar(email);

		request.setCookies(static_cast<QNetworkCookieJar*>(cookies));

		connect( &request, SIGNAL(requestSuccessful(QByteArray)), this, SLOT(ordersReturned(QByteArray)));
		connect( &request, SIGNAL(requestError(QString)), this, SLOT(ordersRejected(QString)) );

		request.makeRequest( QUrl(HUMBLEURL_LIBRARY) );
    } else {

    }

}
void HumbleUser::setCaptcha(QString challenge, QString response) {

    currentCaptcha = response;
}

void HumbleUser::setHumbleGuard(QString pin)
{

}

/**
 * @brief HumbleUser::login
 * @param email
 * @param password
 */
void HumbleUser::login( QString email, QString password, QString pin  )
{
	if ( email.length() < 4 || password.length() < 6 )
	{
		this->errorMessage = "Please enter correct email and/or password";
		emit appError( );
		return;
	}

	if ( !request.cookiesRetrieved )
	{
		getCsrfValue();
		this->errorMessage = "Have not received token yet.";
		emit appError( );
		return;
	}

	this->cookies->SaveToDisk();

	/* Make requests */
	connect( &request, SIGNAL(requestSuccessful(QByteArray)), this, SLOT(loginReturned(QByteArray)));
	connect( &request, SIGNAL(requestError(QString)), this, SLOT(loginError(QString)) );

	/* POST */
	request.appendPost("_le_csrf_token", getCsrfValue());
	request.appendPost("goto", "#");
    //request.appendPost("submit-data", "");
	request.appendPost("authy-token", pin);
    request.appendPost("script-wrapper", "true");
    request.appendPost("recaptcha_challenge_field", "");
    request.appendPost("recaptcha_response_field", currentCaptcha);

	request.appendPost("qs", "");
	request.appendPost("username", email );
	request.appendPost("password", password );

	request.makeRequest( QUrl(HUMBLEURL_PROCESSLOGIN) );
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
		QString filepath = QDir(path).filePath("humble-bundle-library.html");
		QFile file(filepath);
		if ( file.open(QIODevice::ReadOnly | QIODevice::Text) )
		{
			string = QString( file.readAll() );
			file.close();
		}
		else
		{
		}
		qDebug() << string;
	}
	else
	{
		string = QString( pageContent.data() );
	}

	return string;
}

QString HumbleUser::getUser()
{
	return currentUser;
}



/**
 * @brief HumbleUser::updateOrdersPage
 */
void HumbleUser::updateOrders()
{
	if ( loginSuccess )
	{
		connect( &request, SIGNAL(requestSuccessful(QByteArray)), this, SLOT(ordersReturned(QByteArray)));
		connect( &request, SIGNAL(requestError(QString)), this, SLOT(ordersError(QString)) );

		request.makeRequest( QUrl(HUMBLEURL_LIBRARY) );
	}
	else
	{
		this->errorMessage = "errorMessage";

		emit orderError();
	}
}

/**
 * @brief HumbleUser::ordersReturned
 * @param content
 */
void HumbleUser::ordersReturned( QByteArray content )
{
	disconnect( &request, SIGNAL(requestSuccessful(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(requestError(QString)), NULL, NULL );
	pageContent = content;
	loginSuccess = true;

	this->cookies->SaveToDisk();

	emit orderSuccess();
}

void HumbleUser::ordersError(QString errorMessage)
{
	disconnect( &request, SIGNAL(requestSuccessful(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(requestError(QString)), NULL, NULL );

	this->errorMessage = errorMessage;

	emit orderError();
}

/**
 * @brief Check if users is already logged in
 * @param errorMessage
 */
void HumbleUser::ordersRejected(QString errorMessage)
{
	disconnect( &request, SIGNAL(requestSuccessful(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(requestError(QString)), NULL, NULL );

	loginSuccess = false;
	request.getToken();

}

/**
 * @brief HumbleUser::loginRevieved
 * @param content
 */
void HumbleUser::loginReturned( QByteArray content )
{
	disconnect( &request, SIGNAL(requestSuccessful(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(requestError(QString)), NULL, NULL );

	qDebug() << "loginReturned:" << content;
	loginSuccess = true;
	emit appSuccess();
}

/**
 * @brief HumbleUser::requestError
 * @param errorMessage
 */
void HumbleUser::loginError( QString errorMessage )
{
    //HUMBLEURL_CAPTCHA


	disconnect( &request, SIGNAL(requestSuccessful(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(requestError(QString)), NULL, NULL );
	this->errorMessage = errorMessage;
    if (errorMessage == "Host requires authentication" )
    {
        emit captchaRequired();
    }
    else {
        emit appError();
    }
}

QString HumbleUser::getCsrfValue()
{
	QString value;
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
