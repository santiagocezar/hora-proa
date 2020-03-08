cmake_minimum_required(VERSION 3.5)

project(HoraProA LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(JSON_BuildTests OFF CACHE INTERNAL "")
add_subdirectory(json/)
add_subdirectory(json-schema-validator/)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()


find_package(Qt5 COMPONENTS Core Quick QuickControls2 REQUIRED)


include_directories(
    include/
    src/
)

if(ANDROID)
    add_library(HoraProA SHARED
        src/main.cpp
        src/data.h
        src/data.cpp
        src/qml/qml.qrc
    )

else()
    add_executable(HoraProA
        src/main.cpp
        src/data.h
        src/data.cpp
        src/qml/qml.qrc
    )
endif()

if(WIN32)
    target_sources(HoraProA PRIVATE horaproa.rc)
    find_library(LIBQUICK2PLUGIN qtquick2plugin ${QT_INSTALL_PREFIX}/qml/QtQuick.2)
    qt5_import_plugins(HoraProA INCLUDE QtQuick2Plugin)
endif()

if(ANDROID)
    include(qt-android-cmake/AddQtAndroidApk.cmake)
    add_qt_android_apk(HoraProA_apk HoraProA
        PACKAGE_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/android
    )
endif()


target_compile_definitions(HoraProA
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

if(WIN32)
    target_link_libraries(HoraProA
      PRIVATE nlohmann_json::nlohmann_json nlohmann_json_schema_validator Qt5::Core Qt5::Quick Qt5::QuickControls2 ${LIBQUICK2PLUGIN} -static)
else()
    target_link_libraries(HoraProA
      PRIVATE nlohmann_json::nlohmann_json nlohmann_json_schema_validator Qt5::Core Qt5::Quick Qt5::QuickControls2)
endif()

