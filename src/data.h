#ifndef DATA_H
#define DATA_H

#include <string>
#include <QObject>
#include <QStandardPaths>
#include <QJsonObject>
#include <iostream>
#include <fstream>
#include <nlohmann/json.hpp>
#include <nlohmann/json-schema.hpp>
#include <QDebug>
#include <QDir>

using Paths = QStandardPaths;

using nlohmann::json;
using nlohmann::json_schema::json_validator;


class Data : public QObject
{
    Q_OBJECT

protected:
    json defaultPlanilla;

    json planillaSchema;

    QString appData = Paths::writableLocation(Paths::AppDataLocation);

    QString opened;

    json jsonData;

public:

    explicit Data(QObject *parent = nullptr);

    Q_INVOKABLE qint8 open(QString name);
    Q_INVOKABLE QString getOpened();
    Q_INVOKABLE void save(QString name);
    Q_INVOKABLE QString getJson();
    Q_INVOKABLE void setJson(QString j);
    Q_INVOKABLE unsigned subjectUID();
    Q_INVOKABLE QString getSubjectName(unsigned uid);
    Q_INVOKABLE QString getSubjectColor(unsigned uid);

};

#endif // DATA_H
