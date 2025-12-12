#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <functional>

class ApiClient : public QObject
{
    Q_OBJECT
public:
    explicit ApiClient(QObject *parent = nullptr);

    void getCategories(std::function<void(QJsonArray)> callback);
    void getUsers(std::function<void(QJsonArray)> callback);

private:
    QNetworkAccessManager manager;
};
