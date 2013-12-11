#include "packageplugin.hpp"
#include "packagehandling.hpp"
#include <QtQml/qqml.h>

void PackagePlugin::registerTypes(const char *uri)
{
	//register the class Directory into QML as a "Directory" element version 1.0
	qmlRegisterType<PackageHandling>( uri, 1, 0, "PackageHandling");

}
