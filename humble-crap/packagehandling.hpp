#ifndef PACKAGEHANDLING_HPP
#define PACKAGEHANDLING_HPP

#include <QObject>
#include <QDebug>
class PackageHandling : public QObject
{
	Q_OBJECT
	public:
		explicit PackageHandling(QObject *parent = 0);

		Q_PROPERTY(QString file READ file WRITE setFile NOTIFY fileChanged)


		void setFile(const QString &a);
		QString file() const;



	signals:
		void fileChanged();

	public slots:


private:
	QString filename;

	bool selectSource();

	bool selectDestination();


};

#endif // PACKAGEHANDLING_HPP
