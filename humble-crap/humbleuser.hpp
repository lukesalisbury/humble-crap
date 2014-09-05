#ifndef HUMBLEUSER_HPP
#define HUMBLEUSER_HPP

#include "humblenetwork.hpp"

class HumbleUser: public QObject
{
	Q_OBJECT
public:
	Q_INVOKABLE QString getErrorMessage();

	Q_INVOKABLE void login(QString email, QString password);

	Q_INVOKABLE void updateOrders();
	Q_INVOKABLE QString getOrders();

signals:
	void appError(  );
	void appSuccess();
	void contentFinished();

public slots:
	void finishLogin( QByteArray content );
	void downloadError( QString errorMessage );

protected:
	HumbleNetworkRequest request;
	QString currentPassword;
	QString currentUser;
	QByteArray pageContent;

private:
	bool loginSuccess;
	QString errorMessage;

};

#endif // HUMBLEUSER_HPP
