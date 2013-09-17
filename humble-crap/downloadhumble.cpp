#include "downloadhumble.hpp"
#include <QXmlStreamReader>
#include <QDebug>
#include <QString>
#include <fstream>
#include <QDesktopServices>
#include <QUrl>
#include <QtWidgets/QMessageBox>

DownloadHumble::DownloadHumble(QObject *parent) :	QObject(parent)
{

connect(&m_WebCtrl, SIGNAL(finished(QNetworkReply*)), SLOT(fileDownloaded(QNetworkReply*)));
	connect(&m_WebCtrl, SIGNAL(sslErrors(QNetworkReply*, QList<QSslError>)), SLOT(sslError(QNetworkReply*, QList<QSslError>)));
	downloading = false;
}

QString DownloadHumble::getDownloadText()
{
	QString string = QString( m_DownloadedData.data() );

	qDebug() << "m_DownloadedData.data()" << m_DownloadedData.data();

	return string;
}

void DownloadHumble::saveFile(QString content, QString as)
{
	std::string file = "../" + as.toStdString();
	std::ofstream s;
	s.open( file.c_str() );
	s << content.toStdString() << std::endl;
	s.close();

}


void DownloadHumble::go(QString email, QString password)
{
	if ( downloading )
		return;
	QNetworkRequest request;
/*
 *
	var login = false;
	var xhr = new XMLHttpRequest()
	var xhr2 = new XMLHttpRequest()
	var postData = "account-login-username=lukex@operamail.com&account-login-password=&goto=/home&qs=";
	xhr.onreadystatechange = function () {
		if (xhr.readyState == XMLHttpRequest.DONE) {
			//xhr.setRequestHeader("Cookie",
			//xhr2.send(null)

			console.log("cookie", xhr.getResponseHeader("Set-Cookie"), "Set-Cookie2", xhr.getResponseHeader("Set-Cookie2") )
			console.log("file request", xhr.statusText, xhr.status )
		}
	}
	xhr2.onreadystatechange = function () {
		console.log("readyState", xhr2.readyState )
		if (xhr2.readyState == XMLHttpRequest.DONE) {
			console.log("file request", xhr.status, xhr.responseText )
				xmlModel.setXML(xhr.responseText)

		}
	}

	xhr2.open('GET', "https://www.humblebundle.com/home", true)


	xhr.open('POST', "https://www.humblebundle.com/login?goto=/home&qs=", true)
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	xhr.send(postData)
			*/

	if ( QSslSocket::supportsSsl() )
	{
		//goto=%2Fhome&qs=&username=lukex%40email&password=
		//wget -S --post-data='goto=/home&qs=&account-login-username=lukex@e&account-login-password=' https://www.humblebundle.com/login?goto=/home&qs=mail
		QByteArray postData;
		request.setUrl(QUrl("https://www.humblebundle.com/login?goto=/home&qs="));
		request.setRawHeader("User-Agent", "Humble-bundle Content Retrieving APplication");
		request.setRawHeader("Content-Type", "application/x-www-form-urlencoded");
		request.setRawHeader("Accept-Encoding", "gzip,deflate,qcompress" );

		email = "lukex@email";
		password = "hbpassword";

		postData.append("goto").append("=").append("/home").append("&");
		postData.append("qs").append("=").append("").append("&");
		postData.append("account-login-username").append("=").append(email).append("&");
		postData.append("account-login-password").append("=").append(email);


		qDebug() << "Downloading www.humblebundle.com/home";
		qDebug() << "URL: " << request.url();
		qDebug() << "Email: " << postData.toPercentEncoding("=&/");
		qDebug() << "password: " << postData;

		downloading = true;

		m_WebCtrl.post(request, postData.toPercentEncoding("=&") );
	}
	else
	{
		qDebug() << "OpenSSL not installed";
	}
}

void DownloadHumble::get(QString url, QString saveAs)
{
	if ( downloading )
		return;
	QNetworkRequest request;

	if ( QSslSocket::supportsSsl() )
	{
		request.setUrl(QUrl(url));
		request.setRawHeader("User-Agent", "Humble-bundle Content Retrieving APplication");


		qDebug() << "Downloading ";
		qDebug() << "URL: " << request.url();
		qDebug() << "As: " << saveAs;

		downloading = true;

		m_WebCtrl.get(request);

	}
	else
	{
		qDebug() << "OpenSSL not installed";
	}
}



void DownloadHumble::sslError(QNetworkReply* pReply, const QList<QSslError> & errors )
{
	emit downloadError();
}

void DownloadHumble::fileDownloaded(QNetworkReply* pReply)
{
	downloading = false;
	QVariant redirectionTarget = pReply->attribute(QNetworkRequest::RedirectionTargetAttribute);
	if ( pReply->error() )
	{
		qDebug() << tr("Download failed: %1.").arg(pReply->errorString());
		return;
	}
	else if (!redirectionTarget.isNull())
	{

		qDebug() << "redirectionTarget" << redirectionTarget.toString();
		pReply->deleteLater();
		//this->get("https://www.humblebundle.com/home", "");
		return;
	}


	pReply->deleteLater();
	m_DownloadedData = pReply->readAll();
	emit downloaded();


}

void DownloadHumble::downloadTorrent(QString urlString)
{
	if ( QSslSocket::supportsSsl() )
	{
		QNetworkRequest request;
		QUrl url = QUrl(urlString);

		request.setUrl(url);
		request.setRawHeader("User-Agent", "Humble-bundle Content Retrieving APplication");

		qDebug() << "Downloading torrent ";
		qDebug() << "URL: " << request.url();

		m_WebCtrl.get(request);
	}
	else
	{
		qDebug() << "OpenSSL not installed";
	}
}

