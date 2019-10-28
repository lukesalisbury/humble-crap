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
#include <zlib.h>

#include "humble-network.hpp"
#include "global.hpp"

QNetworkAccessManager * getNetworkManager();

QByteArray gUncompress(const QByteArray &data)
{
	if (data.size() <= 4)
	{
		qWarning("gUncompress: Input data is truncated");
		return QByteArray();
	}

	QByteArray result;

	int ret;
	z_stream strm;
	static const int CHUNK_SIZE = 1024;
	char out[CHUNK_SIZE];

	// allocate inflate state
	strm.zalloc = nullptr;
	strm.zfree = nullptr;
	strm.opaque = nullptr;
	strm.avail_in = static_cast<uInt>(data.size());
	strm.next_in = (Bytef*)(data.data());

	ret = inflateInit2(&strm, 15 + 32); // gzip decoding
	if (ret != Z_OK)
		return QByteArray();


	// run inflate()
	do {
		strm.avail_out = CHUNK_SIZE;
		strm.next_out = (Bytef*)(out);

		ret = inflate(&strm, Z_NO_FLUSH);
		Q_ASSERT(ret != Z_STREAM_ERROR); // state not clobbered

		switch (ret) {
			case Z_NEED_DICT:
				ret = Z_DATA_ERROR; // and fall through
				[[clang::fallthrough]];
			case Z_DATA_ERROR:
			case Z_MEM_ERROR:
				(void)inflateEnd(&strm);
				return QByteArray();
		}

		result.append(out, CHUNK_SIZE - strm.avail_out);
	} while (strm.avail_out == 0);

	// clean up and return
	inflateEnd(&strm);
	return result;
}

/**
 * @brief HumbleNetworkRequest::HumbleNetworkRequest
 */
HumbleNetworkRequest::HumbleNetworkRequest(): sslMissing(0)
{
	/* Setup webManager */
	this->webManager = getNetworkManager();

	connect( this->webManager, SIGNAL( sslErrors(QNetworkReply*, const QList<QSslError>) ), SLOT( sslError(QNetworkReply*, const QList<QSslError> )));
	connect( this->webManager, SIGNAL( finished(QNetworkReply*) ), this, SLOT( finishRequest(QNetworkReply*)) );

	if ( !QSslSocket::supportsSsl() )
	{
		this->errorMessage = "OpenSSL not installed";
		qDebug() << this->errorMessage;
		this->sslMissing = true;
		emit requestError( this->errorMessage, nullptr, 0 );
	}

}

/**
 * @brief HumbleNetworkRequest::appendPost
 * @param key
 * @param value
 */
void HumbleNetworkRequest::appendPost(QString key, QString value)
{
	if ( this->postData.length() > 0 )
	{
		this->postData.append("&");
	}

	this->postData.append(key);
	this->postData.append("=");
	this->postData.append(value);

}

/**
 * @brief HumbleNetworkRequest::retrieveContent
 * @return
 */
QByteArray HumbleNetworkRequest::retrieveContent()
{
	qDebug() << "retrieveContent";
	return this->downloadData;
}

/**
 * @brief HumbleNetworkRequest::writeContent
 * @param outputFile
 * @return
 */
bool HumbleNetworkRequest::writeContent(QString outputFile)
{
	qDebug() << "writeContent";
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );
	QFile f(path + "/" + outputFile);

	f.open( QIODevice::WriteOnly|QIODevice::Truncate );
	f.write( this->downloadData );
	f.close();

	return true;
}

/**
 * @brief HumbleNetworkRequest::makeRequest
 * @return
 */
bool HumbleNetworkRequest::makeRequest(QUrl url, QString requester)
{
	if ( QSslSocket::supportsSsl() )
	{
		QNetworkRequest request;

		//request.setRawHeader("User-Agent", "Humble-bundle Content Retrieving APplication - http://github.org/lukesalisbury/humble-crap");
		request.setRawHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
		request.setRawHeader("Accept-Encoding", "gzip,deflate" );
		request.setRawHeader("Accept-Language", "en-US,en;q=0.5" );
		//request.setRawHeader("Connection", "keep-alive" );
		request.setRawHeader("Accept", "application/json, text/javascript, */*; q=0.01" );
		request.setRawHeader("DNT", "1" );
		if ( !requester.isEmpty() )
			request.setRawHeader("X-Requested-By", requester.toUtf8() );

		request.setRawHeader("origin", HUMBLEURL_COOKIE);
		request.setRawHeader("referer", HUMBLEURL_COOKIE);

		if ( !this->csrfPreventionToken.isEmpty() ) {
			request.setRawHeader("CSRF-Prevention-Token", this->csrfPreventionToken.toUtf8() );
			this->csrfPreventionToken = ""; // Unset token, incase we reuse this object
		}

		request.setUrl( url );

		//qDebug() << "Url" << url << " - " << this->postData.toPercentEncoding("=&");


		if ( this->postData.length() > 0 )
		{
			this->reply = this->webManager->post( request, this->postData.toPercentEncoding("=&") );
			this->postData.clear();
		}
		else
		{
			this->reply = this->webManager->get( request );
		}

		connect( this->reply, SIGNAL( downloadProgress( qint64, qint64 )), this, SLOT(downloadProgress( qint64, qint64 )) );
		return true;
	} else {

	}
	return false;
}

QNetworkCookieJar *HumbleNetworkRequest::getCookies()
{
	return this->webManager->cookieJar();
}

bool HumbleNetworkRequest::setCookies(QNetworkCookieJar * cookies_jar)
{
	this->webManager->setCookieJar(cookies_jar);
	return false;
}

/**
 * @brief HumbleNetworkRequest::printCookies
 * @param content
 */
void HumbleNetworkRequest::printCookies()
{
	QNetworkCookieJar * cookies = this->webManager->cookieJar();
	QList<QNetworkCookie> list = cookies->cookiesForUrl( QUrl(HUMBLEURL_COOKIE) );
	for (int i = 0; i < list.size(); ++i)
	{
		qDebug() << list.at(i).name() << "-" << list.at(i).value();
	}

}

/**
 * @brief HumbleNetworkRequest::sslError
 * @param pReply
 * @param errors
 */
void HumbleNetworkRequest::sslError(QNetworkReply* pReply, const QList<QSslError> & errors )
{
	this->errorMessage = "SSL Error";
	qDebug() << "Network Error:" << pReply->errorString();
	for (int i = 0; i < errors.size(); ++i) {
		qDebug() << "SSL Error:" << errors.at(i).errorString();
	}
	emit requestError( this->errorMessage, nullptr, 0 );
}

/**
 * @brief HumbleNetworkRequest::downloadProgress
 * @param bytesReceived
 * @param bytesTotal
 */
void HumbleNetworkRequest::downloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
	emit requestProgress(bytesReceived, bytesTotal);
}

/**
 * @brief HumbleNetworkRequest::finishRequest
 * @param pReply
 */
void HumbleNetworkRequest::finishRequest( QNetworkReply* pReply )
{
	//QVariant variantCookies = this->reply->header(QNetworkRequest::SetCookieHeader);
	if ( pReply == this->reply )
	{
		QVariant redirectionTarget = pReply->attribute(QNetworkRequest::RedirectionTargetAttribute);
		QUrl url = redirectionTarget.toUrl();
		qint16 code = static_cast<qint16>(pReply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt());

		QByteArray data = pReply->readAll();
		if ( pReply->rawHeader("Content-Encoding") == "gzip") {
			this->downloadData = gUncompress(data);
		} else {
			this->downloadData = data;
		}
		pReply->deleteLater();

		if ( pReply->error() )
		{
			//qDebug() << tr("Download failed: %1. %2").arg(pReply->errorString(), pReply->url().toString());
			//QList<QByteArray> headerList = pReply->rawHeaderList();
			//foreach(QByteArray head, headerList) {
			//	qDebug() << head << ":" << pReply->rawHeader(head);
			//}
			this->errorMessage = pReply->errorString();
			emit requestError( this->errorMessage, this->downloadData, code );
		}
		else if ( url.path() == "/login")
		{
			//qDebug() << tr("Login failed") << url.query();
			this->errorMessage = "Login failed";
			emit requestError( this->errorMessage, this->downloadData, code );
		}
		else if ( url.isEmpty() )
		{
			qDebug() << tr("Download Successful: %1").arg(pReply->url().toString());
			//QList<QByteArray> headerList = pReply->rawHeaderList();
			//foreach(QByteArray head, headerList) {
			//    qDebug() << head << ":" << pReply->rawHeader(head);
			//}
			emit requestSuccessful( this->downloadData );
		}
		else
		{
			qDebug() << tr("New URL requested") << pReply->url().toString();
			this->makeRequest( url );
		}

	}

}
