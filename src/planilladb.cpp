#include "planilladb.h"

PlanillaDB::PlanillaDB(QObject *parent) : QObject(parent) {
    QDir dir(appData);
    if (!dir.exists()) dir.mkdir(appData);
}

int PlanillaDB::openPlanilla(char const *name) {
    std::ifstream dataFile;
    dataFile.open(appData.toStdString() + "/" + name + ".json");
    dataFile >> jsonData;

    return 0;
}

int PlanillaDB::savePlanilla(char const *name) {
    std::ofstream dataFile;
    dataFile.open(appData.toStdString() + "/" + name + ".json");
    dataFile << jsonData.dump(4);
    dataFile.close();
    return 0;
}
