#ifndef PLANILLADB_H
#define PLANILLADB_H

#include <string>
#include <QObject>
#include <QStandardPaths>
#include <iostream>
#include <fstream>
#include <nlohmann/json.hpp>
#include <QDebug>
#include <QDir>
#include <paths.h>

using Paths = QStandardPaths;

using nlohmann::json;

class PlanillaDB : public QObject
{
    Q_OBJECT

    QString appData = Paths::writableLocation(Paths::AppDataLocation);

    json jsonData;

public:
    explicit PlanillaDB(QObject *parent = nullptr);

    int openPlanilla(char const *name);

    int savePlanilla(char const *name);

signals:

};

#endif // PLANILLADB_H
