QT += core quick network charts
QT += quickcontrols2
QT += sql network
CONFIG += c++17

SOURCES += \
    main.cpp \
    network/ApiClient.cpp \
    services/CategoryService.cpp \
    services/DepartmentService.cpp \
    services/PoService.cpp \
    services/PcService.cpp \
    services/UserService.cpp \
    services/RoleService.cpp \
    services/AdminService.cpp \
    services/SemiService.cpp \
    services/ReportService.cpp \
    services/VersionPoService.cpp \
    viewmodels/CategoryViewModel.cpp \
    viewmodels/DepartmentViewModel.cpp \
    viewmodels/AdminViewModel.cpp \
    viewmodels/PoViewModel.cpp \
    viewmodels/PcViewModel.cpp \
    viewmodels/UserViewModel.cpp \
    viewmodels/RoleViewModel.cpp \
    viewmodels/SemiViewModel.cpp \
    viewmodels/VersionPoViewModel.cpp \
    viewmodels/ReportViewModel.cpp

HEADERS += \
    network/ApiClient.h \
    dto/CategoryDto.h \
    dto/DepartmentDto.h \
    dto/PoDto.h \
    dto/PcDto.h \
    dto/UserDto.h \
    dto/RoleDto.h \
    dto/SemiDto.h \
    dto/VersionPoDto.h \
    services/CategoryService.h \
    services/DepartmentService.h \
    services/PoService.h \
    services/PcService.h \
    services/UserService.h \
    services/RoleService.h \
    services/ReportService.h \
    services/SemiService.h \
    services/AdminService.h \
    services/VersionPoService.h \
    viewmodels/CategoryViewModel.h \
    viewmodels/DepartmentViewModel.h \
    viewmodels/PoViewModel.h \
    viewmodels/PcViewModel.h \
    viewmodels/UserViewModel.h \
    viewmodels/AdminViewModel.h \
    viewmodels/RoleViewModel.h \
    viewmodels/SemiViewModel.h \
    viewmodels/VersionPoViewModel.h \
    viewmodels/ReportViewModel.h

RESOURCES += \
    qml.qrc

# Дополнительные настройки
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

# Настройки компиляции
CONFIG(debug, debug|release) {
    DESTDIR = debug
} else {
    DESTDIR = release
}

TARGET = coursework_client