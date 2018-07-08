#ifndef SHAREDFUNCTIONS_HPP
#define SHAREDFUNCTIONS_HPP

#include <QtCore>
#include <QNetworkAccessManager>

//From main.cpp
QNetworkAccessManager * getNetworkManager();
QString getPathFromSettings(QString type);

//From shared-functions.cpp
bool doesFileExists(QString path);

#endif // SHAREDFUNCTIONS_HPP
