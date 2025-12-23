#include "ApiClient.h"
#include <QNetworkRequest>
#include <QUrl>

ApiClient::ApiClient(QObject* parent)
    : QObject(parent)
    , m_baseUrl("http://localhost:8081")
{
}

void ApiClient::setBaseUrl(const QString& url) {
    if (m_baseUrl != url) {
        m_baseUrl = url;
        emit baseUrlChanged();
    }
}

void ApiClient::setLoading(bool loading) {
    if (m_isLoading != loading) {
        m_isLoading = loading;
        emit isLoadingChanged();
    }
}

void ApiClient::get(const QString& endpoint) {
    if (m_currentReply) {
        m_currentReply->abort();
        m_currentReply->deleteLater();
    }

    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    m_currentEndpoint = endpoint;
    m_currentReply = m_manager.get(request);
    connect(m_currentReply, &QNetworkReply::finished, this, &ApiClient::handleReplyFinished);
    setLoading(true);
}

void ApiClient::post(const QString& endpoint, const QJsonObject& data) {
    if (m_currentReply) {
        m_currentReply->abort();
        m_currentReply->deleteLater();
    }

    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    m_currentEndpoint = endpoint;
    m_currentReply = m_manager.post(request, QJsonDocument(data).toJson());
    connect(m_currentReply, &QNetworkReply::finished, this, &ApiClient::handleReplyFinished);
    setLoading(true);
}

void ApiClient::deleteResource(const QString& endpoint) {
    if (m_currentReply) {
        m_currentReply->abort();
        m_currentReply->deleteLater();
    }

    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    m_currentEndpoint = endpoint;
    m_currentReply = m_manager.deleteResource(request);
    connect(m_currentReply, &QNetworkReply::finished, this, &ApiClient::handleReplyFinished);
    setLoading(true);
}

void ApiClient::handleReplyFinished() {
    setLoading(false);

    if (!m_currentReply) return;

    if (m_currentReply->error() == QNetworkReply::NoError) {
        QByteArray data = m_currentReply->readAll();
        emit requestSuccess(data, m_currentEndpoint);
    } else {
        // Для отладки: выводим информацию об ошибке
        qDebug() << "API Error:" << m_currentReply->errorString();
        qDebug() << "URL:" << m_currentReply->url().toString();
        
        // Если сервер недоступен, показываем понятное сообщение
        if (m_currentReply->error() == QNetworkReply::ConnectionRefusedError) {
            emit requestError("Сервер недоступен. Проверьте:\n"
                            "1. Сервер запущен\n"
                            "2. URL правильный: " + m_baseUrl + "\n"
                            "3. Порт правильный: 8081", m_currentEndpoint);
        } else {
            emit requestError(m_currentReply->errorString(), m_currentEndpoint);
        }
    }

    m_currentReply->deleteLater();
    m_currentReply = nullptr;
}