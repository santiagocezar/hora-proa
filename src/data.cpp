#include "data.h"
using namespace std;

Data::Data(QObject *parent) : QObject(parent) {
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
        "days": [[],[],[],[],[]],
        "subjects":[]
    }
    )"_json;

    planillaSchema = R"(
    {
        "$schema": "http://json-schema.org/draft-07/schema#",
        "title": "Plantilla Schema",
        "required": [
            "modules",
            "moduleText",
            "days",
            "subjects"
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
                "items": {
                    "type": "array",
                    "title": "Day",
                    "items": {
                        "type": "object",
                        "title": "Module",
                        "required": [
                            "uid",
                            "pos",
                            "duration"
                        ],
                        "properties": {
                            "uid": {
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
            },
            "subjects": {
                "type": "array",
                "title": "List of subjects",
                "items": {
                    "type": "object",
                    "title": "Subject",
                    "required": [
                        "name",
                        "color",
                        "uid"
                    ],
                    "properties": {
                        "name": {
                            "type": "string"
                        },
                        "color": {
                            "type": "string"
                        },
                        "uid": {
                            "type": "integer"
                        }
                    }
                }
            }
        }
    }
    )"_json;
}

qint8 Data::open(QString name) {
    opened = name;

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

        unsigned daysSize = jsonData["days"].size();
        cout << daysSize << endl;
        if (daysSize < 5) {
            for (unsigned j = 0; j < 5 - daysSize; ++j) {
                jsonData["days"].push_back(jsonData.array());
            }
        }

        return true;
    } catch (const exception &e) {
        cerr << e.what() << endl;
        jsonData = defaultPlanilla;
        return false;
    }
}

QString Data::getOpened() {
    return opened;
}

void Data::save(QString name) {
    ofstream dataFile;
    dataFile.open(appData.toStdString() + "/" + name.toStdString() + ".json");
    dataFile << jsonData.dump(4);
    dataFile.close();
}

QString Data::getJson() {
    return QString::fromStdString(jsonData.dump());
}

void Data::setJson(QString j) {
    jsonData = json::parse(j.toStdString());
    jsonUpdated();
}

unsigned Data::subjectUID() {
    int uid = 0;
    while ( [&] () {
        for (json subject : jsonData["subjects"]) {
           if (subject["uid"] == uid) return true;
        }
        return false;
    } () ) uid++;
    return uid;
}

QString Data::getSubjectName(unsigned uid) {
    for (json subject : jsonData["subjects"]) {
       if (subject["uid"] == uid) {
           return QString::fromStdString(subject["name"]);
       }
    }
    return QString();
}

QString Data::getSubjectColor(unsigned uid) {
    for (json subject : jsonData["subjects"]) {
       if (subject["uid"] == uid) {
           return QString::fromStdString(subject["color"]);
       }
    }
    return QString();
}
