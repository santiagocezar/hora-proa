#include "planilladb.h"
using namespace std;

Planilla::Planilla(QObject *parent) : QObject(parent) {
    QDir dir(appData);
    if (!dir.exists()) dir.mkdir(appData);

    defaultPlanilla = R"(
    {
      "modules": 14,
      "moduleText": [
        "07:30 a 08:10",
        "08:10 a 08:50",
        "09:00 a 09:40",
        "09:40 a 10:20",
        "10:30 a 11:10",
        "11:10 a 11:50",
        "11:55 a 12:35",
        "12:35 a 13:15",
        "13:15 a 13:55",
        "13:55 a 14:35",
        "14:45 a 15:25",
        "15:25 a 16:05",
        "16:15 a 16:55",
        "16:55 a 17:35"
      ],
      "days": [[]]
    }
    )"_json;

    planillaSchema = R"(
    {
      "$schema": "http://json-schema.org/draft-07/schema#",
      "title": "Plantilla Schema",
      "required": [
        "modules",
        "moduleText",
        "days"
      ],
      "properties": {
        "modules": {
          "type": "integer",
          "title": "Number of Modules"
        },
        "moduleText": {
          "type": "array",
          "title": "Text for each module",
          "items": {
            "type": "string",
            "title": "Text"
          }
        },
        "days": {
          "type": "array",
          "title": "Days of the week",
          "maxLength": 5,
          "items": {
            "type": "array",
            "title": "Day",
            "items": {
              "type": "object",
              "title": "Module",
              "required": [
                "id",
                "pos",
                "duration"
              ],
              "properties": {
                "id": {
                  "type": "integer"
                },
                "pos": {
                  "type": "integer"
                },
                "duration": {
                  "type": "integer",
                  "maximum": 3,
                  "minimum": 1
                }
              }
            }
          }
        }
      }
    }
    )"_json;
}

qint8 Planilla::open(QString name) {
    json_validator v;

    try {
        v.set_root_schema(planillaSchema);
    } catch (const exception &e) {
        return false;
    }

    ifstream dataFile;
    dataFile.open(appData.toStdString() + "/" + name.toStdString() + ".json");
    if (dataFile.good()) {
        try {
            dataFile >> jsonData;
        } catch (const exception &e) {
            cerr << e.what() << " (using default planilla)" << endl;
            jsonData = defaultPlanilla;
        }
    } else {
        jsonData = defaultPlanilla;
    }

    try {
        v.validate(jsonData);
        return true;
    } catch (const exception &e) {
        cerr << e.what() << endl;
        jsonData = defaultPlanilla;
        return false;
    }
}

void Planilla::save(QString name) {
    ofstream dataFile;
    dataFile.open(appData.toStdString() + "/" + name.toStdString() + ".json");
    dataFile << jsonData.dump(4);
    dataFile.close();
}

QString Planilla::getJson() {
    return QString::fromStdString(jsonData.dump());
}

void Planilla::setJson(QString j) {
    jsonData = json::parse(j.toStdString());
}
