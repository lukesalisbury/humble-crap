#include "humble-database.hpp"
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QtConcurrent/QtConcurrent>

typedef enum {QC_ORDERS, QC_PRODUCTS, QC_DOWNLOADS, QC_COUNT} QUERY_CREATION_LIST;
static QString query_creation[QC_COUNT] = {
	R"SQL(CREATE TABLE IF NOT EXISTS ORDERS(
		"order_id" VARCHAR NOT NULL,
		"bundle_name" VARCHAR,
		"date" DATETIME NOT NULL DEFAULT 0,
		"cache" BLOB,
		"cacheversion" VARCHAR NOT NULL,
		PRIMARY KEY ("order_id")
	);)SQL",
	R"SQL(CREATE TABLE IF NOT EXISTS PRODUCTS(
		"product_id" VARCHAR PRIMARY KEY NOT NULL UNIQUE,
		"product" VARCHAR NOT NULL,
		"author" VARCHAR NOT NULL,
		"type" VARCHAR NOT NULL DEFAULT unknown,
		"status" INTEGER,
		"icon" VARCHAR NOT NULL DEFAULT "humble-crap64.png",
		"executable" VARCHAR NOT NULL DEFAULT "",
		"location" VARCHAR NOT NULL  DEFAULT "",
		"installed" VARCHAR NOT NULL DEFAULT 0,
		"orderkey" VARCHAR
	);)SQL",
	R"SQL(CREATE TABLE IF NOT EXISTS DOWNLOADS(
		"download_id" VARCHAR NOT NULL,
		"platform" VARCHAR NOT NULL,
		"format" VARCHAR NOT NULL,
		"date" DATETIME NOT NULL DEFAULT 0,
		"version" VARCHAR DEFAULT 0, "torrent" TEXT,
		"url" TEXT, "size" INTEGER NOT NULL DEFAULT 0,
		"sha1" TEXT, "md5" TEXT, "machine_name" VARCHAR,
		PRIMARY KEY ("download_id", "platform", "format")
	);)SQL"
};


typedef enum {QL_ORDERS_REPLACE, QL_DOWNLOAD_REPLACE, QL_PRODUCT_REPLACE, QL_DOWNLOAD_PLATFORMS,\
			  QL_ORDER_LIST, QL_ORDER_SET_DATE, QL_PRODUCT_LIST, QL_PRODUCT_INFO, QL_PRODUCT_DOWNLOAD, QL_PRODUCT_INSTALLED, QL_ORDER_PRODUCT, QL_COUNT} QUERIES_LIST;
static QString query_list[QL_COUNT] = {
	/*QL_ORDERS_REPLACE*/ "REPLACE INTO ORDERS (order_id, cache, bundle_name, date, cacheversion) VALUES(?, ?, ?, ?, ?)",
	/*QL_DOWNLOAD_REPLACE*/ "REPLACE INTO DOWNLOADS (download_id, platform, format, machine_name, version, date, torrent, url, sha1, md5, size) VALUES(?, ?, ?,?, ?,?,?, ?, ?,?,?)",
	/*QL_PRODUCT_REPLACE*/ "REPLACE INTO PRODUCTS (product_id, product, author, status, icon, type, orderkey ) VALUES(?,?,?,?,?,?,?)",
	/*QL_DOWNLOAD_PLATFORMS*/ "SELECT DISTINCT platform FROM DOWNLOADS WHERE id = ?",
	/*QL_ORDER_LIST*/ "SELECT order_id, cache, date FROM ORDERS",
	/*QL_ORDER_SET_DATE*/ "UPDATE ORDERS SET date = ? WHERE order_id = ?",
	/*QL_PRODUCT_LIST*/ "SELECT DISTINCT product_id, product, author, orderkey, status, icon, executable, location, installed, platform, date, version FROM PRODUCTS LEFT JOIN DOWNLOADS ON product_id=download_id  WHERE platform = ?  GROUP BY product_id ORDER BY \"product\", date;",
	/*QL_PRODUCT_INFO*/ "SELECT DISTINCT * FROM PRODUCTS WHERE product_id = ?",
	/*QL_PRODUCT_DOWNLOAD*/ "SELECT DISTINCT * FROM PRODUCTS, DOWNLOADS WHERE product_id=download_id AND product_id = ? AND platform = ?",
	/*QL_PRODUCT_INSTALLED*/ "UPDATE PRODUCTS SET status = ?, executable = ?, installed = ? WHERE product_id = ?",
	/*QL_ORDER_PRODUCT*/ "SELECT PRODUCTS.product_id, DOWNLOADS.download_id, DOWNLOADS.platform, DOWNLOADS.format, DOWNLOADS.version FROM PRODUCTS, DOWNLOADS WHERE DOWNLOADS.download_id = PRODUCTS.product_id AND orderkey = ?;"
};

class name
{
	public:
		name() {}
};


HumbleUserDatabase::HumbleUserDatabase(QString user, QObject * parent) {
	Q_UNUSED(parent);
	QDir dir;
	QString path = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
	dir.mkpath(path);

	this->filename = QDir(path).filePath(user + ".sqlite" );

	this->pool = new QThreadPool(this);
	this->pool->setExpiryTimeout(-1);

	;
	QtConcurrent::run(this->pool, [=]() {
		this->database = QSqlDatabase::addDatabase("QSQLITE", user);
		this->database.setDatabaseName(filename);
		/* Create Database tables */
		if ( this->database.open() )
		{
			QSqlQuery query(this->database);
			query.exec(query_creation[QC_DOWNLOADS]);
			query.exec(query_creation[QC_ORDERS]);
			query.exec(query_creation[QC_PRODUCTS]);
			this->database.commit();

			qDebug() << "HumbleUserDatabase" << this->database.lastError();
			emit databaseLoaded();
		} else {
			qDebug() << "HumbleUserDatabase" << this->database.lastError();
			emit databaseFailed();
		}

	});
}

HumbleUserDatabase::~HumbleUserDatabase() {
	this->database.close();
	this->pool->clear();
	delete this->pool;
}


QVariantMap HumbleUserDatabase::getRecordMap(const QSqlRecord & record ) {
	QVariantMap map;
	qDebug() << record.count();
	for (int i=0; i<record.count(); ++i) {
		map.insert( record.fieldName(i), record.value(i));
	}
	return map;
}

void HumbleUserDatabase::installProduct(QString ident, QString executable, QString path) {
	QtConcurrent::run(this->pool, [=]() {
		if (this->database.isOpen()) {

			QSqlQuery query(this->database);
			query.prepare(query_list[QL_PRODUCT_INSTALLED]);
			query.addBindValue(1);
			query.addBindValue(executable);
			query.addBindValue(path);
			query.addBindValue(ident);
			bool results = query.exec();
			qDebug() << query_list[QL_PRODUCT_INSTALLED] << results << ident << executable << path;
		}
	});
}

void HumbleUserDatabase::internalInsertOrder(QString key, QJsonObject product) {
	QList<QString> availableTypes;
	if ( product["downloads"].isArray() ) {
		QJsonArray downloads = product["downloads"].toArray();
		foreach (const QJsonValue & d, downloads) {
			QJsonObject download = d.toObject();
			availableTypes.append(download["platform"].toString());

			if ( download["download_struct"].isArray() ) {
				QJsonArray download_info = download["download_struct"].toArray();
				foreach (const QJsonValue & e, download_info) {
					QJsonObject w = e.toObject();
					if ( w.contains("url") ) {

						QSqlQuery query(this->database);
						query.prepare(query_list[QL_DOWNLOAD_REPLACE]);

						query.addBindValue(product["machine_name"].toString());
						query.addBindValue(download["platform"].toString());
						query.addBindValue(w["name"].toString());
						query.addBindValue(download["machine_name"].toString());
						query.addBindValue(download.contains("download_version_number") ? download["download_version_number"].toInt() : 0);
						query.addBindValue(w["timestamp"].toString());
						query.addBindValue(e["url"]["bittorrent"].toString());
						query.addBindValue(e["url"]["web"].toString());
						query.addBindValue(w["sha1"].toString());
						query.addBindValue(w["md5"].toString());
						query.addBindValue(w["file_size"].toString());

						query.exec();
					}
				}
			}
		}
	}


	{
		QSqlQuery query(this->database);
		query.prepare(query_list[QL_PRODUCT_REPLACE]);
		QJsonObject p = product["payee"].toObject();
		query.addBindValue(product["machine_name"].toString());
		query.addBindValue(product.contains("human_name") ? product["human_name"].toString() : product["machine_name"].toString());
		query.addBindValue(!p["human_name"].isUndefined() ? p["human_name"].toString() : p["machine_name"].toString());
		query.addBindValue(0);
		query.addBindValue(product["icon"].toString());
		query.addBindValue(availableTypes.join("|"));
		query.addBindValue(key);
		query.exec();
	}
}

QVariantList HumbleUserDatabase::internalUpdateOrder(QString key, QJsonDocument content) {
	QVariantList changes;
	if (this->database.isOpen()) {
		if ( content["subproducts"].isArray() ) {
			//Get current info
			QVariantMap results;
			{
				QSqlQuery query(this->database);
				query.setForwardOnly(true);
				query.prepare(query_list[QL_ORDER_PRODUCT]);
				query.addBindValue(key);
				if ( query.exec() ) {
					while (query.next()) {
						QVariantMap map = this->getRecordMap(query.record());
						qDebug() << map["download"] << map;
						results.insert(map["download"].toString(), map);
					}
				}

			}
			qDebug() << results;
			QJsonArray subproducts = content["subproducts"].toArray();
			foreach (const QJsonValue & v, subproducts) {
				QJsonObject product = v.toObject();

				QJsonArray downloads = product["downloads"].toArray();
				foreach (const QJsonValue & d, downloads) {
					QJsonObject download = d.toObject();
					if ( download["download_struct"].isArray() ) {
						qDebug() << product["machine_name"].toString() << download["platform"].toString() <<  download["download_version_number"].toInt() << download["timestamp"].toString();
					}
				}
				//if ( ) {

				//}
				this->internalInsertOrder(key, product);
			}
		}

	}
	return changes;
}


QVariantList HumbleUserDatabase::updateOrder(QString key, QJsonDocument content) {

	QFuture<QVariantList> future = QtConcurrent::run(this->pool, [=]() {
		return internalUpdateOrder(key, content);
	});

	return future.result();
}

void HumbleUserDatabase::insertOrder(QString key, QString content) {
	QtConcurrent::run(this->pool, [=]() {
		if (this->database.isOpen()) {
			QJsonDocument obj = QJsonDocument::fromJson(content.toUtf8());

			if ( obj["subproducts"].isArray() ) {
				{
					QSqlQuery query(this->database);
					query.prepare(query_list[QL_ORDERS_REPLACE]);
					query.addBindValue(key);
					query.addBindValue("");
					query.addBindValue(obj["product"]["machine_name"]);
					query.addBindValue(obj["created"]);
					query.addBindValue(obj["uid"]);
					query.exec();
				}

				QJsonArray subproducts = obj["subproducts"].toArray();
				foreach (const QJsonValue & v, subproducts) {
					QJsonObject product = v.toObject();

					this->internalInsertOrder(key, product);


				}
			}
		}
	});
}

QFuture<QVariantList> HumbleUserDatabase::getItems(QString page, qint32 bits)
{
	Q_UNUSED(bits);
	return QtConcurrent::run(this->pool, [=]() {
		QVariantList results;
		if (this->database.isOpen()) {
			QSqlQuery query(this->database);
			query.setForwardOnly(true);
			query.prepare(query_list[QL_PRODUCT_LIST]);
			query.addBindValue(page);
			//query.addBindValue(bits);
			if ( query.exec() ) {
				while (query.next()) {
					QVariantMap map;
					for (int i=0; i<query.record().count(); ++i) {
						map.insert( query.record().fieldName(i), query.value(i));
					}
					results.push_back(this->getRecordMap(query.record()));
				}
			}
		}
		return results;
	});
}

QFuture<QVariantMap> HumbleUserDatabase::getItem(QString ident)
{
	return QtConcurrent::run(this->pool, [=]() {
		if (this->database.isOpen()) {
			QSqlQuery query(this->database);
			query.prepare(query_list[QL_PRODUCT_INFO]);
			query.addBindValue(ident);

			if ( query.exec() ) {
				if (query.next()) {
					return this->getRecordMap(query.record());
				}
			}
		}
		QVariantMap empty;
		return empty;
	});
}

QFuture<QVariantList> HumbleUserDatabase::getItemDownloads(QString ident, QString platform)
{
	return QtConcurrent::run(this->pool, [=]() {
		QVariantList results;
		if (this->database.isOpen()) {
			QSqlQuery query(this->database);
			query.setForwardOnly(true);
			query.prepare(query_list[QL_PRODUCT_DOWNLOAD]);
			query.addBindValue(ident);
			query.addBindValue(platform);
			if ( query.exec() ) {
				while (query.next()) {
					QVariantMap map;
					for (int i=0; i<query.record().count(); ++i) {
						map.insert( query.record().fieldName(i), query.value(i));
					}
					results.push_back(this->getRecordMap(query.record()));
				}
			}
		}
		return results;
	});
}


