#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

class ApiClient : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString baseUrl READ baseUrl WRITE setBaseUrl NOTIFY baseUrlChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit ApiClient(QObject* parent = nullptr);

    QString baseUrl() const { return m_baseUrl; }
    void setBaseUrl(const QString& url);
    bool isLoading() const { return m_isLoading; }  

    Q_INVOKABLE void get(const QString& endpoint);
    
    Q_INVOKABLE void post(const QString& endpoint, const QJsonObject& data);
    
    Q_INVOKABLE void deleteResource(const QString& endpoint);

signals:
    void baseUrlChanged();
    void isLoadingChanged();
    void requestSuccess(const QByteArray& data, const QString& endpoint);
    void requestError(const QString& error, const QString& endpoint);

private slots:
    void handleReplyFinished();

private:
    QNetworkAccessManager m_manager;
    QString m_baseUrl = "http://localhost:8081";
    QNetworkReply* m_currentReply = nullptr;
    bool m_isLoading = false;
    QString m_currentEndpoint;
    
    void setLoading(bool loading);
};