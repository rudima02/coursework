cmake_minimum_required(VERSION 3.16)
project(coursework_client)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Используем Qt5 вместо Qt6
find_package(Qt5 REQUIRED COMPONENTS Core Quick Network Widgets Charts)

# Список исходных файлов
set(SOURCES
    main.cpp
    network/ApiClient.cpp
    services/CategoryService.cpp
    services/DepartmentService.cpp
    services/PoService.cpp
    services/PcService.cpp
    services/UserService.cpp
    services/RoleService.cpp
    services/SemiService.cpp
    services/VersionPoService.cpp
    services/UpdatePoCountService.cpp
    viewmodels/CategoryViewModel.cpp
    viewmodels/DepartmentViewModel.cpp
    viewmodels/PoViewModel.cpp
    viewmodels/PcViewModel.cpp
    viewmodels/UserViewModel.cpp
    viewmodels/RoleViewModel.cpp
    viewmodels/SemiViewModel.cpp
    viewmodels/VersionPoViewModel.cpp
    viewmodels/UpdatePoCountViewModel.cpp
)

# Список заголовочных файлов
set(HEADERS
    network/ApiClient.h
    dto/CategoryDto.h
    dto/DepartmentDto.h
    dto/PoDto.h
    dto/PcDto.h
    dto/UserDto.h
    dto/RoleDto.h
    dto/SemiDto.h
    dto/VersionPoDto.h
    dto/UpdatePoCountDto.h
    services/CategoryService.h
    services/DepartmentService.h
    services/PoService.h
    services/PcService.h
    services/UserService.h
    services/RoleService.h
    services/SemiService.h
    services/VersionPoService.h
    services/UpdatePoCountService.h
    viewmodels/CategoryViewModel.h
    viewmodels/DepartmentViewModel.h
    viewmodels/PoViewModel.h
    viewmodels/PcViewModel.h
    viewmodels/UserViewModel.h
    viewmodels/RoleViewModel.h
    viewmodels/SemiViewModel.h
    viewmodels/VersionPoViewModel.h
    viewmodels/UpdatePoCountViewModel.h
)

# Список QML файлов
set(QML_FILES
    MainWindow.qml
    CategoriesPage.qml
    DepartmentsPage.qml
    PoPage.qml
    PcPage.qml
    UsersPage.qml
    RolesPage.qml
    SemiPage.qml
    VersionPoPage.qml
    UpdatePoCountPage.qml
    components/Card.qml
    components/MenuButton.qml
    components/StatCard.qml
    components/NotificationManager.qml
)

# Создаем исполняемый файл
add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${HEADERS}
)

# Подключаем Qt5 модули
target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Quick
    Qt5::Network
    Qt5::Widgets
    Qt5::Charts
)

# Добавляем QML файлы как ресурсы
qt5_add_resources(${PROJECT_NAME} "qml"
    PREFIX "/"
    FILES ${QML_FILES}
)

# Устанавливаем свойства сборки
set_target_properties(${PROJECT_NAME} PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)