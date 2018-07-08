/****************************************************************************
* Copyright © 2015 Luke Salisbury
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
#ifndef DOWNLOADHUMBLE_HPP
#define DOWNLOADHUMBLE_HPP

#include <QtCore>
#include <QObject>

class HumbleCrap : public QObject
{
	Q_OBJECT
	public:
		explicit HumbleCrap(QObject *parent = 0);

		Q_INVOKABLE QString getDefaultDataPath();

		Q_INVOKABLE QByteArray readFile( QString file );
		Q_INVOKABLE bool writeFile(QByteArray content, QString as);
		Q_INVOKABLE bool writeFile(QString content, QString as);

		Q_INVOKABLE bool openFile( QString file );
		Q_INVOKABLE bool openUrl(QString url );
		Q_INVOKABLE bool executeFile(QUrl command, QUrl location);

		Q_INVOKABLE QString getUsername();
		Q_INVOKABLE void setUsername( QString email );

		Q_INVOKABLE void setValue( QString key, QString value );
		Q_INVOKABLE QVariant getValue( QString key );

		Q_INVOKABLE QString makeUrlLocal(QUrl url);


	signals:
		void refresh();
		void appError( QString errorMessage );
		void appSuccess();

	public slots:

	protected:

	private:
		QSettings settings;
		QString settingPrefix;
		QString errorMessage;
		QByteArray crapHeader;
};

#endif // DOWNLOADHUMBLE_HPP




