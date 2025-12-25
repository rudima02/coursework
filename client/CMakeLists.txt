cmake_minimum_required(VERSION 3.16)
project(coursework_client)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Network Gui Qml Charts)

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

qt_add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${HEADERS}
)

target_link_libraries(${PROJECT_NAME}
    Qt6::Core
    Qt6::Quick
    Qt6::Network
    Qt6::Gui
    Qt6::Qml
    Qt6::Charts
)

qt_add_resources(${PROJECT_NAME} "qml"
    PREFIX "/"
    FILES ${QML_FILES}
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

if(WIN32)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        WIN32_EXECUTABLE TRUE
        MACOSX_BUNDLE FALSE
    )
endif()

if(APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_ICON_FILE "icon.icns"
    )
endif()