cmake_minimum_required (VERSION 3.5)
project (c-ray)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY bin/)

FILE(GLOB CSources src/*.c)
add_executable(c-ray ${CSources})

INCLUDE(FindPkgConfig)

PKG_SEARCH_MODULE(SDL2 REQUIRED sdl2)

INCLUDE_DIRECTORIES(${SDL2_INCLUDE_DIRS} ${SDL2IMAGE_INCLUDE_DIRS})
TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${SDL2_LIBRARIES} ${SDL2IMAGE_LIBRARIES})
target_link_libraries(${PROJECT_NAME} -lpthread -lm)
