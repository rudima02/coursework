#pragma once
#include <QMainWindow>
#include <QTableWidget>
#include <QTabWidget>
#include "api_client.h"

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    MainWindow(QWidget *parent = nullptr);

private:
    QTabWidget *tabs;
    QTableWidget *categoryTable;
    QTableWidget *userTable;
    ApiClient api;

    void setupUI();
    void loadCategories();
    void loadUsers();
};
