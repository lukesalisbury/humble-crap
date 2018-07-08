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

#include <QDesktopServices>
#include "humble-crap.hpp"

#define SET_IF_NOT(s,k,v) if ( !s.contains(k) ) { s.setValue(k,v); }

/*
 * Data Paths-
 * Window: C:\Users\[user]\AppData\Local\humble-crap
 *
 */

/**
 * @brief HumbleCrap::HumbleCrap
 * @param parent
 */
HumbleCrap::HumbleCrap(QObject *parent) :	QObject(parent), settings(QSettings::IniFormat, QSettings::UserScope, "HumbleCrap", "HumbleCrap"), settingPrefix("user.")
{
	this->crapHeader = "CrapIdent";

	/* Write Default parh if settings aren't found */
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
 * @brief Allow QML scripts to read the data path
 * @return
 */
QString HumbleCrap::getDefaultDataPath()
{
	return QDir::cleanPath(QStandardPaths::writableLocation( QStandardPaths::DataLocation ) + QDir::separator() + "data");
}

/* Settings */
/**
 * @brief HumbleCrap::getUsername
 * @return last active username
 */
QString HumbleCrap::getUsername()
{
	return settings.value("username").toString();
}

/**
 * @brief Set the active username
 * @param email
 */
void HumbleCrap::setUsername( QString email )
{
	if ( email.length() < 4 )
	{
		// Email should be atleast a@a.a
		this->errorMessage = "Please enter correct email";
		emit appError( this->errorMessage );
	}

	settings.setValue("username", email);
}

/**
 * @brief Update setting, adding the default prefix to key
 * @param key
 * @param value
 */
void HumbleCrap::setValue(QString key, QString value)
{
	settings.setValue(settingPrefix + key, value);
}

/**
 * @brief Retrieves setting, adding the default prefix to key
 * @param key
 * @return value of key
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
QByteArray HumbleCrap::readFile( QString file )
{
	QByteArray data;
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	QFile f(path + "/" + file);
	if ( f.open( QIODevice::ReadOnly ) ) {
		data = f.readAll();
	}
	f.close();
	return data;
}

/**
 * @brief HumbleCrap::writeFile
 * @param content
 * @param as
 */
bool HumbleCrap::writeFile(QByteArray content, QString as)
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	QFile f(path + "/" + as);
	if ( f.open( QIODevice::WriteOnly|QIODevice::Truncate ) ) {
		f.write( content );
		f.close();
		return true; // TODO check
	}
	return false;
}

/**
 * @brief HumbleCrap::writeFile
 * @param content
 * @param as
 */
bool HumbleCrap::writeFile(QString content, QString as)
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	QFile f(path + "/" + as);
	if ( f.open( QIODevice::WriteOnly|QIODevice::Truncate ) ) {
		f.write( content.toUtf8() );
		f.close();
		return true; // TODO check
	}
	return false;
}

/**
 * @brief HumbleCrap::executeFile
 * @param file
 */
bool HumbleCrap::executeFile( QUrl command, QUrl location )
{
	if ( command.isLocalFile() )
	{
		return QProcess::startDetached( command.toLocalFile(), QStringList(), location.toLocalFile() );
	}
	return false;
}

/**
 * @brief HumbleCrap::openFile
 * @param file
 */
bool HumbleCrap::openFile( QString file )
{
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );
	QUrl file_path = QUrl(path + "/" + file );
	return QDesktopServices::openUrl(file_path);
}

/**
 * @brief HumbleCrap::openUrl
 * @param url
 */
bool HumbleCrap::openUrl( QString url )
{
	return QDesktopServices::openUrl( QUrl(url) );
}

