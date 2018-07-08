/****************************************************************************
* Copyright © 2018 Luke Salisbury
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


PackageHandling::PackageHandling(QObject *parent) :
	QObject(parent)
{
}


void PackageHandling::setFile(const QString &a)
{

	if (a != filename) {
		filename = a;
		selectSource();
		emit fileChanged();
	}
}


QString PackageHandling::file() const
{
	return filename;
}

bool PackageHandling::selectSource()
{

//	QString fileName = QFileDialog::getOpenFileName(NULL, tr("Open Downloaded Package"), QStandardPaths::writableLocation( QStandardPaths::DownloadLocation ), tr("Package Files (*.zip *.tar.gz *.tar.bz2)"));
//	qDebug() << fileName;

	return true;
}

bool PackageHandling::selectDestination()
{

return true;
}
