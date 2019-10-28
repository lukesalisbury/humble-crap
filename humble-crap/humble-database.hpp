#ifndef HUMBLEDATABASE_HPP
#define HUMBLEDATABASE_HPP

#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QList>
#include <QThreadPool>
#include <QFuture>


class HumbleUserDatabase: public QObject
{
	Q_OBJECT
	public:
		HumbleUserDatabase(QString user, QObject *parent = nullptr);
		~HumbleUserDatabase();

		QVariantList updateOrder(QString key, QJsonDocument content);
		void insertOrder(QString key, QString content);
		void installProduct(QString ident, QString executable, QString path);

		QFuture<QVariantList> getItems(QString page, qint32 bits);
		QFuture<QVariantMap> getItem(QString ident);
		QFuture<QVariantList> getItemDownloads(QString ident, QString platform);

	private:
		QString filename = "";
		QSqlDatabase database;
		QThreadPool * pool = nullptr;

		QVariantMap getRecordMap(const QSqlRecord & record );
		QVariantList internalUpdateOrder(QString key, QJsonDocument content);
		void internalInsertOrder(QString key, QJsonObject product);
	signals:
		void databaseLoaded();
		void databaseFailed();
};

/*
class HumbleDatabaseWorker;

class HumbleDatabase: public QThread
{
	Q_OBJECT
	public:
		HumbleDatabase(QString file, QString name, QObject *parent = nullptr);
		~HumbleDatabase();

		void execute( const QString& query, QList<QVariant> * list = nullptr );
	protected:
		void run();
	private:
		HumbleDatabaseWorker * database;
	signals:
	  void progress( const QString& msg );
	  void ready(bool);
	  void results( const QList<QSqlRecord>& records );
	  void executefwd( const QString& query );

};
*/

#endif
