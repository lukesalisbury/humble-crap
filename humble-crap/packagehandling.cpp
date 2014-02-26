#include "packagehandling.hpp"
#include <QDebug>
#include <QtWidgets/QFileDialog>
#include <QStandardPaths>
#include <QtGui>

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
