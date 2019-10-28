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

#include <QDataStream>
#include <QFileInfo>
#include <QDesktopServices>

#include "prosaic-download-queue.hpp"
#include "shared-functions.hpp"

QDataStream & operator>>(QDataStream & in, DownloadItem *&a) {

	a = new DownloadItem();
	in >> a->owner >> a->address >> a->filename >> a->userKey >> a->userCategory >> a->state >> a->downloadSize;

	a->setup();

	return in;
}
QDataStream & operator<<(QDataStream & out, DownloadItem * a)
{
	out << a->owner << a->address << a->filename << a->userKey << a->userCategory << a->state << a->downloadSize;
	return out;
}


/* Download Item */
DownloadItem::DownloadItem(QString owner, QUrl address, QString outputFilename)
{
	this->owner = owner;
	this->overwriting = owner == "cache";
	this->address = address;
	this->filename = outputFilename;
	this->setup();
}
void DownloadItem::setup() {

	this->id = static_cast<int>(qHash(this->owner + this->address.path()));

	if ( this->overwriting ) {
		this->file = new QFile(this->filename);
		this->file->resize(0);
	} else {
		this->temporaryFilename = this->filename + ".downloading";
		this->file = new QFile(this->temporaryFilename);
	}

}

/* Events */
void DownloadItem::requestWrite()
{
	//Write the current buffer to file
	this->file->write(this->networkReply->readAll());
}

void DownloadItem::requestCompleted()
{
	// Remove the read event
	QObject::disconnect(this->networkReply, &QNetworkReply::readyRead, nullptr,nullptr);

	//Close Temporary File, rename file to original filename
	this->file->close();
	if ( !this->overwriting ) {
		this->file->rename(this->filename);
	}

	this->pause(); //

	this->state = DIS_COMPLETED; // Completed
	if ( this->networkReply->error() == QNetworkReply::NoError) {
		if ( this->parentQueue ) {
			emit this->parentQueue->completed(this->id); // Alert Download Queue
		} else {
			qDebug() << "Download Item Complete but is missing parent queue" << this->filename;
		}
	}
}

void DownloadItem::requestProgress(qint64 bytesReceived, qint64 bytesTotal)
{
	this->state = DIS_ACTIVE; // Active
	this->downloadSize = this->existSize+bytesReceived;
	if ( this->parentQueue ) {
		emit this->parentQueue->progress(this->id, this->existSize+bytesReceived, this->existSize+bytesTotal);
	} else {
		qDebug() << "Download Item progressing but is missing parent queue" << this->filename;
	}
}

void DownloadItem::requestError(QNetworkReply::NetworkError code)
{
	if ( this->parentQueue ) {
		emit this->parentQueue->error(this->id, code);
	} else {
		qDebug() << "Download Item progressing but is missing parent queue" << code;
	}
}

/* Function */
/**

 */
QVariantMap DownloadItem::getItemDetail()
{
	QVariantMap q;
	q["id"] = this->id;
	q["filename"] = QDir::toNativeSeparators(this->filename);
	q["url"] = this->address.toDisplayString();
	q["downloadstate"] = this->state;
	q["downloaded"] = this->downloadSize;
	q["total"] = this->fileSize;
	q["owner"] = this->owner;
	q["userKey"] = this->userKey;
	q["userCategory"] = this->userCategory;



	return q;
}

QVariantMap DownloadItem::getFullDetail()
{
	QVariantMap q = this->getItemDetail();

	if ( this->returnContent )
	{
		q["file"] = this->address.fileName();
		QFile file(this->filename);
		if(file.open(QFile::ReadOnly | QFile::Text))
		{
			QTextStream in(&file);
			q["content"] = in.readAll();
			file.close();
		}
	}

	return q;
}

/**

 */
void DownloadItem::start(QNetworkReply * reply)
{
	if ( reply ) {
		this->networkReply = reply;
		connect(this->networkReply, SIGNAL(downloadProgress(qint64,qint64)),
				this , SLOT(requestProgress(qint64,qint64)));
		connect(this->networkReply, SIGNAL(error(QNetworkReply::NetworkError)),
				this, SLOT(requestError(QNetworkReply::NetworkError)));
		connect(this->networkReply, SIGNAL(finished()),
				this, SLOT(requestCompleted()));
		connect(this->networkReply, SIGNAL(readyRead()),
				this, SLOT(requestWrite()));
		this->eventsSet = true;
	} else if (this->networkReply) {

	}
}

/**

 */
void DownloadItem::pause()
{
	if ( this->networkReply ) {
		if ( this->eventsSet ) {
			disconnect(this->networkReply, SIGNAL(downloadProgress(qint64,qint64)), nullptr,nullptr );
			disconnect(this->networkReply, SIGNAL(error(QNetworkReply::NetworkError)), nullptr,nullptr );
			disconnect(this->networkReply, SIGNAL(finished()), nullptr,nullptr);
			disconnect(this->networkReply, &QNetworkReply::readyRead, nullptr,nullptr);
			this->eventsSet = false;
			this->state = DIS_INACTIVE;
		}
		this->networkReply->abort();
		//this->networkReply->deleteLater();
		//this->networkReply = nullptr;
	}
	if ( this->file ) {
		this->file->close();
	}

}
/**

 */
void DownloadItem::cancel()
{
	this->pause();
	if ( this->file ) {
		this->file->remove();
	}
}

/* Queue system for the downloads */
/**

 */
ProsaicDownloadQueue::ProsaicDownloadQueue()
{
	this->webmanager = getNetworkManager();

	// Load existing downloads
	QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));
	QString filename = dir.filePath("active_downloads");

	QFile file(filename);
	if (file.open(QIODevice::ReadOnly))
	{
		//Disabled for the moment
		/* Don't worry about reload existing downloads
		QDataStream restoringStream(&file);
		restoringStream >> this->queue;
		*/
	}
	file.close();

	//Loop through queue and restart download
	for (int i = 0; i < this->queue.size(); ++i) {
		DownloadItem * item = this->queue.at(i);
		if ( item->state == 1 ) {
			this->startDownloadItem(item);
		}
	}
}

/**

 */
ProsaicDownloadQueue::~ProsaicDownloadQueue()
{
	QMutableListIterator<DownloadItem*> i(this->queue);
	while (i.hasNext()) {
		DownloadItem* d = i.next();
		d->pause();
		if (d->owner == "cache" || d->owner == "system")
			i.remove();
	}

	// Save existing downloads
	QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));
	QString filename = dir.filePath("active_downloads");

	QSaveFile file(filename);
	if (file.open(QIODevice::WriteOnly))
	{
		QDataStream restoringStream(&file);
		restoringStream << this->queue;
	}
	file.commit();
}



/**
   Adds new download to the queue
   @param url
   @param as User to download as
 */
int ProsaicDownloadQueue::append(QString url, QString as, QString userKey, QString userCategory, bool returnData,  qint8 state)
{
	QUrl address = QUrl(url);
	QString directory = getPathFromSettings("cache");

	if ( directory.isEmpty() ) {
		qWarning() << __func__ << "Directory is missing";
	} else {
		QString filename = address.fileName();
		if ( !filename.length() ) {
			filename = "default";
		}
		QString downloadpath = directory + "/" + filename;
		if (as != "cache" ) {
			quint32 counter = 0;
			while ( doesFileExists(downloadpath) ) {
				downloadpath = directory + "/" + QString::number(++counter) + "-" + filename;
				if ( counter > 0xFFFF )
					break;
			}
		}
		DownloadItem * q = new DownloadItem( as, address, downloadpath );
		q->returnContent = returnData;
		q->userKey = userKey;
		q->userCategory = userCategory;
		this->queue.append(q);

		emit updated();
		if (state == DIS_ACTIVE ) {
			this->startDownloadItem(q);
		}
		return q->id;
	}
	return 0;
}

/**
   Open Directory in Explorer
   @param id
 */
void ProsaicDownloadQueue::openDirectory(int32_t id)
{
	foreach (DownloadItem * d, this->queue) {
		if ( d->id == id ) {
			QFileInfo filename(d->filename);
			QDesktopServices::openUrl(QUrl::fromLocalFile(filename.dir().absolutePath()));
		}
	}
}

/**
   @return list of download items
 */
QVariantList ProsaicDownloadQueue::getItemList()
{
	QVariantList list;

	QListIterator<DownloadItem*> i(this->queue);
	while (i.hasNext()) {
		DownloadItem* d = i.next();
		list.append(d->getItemDetail());
	}

	return list;
}

/**
   @param id
   @return
 */
QVariantMap ProsaicDownloadQueue::getItemDetail(int id)
{
	QVariantMap q;
	foreach (DownloadItem * d, this->queue) {
		if ( d->id == id) {
			q = d->getFullDetail();
		}
	}
	return q;
}

/**
   @param item
 */
void ProsaicDownloadQueue::startDownloadItem(DownloadItem * item) {

	if ( item->file ) {
		if ( item->networkReply == nullptr)
		{
			item->parentQueue = this;

			//Check if server supports ranges, also get the content length if possible
			QNetworkRequest headRequest(item->address);
			QNetworkReply * headReply =  this->webmanager->head( headRequest );
			connect(headReply, &QNetworkReply::finished,
				[=]() {
				QVariant results = headReply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
				if ( !results.isValid() )
				{
					emit error(item->id, QNetworkReply::HostNotFoundError);
					return;
				}
				if ( headReply->hasRawHeader("Accept-Ranges") )
				{
					item->resumable = headReply->rawHeader("Accept-Ranges") == "bytes";
				}
				if ( headReply->hasRawHeader("Content-Length") )
				{
					item->fileSize = headReply->rawHeader("Content-Length").toLongLong();
				}

				QNetworkRequest request(item->address);
				// Check if file is writeable
				if ( item->file->open(QIODevice::ReadWrite) )
				{
					if ( item->resumable ) {
						item->existSize = item->file->size();
						if ( item->existSize ) {
							QByteArray rangeHeaderValue = "bytes=" + QByteArray::number(item->existSize) + "-";

							request.setRawHeader("Range", rangeHeaderValue);

							//Reopen file in append mode
							item->file->close();
							item->file->open(QIODevice::ReadWrite|QIODevice::Append);
						}
					}
					// Start Downloading
					QNetworkReply * reply = this->webmanager->get(request);
					item->start( reply );
				}
			}
			);
		} else {
			qDebug() << "Network Reply is not nullptr";
		}
	}
}

/**
   @param item
 */
void ProsaicDownloadQueue::pauseDownloadItem(DownloadItem* item) {
	item->pause();
}

/**
   @param item
 */
void ProsaicDownloadQueue::cancelDownloadItem(DownloadItem* item) {
	item->cancel();
}

/**

   @param item
 */
bool ProsaicDownloadQueue::changeDownloadItemState(int32_t id, qint8 state)
{
	foreach (DownloadItem * d, this->queue) {
		if ( d->id == id) {
			if (state == DIS_ACTIVE && d->state == DIS_INACTIVE) {
				this->startDownloadItem(d);
			} else {
				this->pauseDownloadItem(d);
			}
			break;
		}
	}
	emit updated();
	return false;
}

/**

   @param item
 */
void ProsaicDownloadQueue::ableUserDownloadItem(QString user, qint8 state)
{
	Q_UNUSED(user)
	Q_UNUSED(state)
}

