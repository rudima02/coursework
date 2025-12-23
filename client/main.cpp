#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>

#include "viewmodels/CategoryViewModel.h"
#include "viewmodels/DepartmentViewModel.h"
#include "viewmodels/PoViewModel.h"
#include "viewmodels/PcViewModel.h"
#include "viewmodels/UserViewModel.h"
#include "viewmodels/RoleViewModel.h"
#include "viewmodels/SemiViewModel.h"
#include "viewmodels/VersionPoViewModel.h"
#include "viewmodels/ReportViewModel.h"
#include "viewmodels/AdminViewModel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv); 
    

    QQuickStyle::setStyle("Material");
    
    
    app.setOrganizationName("AB-421");
    app.setApplicationName("Управление ПО");
    app.setApplicationVersion("1.0.0");
    
    qmlRegisterType<CategoryViewModel>("ViewModels", 1, 0, "CategoryViewModel");
    qmlRegisterType<DepartmentViewModel>("ViewModels", 1, 0, "DepartmentViewModel");
    qmlRegisterType<PoViewModel>("ViewModels", 1, 0, "PoViewModel");
    qmlRegisterType<PcViewModel>("ViewModels", 1, 0, "PcViewModel");
    qmlRegisterType<UserViewModel>("ViewModels", 1, 0, "UserViewModel");
    qmlRegisterType<RoleViewModel>("ViewModels", 1, 0, "RoleViewModel");
    qmlRegisterType<SemiViewModel>("ViewModels", 1, 0, "SemiViewModel");
    qmlRegisterType<VersionPoViewModel>("ViewModels", 1, 0, "VersionPoViewModel");
    qmlRegisterType<ReportViewModel>("ViewModels", 1, 0, "ReportViewModel");
    qmlRegisterType<AdminViewModel>("ViewModels", 1, 0, "AdminViewModel");
    
    QQmlApplicationEngine engine;
    
    engine.load(QUrl(QStringLiteral("qrc:/MainWindow.qml")));
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}