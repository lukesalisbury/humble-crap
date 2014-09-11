#ifndef HUMBLESYSTEM_HPP
#define HUMBLESYSTEM_HPP

#include <QObject>

class HumbleSystem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString platform READ getPlatform)
	Q_PROPERTY(int bits READ getPlatformBits)

public:
	explicit HumbleSystem(QObject *parent = 0);

	QString getPlatform();
	int getPlatformBits();

signals:

public slots:

};

#endif // HUMBLESYSTEM_HPP
