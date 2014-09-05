#include "humbledownload.hpp"

HumbleDownload::HumbleDownload(QObject *parent) :
	QObject(parent)
{
	this->progress = 0.0;
}

bool HumbleDownload::makeRequest()
{

	if ( !this->url.isEmpty() )
	{
		connect( &this->request, SIGNAL( contentFinished(QByteArray) ), this, SLOT( downloadFinished(QByteArray) ));
		connect( &this->request, SIGNAL( downloadError(QString) ), this, SLOT( downloadError(QString)) );
		connect( &this->request, SIGNAL( progressUpdate(qint64,qint64) ), this, SLOT( progressChange(qint64,qint64) ) );

		if ( this->request.makeRequest( QUrl(this->url) ) )
		{
			emit downloadStarted();
			return true;
		}
	}
	return false;
}

bool HumbleDownload::writeContent( QString localFile )
{
	QByteArray data;
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	QFile f(path + "/" + localFile );
	f.open( QIODevice::ReadOnly );
	data = f.readAll();

	f.close();

	return true;
}


double HumbleDownload::getProgressPercent()
{
	return this->progress;
}

QByteArray HumbleDownload::getContent()
{
	return this->content;
}

QString HumbleDownload::getError()
{
	return this->errorMessage;
}

void HumbleDownload::setUrl(const QString &a)
{
	this->url = a;
	emit urlChanged();
}

QString HumbleDownload::getUrl() const
{
	return this->url;
}

void HumbleDownload::progressChange(qint64 bytesReceived, qint64 bytesTotal)
{
	this->progress = (double)bytesReceived / (double)bytesTotal;
	emit progressUpdate();
}

void HumbleDownload::downloadError(QString errorMessage)
{
	this->errorMessage = errorMessage;
	emit appError();
}

void HumbleDownload::downloadFinished(QByteArray content)
{
	qDebug() << "downloadFinished";
	this->content = content;
	emit appSuccess();
}
