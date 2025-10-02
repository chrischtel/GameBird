cmake_minimum_required(VERSION 3.16)

# compiler commands json file
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(GameBird LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)


# Tell CMake where Qt is (adjust version if needed)
set(Qt6_DIR "C:/Qt/6.9.3/mingw_64/lib/cmake/Qt6")

find_package(Qt6 REQUIRED COMPONENTS Quick Widgets QuickControls2)

# Add custom clean target
add_custom_target(clean-all
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}
    COMMENT "Cleaning all build files"
)

qt_add_executable(GameBird
    ${CMAKE_SOURCE_DIR}/src/main.cpp
    ${CMAKE_SOURCE_DIR}/src/game.h
    ${CMAKE_SOURCE_DIR}/src/game.cpp
    ${CMAKE_SOURCE_DIR}/src/gamelibrary.h
    ${CMAKE_SOURCE_DIR}/src/gamelibrary.cpp
)
qt_add_qml_module(GameBird
    URI GameManager
    VERSION 1.0
    QML_FILES 
        qml/main.qml
        qml/GameItem.qml
)

target_link_libraries(GameBird
    PRIVATE Qt6::Quick Qt6::Widgets Qt6::QuickControls2
)

if(WIN32)
    add_custom_command(TARGET GameBird POST_BUILD
        COMMAND "${Qt6_DIR}/../../../bin/windeployqt.exe" 
                "$<TARGET_FILE:GameBird>"
        COMMENT "Running windeployqt to bundle Qt dependencies..."
    )
endif()
