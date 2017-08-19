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

#include <QDesktopServices>
#include "humble-crap.hpp"

#define SET_IF_NOT(s,k,v) if ( !s.contains(k) ) { s.setValue(k,v); }


/**
 * @brief HumbleCrap::HumbleCrap
 * @param parent
 */
HumbleCrap::HumbleCrap(QObject *parent) :	QObject(parent), settings("HumbleCrap", "HumbleCrap"), settingPrefix("user.")
{
    this->loginSuccess = false;
	this->crapHeader = "CrapIdent";

	SET_IF_NOT( settings, settingPrefix + "path.temp", QStandardPaths::writableLocation(QStandardPaths::TempLocation) )
	SET_IF_NOT( settings, settingPrefix + "path.cache", QStandardPaths::writableLocation(QStandardPaths::CacheLocation) )
	SET_IF_NOT( settings, settingPrefix + "path.content", getDefaultDataPath() )

}

/**

   @param url
   @return
 */
QString HumbleCrap::makeUrlLocal(QUrl url)
{
	return url.toLocalFile();
}

/**

   @return
 */
QString HumbleCrap::getDefaultDataPath()
{
	return QDir::cleanPath(QStandardPaths::writableLocation( QStandardPaths::DataLocation ) + QDir::separator() + "data");
}

/**
 * @brief HumbleCrap::getUsername
 * @return
 */
QString HumbleCrap::getUsername()
{
	return settings.value("username").toString();
}

/**
 * @brief HumbleDownload::setUsername
 * @param email
 */
void HumbleCrap::setUsername( QString email )
{
	if ( email.length() < 4 )
	{
		this->errorMessage = "Please enter correct email";
		emit appError( this->errorMessage );
	}

	/* Log User and Password */
	settings.setValue("username", email);
}

/**

   @param key
   @param value
 */
void HumbleCrap::setValue(QString key, QString value)
{
	settings.setValue(settingPrefix + key, value);
}

/**

   @param key
   @return
 */
QVariant HumbleCrap::getValue(QString key)
{
	return settings.value(settingPrefix + key, "");
}

/* File Handling */
/**
 * @brief HumbleDownload::readFile
 * @param file
 * @return
 */
QByteArray HumbleCrap::fileRead( QString file )
{
	QByteArray data;
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	QFile f(path + "/" + file);
	f.open( QIODevice::ReadOnly );
	data = f.readAll();
	f.close();

	return data;
}

/**
 * @brief HumbleDownload::saveFile
 * @param content
 * @param as
 */
void HumbleCrap::fileWrite(QByteArray content, QString as)
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	QFile f(path + "/" + as);
	f.open( QIODevice::WriteOnly|QIODevice::Truncate );
	f.write( content );
	f.close();
}

/**
 * @brief HumbleDownload::saveFile
 * @param content
 * @param as
 */
void HumbleCrap::fileWrite(QString content, QString as)
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	QFile f(path + "/" + as);
	f.open( QIODevice::WriteOnly|QIODevice::Truncate );
	f.write( content.toUtf8() );
	f.close();
}

/**
 * @brief HumbleDownload::downloadFile
 * @param id
 * @param url
 */
void HumbleCrap::downloadFile(QString id, QString url )
{

}

/**
 * @brief HumbleDownload::openFile
 * @param file
 */
void HumbleCrap::fileExecute( QUrl command, QUrl location )
{
	if ( command.isLocalFile() )
	{
		QProcess::startDetached( command.toLocalFile(), QStringList(), location.toLocalFile() );
	}
}

/**
 * @brief HumbleDownload::openFile
 * @param file
 */
void HumbleCrap::openFile( QString file )
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );
	QUrl file_path = QUrl(path + "/" + file );
	QDesktopServices::openUrl(file_path);
}

/**
 * @brief HumbleDownload::openFile
 * @param file
 */
void HumbleCrap::openUrl( QString url )
{
	QDesktopServices::openUrl( QUrl(url) );
}

