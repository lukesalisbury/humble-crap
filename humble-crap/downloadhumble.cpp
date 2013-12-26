#include "downloadhumble.hpp"
#include <QXmlStreamReader>
#include <QDebug>
#include <QString>
#include <fstream>
#include <QDesktopServices>
#include <QUrl>
#include <QtWidgets/QMessageBox>
#include <QSettings>


DownloadHumble::DownloadHumble(QObject *parent) :	QObject(parent), settings("HumbleCrap", "HumbleCrap")
{
    this->loginSuccess = false;
	this->crapHeader = "CrapIdent";
    connect(&webManager, SIGNAL(sslErrors(QNetworkReply*, QList<QSslError>)), SLOT(sslError(QNetworkReply*, QList<QSslError>)));

}


QString DownloadHumble::getErrorMessage()
{
    return errorMessage;
}

QString DownloadHumble::getUsername()
{
	return settings.value("username").toString();
}

QString DownloadHumble::getPassword()
{
	return settings.value("password").toString();
}

bool DownloadHumble::getSavePassword()
{
    return !!settings.value("password").toString().length();
}



void DownloadHumble::login(QString email, QString password, bool savePassword)
{
    QNetworkRequest request;

    /* Log User and Password */
    currentPassword = password;
    currentUser = email;

    settings.setValue("username", email);
    if ( savePassword )
        settings.setValue("password", password);
    else
        settings.setValue("password", "");


    /* Make requests */
    connect(&webManager, SIGNAL(finished(QNetworkReply*)), SLOT(finishLogin(QNetworkReply*)));

    if ( QSslSocket::supportsSsl() )
    {
        QByteArray postData;
        request.setUrl(QUrl("https://www.humblebundle.com/login?goto=/home&qs="));
        request.setRawHeader("User-Agent", "Humble-bundle Content Retrieving APplication");
        request.setRawHeader("Content-Type", "application/x-www-form-urlencoded");
        request.setRawHeader("Accept-Encoding", "gzip,deflate,qcompress" );

        postData.append("goto").append("=").append("/home").append("&");
        postData.append("qs").append("=").append("").append("&");
        postData.append("username").append("=").append(currentUser).append("&");
        postData.append("password").append("=").append(currentPassword);


        qDebug() << "Downloading www.humblebundle.com/home";
        qDebug() << "URL: " << request.url();

        webManager.post(request, postData.toPercentEncoding("=&") );
    }
    else
    {
        qDebug() << "OpenSSL not installed";
        this->errorMessage = "OpenSSL not installed";
        emit appError();
    }

}

/* File Handling */
void DownloadHumble::saveFile(QByteArray content, QString as)
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	qDebug() << as << "QByteArray" ;

	QFile f(path + "/" + as);
	f.open( QIODevice::WriteOnly|QIODevice::Truncate );
	f.write( content );

	f.close();


}

void DownloadHumble::saveFile(QString content, QString as)
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	qDebug() << as << "QString";

	QFile f(path + "/" + as);
	f.open( QIODevice::WriteOnly|QIODevice::Truncate );

	f.write( content.toUtf8() );
	f.close();


}

void DownloadHumble::getFile(QString id, QString url )
{
    QNetworkRequest request;
	QNetworkReply * reply;
	connect(&webManager, SIGNAL(finished(QNetworkReply*)), SLOT(finishDownload(QNetworkReply*)));

    if ( QSslSocket::supportsSsl() )
    {
		//request.setUrl(QUrl(url));
		request.setUrl(QUrl("http://mokoi.info/images/index/os_windows.png"));
		request.setRawHeader("User-Agent", "Humble-bundle Content Retrieving APplication");

        qDebug() << "Downloading ";
        qDebug() << "URL: " << request.url();


		reply = webManager.get(request);

		reply->setProperty("crap", id );

		currentDownloads.append(reply);

    }
    else
    {
        qDebug() << "OpenSSL not installed";
        this->errorMessage = "OpenSSL not installed";
        emit appError();
    }
}

void DownloadHumble::openFile( QString file )
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );
	QUrl file_path = QUrl(path + "/" + file );
	QDesktopServices::openUrl(file_path);
}



QString DownloadHumble::getContent()
{
    QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );



    qDebug() << path;

    QFile f(path + "/humble.html");
    f.open(QIODevice::ReadOnly );

    QTextStream in(&f);
    QString string = in.readAll();


    f.close();

    return string;
    /*
    QString string = QString( pageContent.data() );

    qDebug() << "downloadData.data()" << pageContent.data();

    return string;
    */
}


void DownloadHumble::updateContent()
{
    QNetworkRequest request;

    connect(&webManager, SIGNAL(finished(QNetworkReply*)), SLOT(finishContent(QNetworkReply*)));

    if ( QSslSocket::supportsSsl() )
    {
        QByteArray postData;
        request.setUrl(QUrl("https://www.humblebundle.com/home"));
        request.setRawHeader("User-Agent", "Humble-bundle Content Retrieving APplication");
        request.setRawHeader("Content-Type", "application/x-www-form-urlencoded");
        request.setRawHeader("Accept-Encoding", "gzip,deflate,qcompress" );


        qDebug() << "Downloading www.humblebundle.com/home";
        qDebug() << "URL: " << request.url();

        webManager.get( request );
    }
    else
    {
        qDebug() << "OpenSSL not installed";
        this->errorMessage = "OpenSSL not installed";
        emit appError();
    }
}

void DownloadHumble::sslError(QNetworkReply* pReply, const QList<QSslError> & errors )
{
    this->errorMessage = "SSL Error";
    emit appError();
}

void DownloadHumble::finishDownload(QNetworkReply* pReply)
{
	currentDownloads.removeAll(pReply);
	disconnect(&webManager, SIGNAL(finished(QNetworkReply*)), 0, 0);

	pReply->deleteLater();

	if ( pReply->error() )
	{
		qDebug() << tr("Download failed: %1.").arg(pReply->errorString());
		errorMessage = pReply->errorString();
		emit appError();
		return;
	}




	// Save Content
	QVariant id = pReply->property( "crap" );
	QString path = pReply->url().path();
	QString basename = QFileInfo(path).fileName();

	if (basename.isEmpty())
		basename = "download";

	this->saveFile(pReply->readAll(), basename);

	qDebug() << "Saved to" << basename << id.toString();
	emit downloaded( id.toString(), basename);




}


void DownloadHumble::finishLogin( QNetworkReply* pReply )
{
    QVariant redirectionTarget = pReply->attribute(QNetworkRequest::RedirectionTargetAttribute);
    QUrl url = QUrl(redirectionTarget.toString());

    qDebug() << url;

    disconnect(&webManager, SIGNAL(finished(QNetworkReply*)), 0, 0);

    pReply->deleteLater();

    if ( pReply->error() )
    {
        qDebug() << tr("Download failed: %1.").arg(pReply->errorString());
        this->errorMessage = pReply->errorString();
        emit appError();
        return;
    }
    else if ( url.path() == "/login" )
    {
        qDebug() << tr("Login failed") << url.query();
        this->errorMessage = "Login failed";
        emit appError();
        return;
    }
    else if ( url.path() == "/home" )
    {
        emit appSuccess();
    }




    pageContent = pReply->readAll();
    emit appSuccess();


}


void DownloadHumble::finishContent( QNetworkReply* pReply )
{
    QVariant redirectionTarget = pReply->attribute(QNetworkRequest::RedirectionTargetAttribute);
    QUrl url = QUrl(redirectionTarget.toString());

    qDebug() << url;

    disconnect(&webManager, SIGNAL(finished(QNetworkReply*)), 0, 0);

    pReply->deleteLater();

    if ( pReply->error() )
    {
        qDebug() << tr("Download failed: %1.").arg(pReply->errorString());
        this->errorMessage = pReply->errorString();
        emit appError();

    }
    else if ( url.path() == "/login" )
    {
        qDebug() << tr("Login failed") << url.query();
        this->errorMessage = "Login failed";
        emit appError();

    }
    else if ( url.path() == "/home" )
    {
        pageContent = pReply->readAll();
        emit appSuccess();
    }



}

