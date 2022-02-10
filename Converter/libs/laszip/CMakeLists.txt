cmake_minimum_required(VERSION 3.10)
set(CMAKE_SUPPRESS_REGENERATION true)

project(LASzip LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})


set(ROOT_DIR "${PROJECT_SOURCE_DIR}")

# the next line is the ONLY place in the entire laszip system where
# the version info is hard-coded
set(LASZIP_API_VERSION_STRING "3.4.1" CACHE STRING "LASzip version" FORCE)
set(LASZIP_API_VERSION ${LASZIP_API_VERSION_MAJOR}.${LASZIP_API_VERSION_MINOR}.${LASZIP_API_VERSION_PATCH})

file(GLOB source_files
	"src/*.h"
	"src/*.hpp"
	"src/*.cpp"
	"dll/*.c"
	"dll/*.h"
)

list(FILTER source_files EXCLUDE REGEX ".*src/demzip_dll.cpp$")
list(FILTER source_files EXCLUDE REGEX ".*dll/demzip_api.c$")
list(FILTER source_files EXCLUDE REGEX ".*dll/demzip_api.h$")
list(FILTER source_files EXCLUDE REGEX ".*dll/laszip_api.h$")
list(FILTER source_files EXCLUDE REGEX ".*dll/laszip_api.c$")

#message("${source_files}") 


add_library(laszip SHARED ${source_files})
target_include_directories(laszip PRIVATE 
	./dll
	./src
	../
)

set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)

target_compile_definitions(laszip PUBLIC OPENCV_VERSION=${OpenCV_VERSION})
target_compile_definitions(laszip PUBLIC _CRT_SECURE_NO_DEPRECATE)
target_compile_definitions(laszip PUBLIC _CRT_SECURE_NO_WARNINGS)
target_compile_definitions(laszip PUBLIC _CRT_NONSTDC_NO_WARNING)
target_compile_definitions(laszip PUBLIC _SCL_SECURE_NO_WARNINGS)
target_compile_definitions(laszip PUBLIC NOMINMAX)
target_compile_definitions(laszip PUBLIC WIN32_LEAN_AND_MEAN)
target_compile_definitions(laszip PUBLIC LASZIP_DLL_EXPORT=1)
target_compile_definitions(laszip PUBLIC LASZIPDLL_EXPORTS)
target_compile_definitions(laszip PUBLIC UNORDERED)
target_compile_definitions(laszip PUBLIC HAVE_UNORDERED_MAP=1)

if(UNIX)
  find_package(LASlib REQUIRED)
  target_link_libraries(laszip PUBLIC LASlib)
endif()
