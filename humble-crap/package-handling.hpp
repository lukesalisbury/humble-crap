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

#ifndef PACKAGEHANDLING_HPP
#define PACKAGEHANDLING_HPP

#include <QObject>
#include <QDebug>

class PackageHandling : public QObject
{
	Q_OBJECT
	public:
		explicit PackageHandling(QObject *parent = nullptr);

		Q_INVOKABLE void install(QString filename, QString ident, QString category);

	signals:
		void completed(QString ident, QString executable, QString path);
		void failed(QString ident, QString message);


	private:
		//ebook types
		QStringList ebookTypes = {
			"application/x-mobipocket-ebook",
			"application/pdf",
			"application/epub+zip"
		};
		//Audio types
		//Compressed types
		QStringList compressedTypes = {
			"application/x-zip-compressed",
			"application/x-bzip2",
			"application/x-7z-compressed"
		};
		//Packages types
		//Executable types
		//Special Instructions



};

#endif // PACKAGEHANDLING_HPP
