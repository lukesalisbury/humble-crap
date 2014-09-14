#include "humblesystem.hpp"

HumbleSystem::HumbleSystem(QObject *parent) :
	QObject(parent)
{

}


QString HumbleSystem::getPlatform()  const
{
#if defined(Q_OS_OSX)
	return "osx";
#elif defined(Q_OS_LINUX)
	return "linux";
#elif defined(Q_OS_WIN32)
	return "windows";
#endif

	return "other";
}

int HumbleSystem::getPlatformBits()  const
{

	return (int)QSysInfo::WordSize;


}
