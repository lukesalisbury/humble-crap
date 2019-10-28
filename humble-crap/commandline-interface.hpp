#ifndef CLI_INTERFACE_HPP
#define CLI_INTERFACE_HPP

#include <QObject>
#include <QCoreApplication>

class CommandLineTask {

};

class CommandLineInterface : public QObject
{
	Q_OBJECT
	public:
		CommandLineInterface(QCoreApplication * a, QObject * parent = nullptr);
		~CommandLineInterface();

	signals:
		void taskCompleted();
		void taskFailed();


	public slots:
		void downloadTaskSuccess(int downloadID);
		void downloadTaskFailure(int downloadID);

		void taskSuccess(QString key, QString text);
		void taskFailure(QString key, QString text);


		void exitSuccessfully();
		void exitWithFailure();

		void orderSuccess();
		void orderFailure();

		void mainTask();




	private:
		QCoreApplication * app;
		int task = 0;
		void downloadOrder(QString key);
		void checkForExit();
};

#endif // CLI_INTERFACE_HPP
