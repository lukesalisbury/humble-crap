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

#include "package-handling.hpp"
#include "shared-functions.hpp"
#include <QtConcurrent/QtConcurrent>
#include <QMimeDatabase>

PackageHandling::PackageHandling(QObject *parent) :
	QObject(parent)
{
}

void PackageHandling::install(QString filename, QString ident, QString category) {

	QtConcurrent::run([=]() {
		QMimeDatabase db;

		QString contentPath = getPathFromSettings("content");

		QFile file(filename);
		if ( !file.exists() ) {
			emit this->failed( ident, "File does not exist");
		}

		QFileInfo info(file);

		QMimeType type = db.mimeTypeForFile(filename);
		qDebug() << "Mime type:" << type.name();

		// Ebooks
		if ( category == "ebook" || this->ebookTypes.contains(type.name(), Qt::CaseInsensitive) ) {
			contentPath.append("ebook");
			contentPath.append(QDir::separator());
			QDir dir(contentPath);
			dir.mkdir(contentPath);
			if ( this->compressedTypes.contains(type.name(), Qt::CaseInsensitive) ) {
				emit this->failed( ident, "Compressed Ebooks not supported yet.");
			} else {
				QString path = QString("%1%2%3")
						.arg(contentPath).arg(QDir::separator()).arg(info.fileName());
				qDebug() << path;
				if ( file.rename( path ) ) {
					info.setFile(path);
					emit this->completed(ident, path, info.absolutePath());
				} else {
					emit this->failed( ident, "File could not be moved to new location.");
				}
			}

		} else if ( category == "audio") {
			contentPath.append("audio");
			contentPath.append(QDir::separator());
			emit this->failed( ident, "Audio not supported yet.");
		} else {
			contentPath.append("games");
			contentPath.append(QDir::separator());
			emit this->failed( ident, "Not supported yet.");
		}
	});

}

