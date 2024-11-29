cmake_minimum_required(VERSION 3.16)

project(QtAthon VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appQtAthon
    main.cpp
)

qt_add_qml_module(appQtAthon
    URI QtAthon
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES Components/NavButton.qml
        QML_FILES Components/SensorValue.qml
        QML_FILES Components/MachineCard.qml
        QML_FILES Pages/DashboardPage.qml
        QML_FILES Pages/LogsPage.qml
        SOURCES sensordatagenerator.h sensordatagenerator.cpp
        RESOURCES Icons/dashboard.svg Icons/logs.svg Icons/user.svg
        RESOURCES Icons/alert-circle.svg Icons/alert-triangle.svg
        QML_FILES Components/SideArrow.qml
        RESOURCES Icons/arrow.svg
        QML_FILES Components/DownArrow.qml
        QML_FILES Components/SideLeftArrow.qml
        QML_FILES Components/DashboardControlCard.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQtAthon PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQtAthon
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQtAthon
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appQtAthon
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
