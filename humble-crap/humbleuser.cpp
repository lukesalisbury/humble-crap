#include "humbleuser.hpp"

/**
 * @brief HumbleUser::getErrorMessage
 * @return
 */
QString HumbleUser::getErrorMessage()
{
	return errorMessage;
}

/**
 * @brief HumbleUser::login
 * @param email
 * @param password
 */
void HumbleUser::login( QString email, QString password )
{

	if ( email.length() < 4 || password.length() < 6 )
	{
		this->errorMessage = "Please enter correct email and/or password";
		emit appError( );
		return;
	}

	/* Make requests */
	connect( &request, SIGNAL(contentFinished(QByteArray)), this, SLOT(finishLogin(QByteArray)));
	connect( &request, SIGNAL(downloadError(QString)), this, SLOT(downloadError(QString)) );

	request.appendPost("goto", "/home");
	request.appendPost("qs", "");
	request.appendPost("username", email );
	request.appendPost("password", password );

	request.makeRequest( QUrl("https://www.humblebundle.com/login") );
}

/**
 * @brief HumbleUser::getOrdersPage
 * @return
 */
QString HumbleUser::getOrders()
{
	QString string = QString( pageContent.data() );

	return string;
}

/**
 * @brief HumbleUser::updateOrdersPage
 */
void HumbleUser::updateOrders()
{

}

/**
 * @brief HumbleUser::finishLogin
 * @param content
 */
void HumbleUser::finishLogin( QByteArray content )
{
	qDebug() << "finishLogin:";
	pageContent = content;
	emit appSuccess();
}

/**
 * @brief HumbleUser::downloadError
 * @param errorMessage
 */
void HumbleUser::downloadError( QString errorMessage )
{
	this->errorMessage = errorMessage;
	qDebug() << "downloadError:" << errorMessage;
	emit appError();
}
