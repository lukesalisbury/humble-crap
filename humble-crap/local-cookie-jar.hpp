#ifndef LOCALCOOKIEJAR_HPP
#define LOCALCOOKIEJAR_HPP

#include <QNetworkCookieJar>

class LocalCookieJar : public QNetworkCookieJar
{
	public:
		LocalCookieJar(QString user);

		void SaveToDisk();
		void LoadFromDisk();

	private:
		QString cookie_path;
};

#endif // LOCALCOOKIEJAR_HPP
