#ifndef PACKAGEHANDLER_HPP
#define PACKAGEHANDLER_HPP

#include <QQmlExtensionPlugin>

class PackagePlugin : public QQmlExtensionPlugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "com.github.lukesalisbury.humblecrap")

public:

	void registerTypes(const char *uri);

};

#endif // PACKAGEHANDLER_HPP
