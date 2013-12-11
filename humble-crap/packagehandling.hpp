#ifndef PACKAGEHANDLING_HPP
#define PACKAGEHANDLING_HPP

#include <QObject>
#include <QDebug>
class PackageHandling : public QObject
{
	Q_OBJECT
	public:
		explicit PackageHandling(QObject *parent = 0);

		//Q_PROPERTY(int root READ root WRITE setRoot NOTIFY rootChanged REVISION 1)
		Q_PROPERTY(QString file READ file WRITE setFile NOTIFY fileChanged)


	void setFile(const QString &a) {
			qDebug() << "PackageHandling::SelectPackage";
		if (a != filename) {
			filename = a;
			emit fileChanged();
		}
	}
	QString file() const {
		return filename;
	}

	signals:
	void fileChanged();

	public slots:


private:
	QString filename;
};

#endif // PACKAGEHANDLING_HPP
