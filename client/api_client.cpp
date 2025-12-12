#include "api_client.h"
#include <QNetworkRequest>
#include <QUrl>
#include <QDebug>

ApiClient::ApiClient(QObject *parent) : QObject(parent)
{
}

void ApiClient::getCategories(std::function<void(QJsonArray)> callback)
{
    QNetworkRequest request(QUrl("http://localhost:8080/categories"));
    QNetworkReply* reply = manager.get(request);

    connect(reply, &QNetworkReply::finished, [reply, callback]() {
        QByteArray data = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (doc.isArray()) callback(doc.array());
        reply->deleteLater();
    });
}

void ApiClient::getUsers(std::function<void(QJsonArray)> callback)
{
    QNetworkRequest request(QUrl("http://localhost:8080/users"));
    QNetworkReply* reply = manager.get(request);

    connect(reply, &QNetworkReply::finished, [reply, callback]() {
        QByteArray data = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (doc.isArray()) callback(doc.array());
        reply->deleteLater();
    });
}
