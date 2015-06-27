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

#include "humbleuser.hpp"

/**
 * @brief HumbleUser::getErrorMessage
 * @return
 */
HumbleUser::HumbleUser(QObject *parent)
{
	request.getToken();
}

QString HumbleUser::getErrorMessage()
{
	return errorMessage;
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
		this->errorMessage = "Have not received token yet.";
		emit appError( );
		return;
	}


	/* Make requests */
	connect( &request, SIGNAL(contentFinished(QByteArray)), this, SLOT(loginReturned(QByteArray)));
	connect( &request, SIGNAL(downloadError(QString)), this, SLOT(loginError(QString)) );

	//
	request.appendPost("_le_csrf_token", getCsrfValue());
	request.appendPost("goto", "#");
	request.appendPost("submit-data	", "");
	request.appendPost("authy-token", pin);
	request.appendPost("script-wrapper", "login_callback");

	request.appendPost("qs", "");
	request.appendPost("username", email );
	request.appendPost("password", password );

	request.makeRequest( QUrl("https://www.humblebundle.com/processlogin") );
}

/**
 * @brief HumbleUser::getOrders
 * @return
 */
QString HumbleUser::getOrders(  )
{
	QString string;

//	Testing
//	QFile file("test.htm");
//	if ( file.open(QIODevice::ReadOnly | QIODevice::Text) )
//	{
//		string = QString( file.readAll() );
//		file.close();
//	}

	string = QString( pageContent.data() );


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
		connect( &request, SIGNAL(contentFinished(QByteArray)), this, SLOT(ordersReturned(QByteArray)));
		connect( &request, SIGNAL(downloadError(QString)), this, SLOT(ordersError(QString)) );

		request.makeRequest( QUrl("https://www.humblebundle.com/home/library") );
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
	qDebug() << "ordersReturned:";
	disconnect( &request, SIGNAL(contentFinished(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(downloadError(QString)), NULL, NULL );
	pageContent = content;
	emit orderSuccess();
}

void HumbleUser::ordersError(QString errorMessage)
{
	disconnect( &request, SIGNAL(contentFinished(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(downloadError(QString)), NULL, NULL );

	this->errorMessage = errorMessage;

	emit orderError();
}

/**
 * @brief HumbleUser::loginRevieved
 * @param content
 */
void HumbleUser::loginReturned( QByteArray content )
{
	disconnect( &request, SIGNAL(contentFinished(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(downloadError(QString)), NULL, NULL );

	qDebug() << "loginReturned:" << content;
	loginSuccess = true;
	emit appSuccess();
}

/**
 * @brief HumbleUser::downloadError
 * @param errorMessage
 */
void HumbleUser::loginError( QString errorMessage )
{
	disconnect( &request, SIGNAL(contentFinished(QByteArray)), NULL, NULL);
	disconnect( &request, SIGNAL(downloadError(QString)), NULL, NULL );
	this->errorMessage = errorMessage;

	emit appError();
}

QString HumbleUser::getCsrfValue()
{
	QString value;
	QNetworkCookieJar * cookies = request.getCookies();
	QList<QNetworkCookie> list = cookies->cookiesForUrl( QUrl("https://www.humblebundle.com/") );

	for (int i = 0; i < list.size(); ++i)
	{
		if ( list.at(i).name() == "csrf_cookie" )
		{
			value = list.at(i).value();
		}
	}
	return value;
}
