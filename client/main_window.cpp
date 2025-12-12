#include "main_window.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QVBoxLayout>
#include <QHeaderView>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    setupUI();
    loadCategories();
    loadUsers();
}

void MainWindow::setupUI()
{
    QWidget *central = new QWidget(this);
    QVBoxLayout *layout = new QVBoxLayout(central);

    tabs = new QTabWidget(this);

    // Таблица категорий
    categoryTable = new QTableWidget(this);
    categoryTable->setColumnCount(2);
    categoryTable->setHorizontalHeaderLabels({"ID", "Name"});
    categoryTable->horizontalHeader()->setStretchLastSection(true);

    // Таблица пользователей
    userTable = new QTableWidget(this);
    userTable->setColumnCount(5);
    userTable->setHorizontalHeaderLabels({"ID", "Name", "Department ID", "Role ID", "PC IDs"});
    userTable->horizontalHeader()->setStretchLastSection(true);

    tabs->addTab(categoryTable, "Categories");
    tabs->addTab(userTable, "Users");

    layout->addWidget(tabs);
    setCentralWidget(central);
    setWindowTitle("Qt Client for Server");
}

void MainWindow::loadCategories()
{
    api.getCategories([this](QJsonArray categories) {
        categoryTable->setRowCount(categories.size());
        for (int i = 0; i < categories.size(); ++i)
        {
            QJsonObject obj = categories[i].toObject();
            categoryTable->setItem(i, 0, new QTableWidgetItem(QString::number(obj["id"].toInt())));
            categoryTable->setItem(i, 1, new QTableWidgetItem(obj["name_category"].toString()));
        }
    });
}

void MainWindow::loadUsers()
{
    api.getUsers([this](QJsonArray users) {
        userTable->setRowCount(users.size());
        for (int i = 0; i < users.size(); ++i)
        {
            QJsonObject obj = users[i].toObject();
            userTable->setItem(i, 0, new QTableWidgetItem(QString::number(obj["id"].toInt())));
            userTable->setItem(i, 1, new QTableWidgetItem(obj["name_user"].toString()));
            userTable->setItem(i, 2, new QTableWidgetItem(QString::number(obj["department_id"].toInt())));
            userTable->setItem(i, 3, new QTableWidgetItem(QString::number(obj["role_id"].toInt())));

            // PC IDs
            QJsonArray pc_ids = obj["pc_ids"].toArray();
            QString pc_text;
            for (auto pc : pc_ids) pc_text += QString::number(pc.toInt()) + " ";
            userTable->setItem(i, 4, new QTableWidgetItem(pc_text.trimmed()));
        }
    });
}
