# --- CMake ---

cmake_minimum_required(VERSION 3.30)

macro(set_from_environment VARIABLE)
	if (NOT DEFINED ${VARIABLE} AND DEFINED ENV{${VARIABLE}})
		set(${VARIABLE} $ENV{${VARIABLE}})
	endif()
endmacro()

set_from_environment(VCPKG_ROOT)

if(NOT DEFINED VCPKG_ROOT)
	message(FATAL_ERROR "The environment variable VCPKG_ROOT is not set.")
endif()

set(VCPKG_TARGET_TRIPLET "x64-windows-static-md" CACHE STRING "")
set(CMAKE_TOOLCHAIN_FILE "${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL" CACHE STRING "")

# --- Project ---

set(PROJECT_NAME "ConsoleAutocomplete" CACHE STRING "")
set(PROJECT_AUTHOR "SoleVaultBoy" CACHE STRING "")
set(PROJECT_VERSION 1.1.0.0 CACHE STRING "")
set(PROJECT_LICENSE "MIT License" CACHE STRING "")
set(PROJECT_DESCRIPTION "${PROJECT_NAME}" CACHE STRING "")

project(
	"${PROJECT_NAME}"
	VERSION "${PROJECT_VERSION}"
	DESCRIPTION "${PROJECT_DESCRIPTION}"
	LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_DEBUG OFF)
set(CMAKE_OPTIMIZE_DEPENDENCIES ON)

# --- Options ---

set(ENABLE_FALLOUT_F4 ON)
set(ENABLE_FALLOUT_NG ON)
set(ENABLE_FALLOUT_VR OFF)

set(F4SE_SUPPORT_XBYAK OFF)
set(REX_OPTION_INI OFF)
set(REX_OPTION_JSON OFF)
set(REX_OPTION_TOML OFF)

option(COPY_BUILD_TO_PARENT "Copy the built to the parent directory" ON)
option(COPY_BUILD_TO_F4SE "Copy the built to F4SE's plugin directory" OFF)

# --- Output Path ---

if(COPY_BUILD_TO_F4SE AND COPY_BUILD_TO_PARENT)
	message(WARNING "COPY_BUILD_TO_F4SE and COPY_BUILD_TO_PARENT should not be enabled at the same time.")
endif()

if (COPY_BUILD_TO_PARENT)
	set(OUTPUT_PATH "${CMAKE_CURRENT_LIST_DIR}/..")
elseif(COPY_BUILD_TO_PARENT)
	set_from_environment(FO4_ROOT)

	if (NOT DEFINED FO4_ROOT)
		message(FATAL_ERROR "The environment variable FO4_ROOT is not set.")
	endif()

	set(OUTPUT_PATH "${FO4_ROOT}/Data/F4SE/Plugins")
endif()

# --- Add Sources ---

file(
	GLOB_RECURSE
	SOURCES
	CONFIGURE_DEPENDS
		"${CMAKE_CURRENT_SOURCE_DIR}/include/*.h"
		"${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp"
		"${CMAKE_CURRENT_SOURCE_DIR}/src/*.h"
		"${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp"
		"${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
)

list(
	REMOVE_ITEM
	SOURCES
	"${CMAKE_CURRENT_SOURCE_DIR}/include/PCH.hpp"
)

set(PLUGIN_HEADER
	"${CMAKE_CURRENT_BINARY_DIR}/include/Plugin.hpp"
)

set(VERSION_HEADER
	"${CMAKE_CURRENT_BINARY_DIR}/Version.rc"
)

source_group(
	TREE "${CMAKE_CURRENT_SOURCE_DIR}"
	FILES "${SOURCES}"
)

source_group(
	TREE "${CMAKE_CURRENT_BINARY_DIR}"
	FILES "${PLUGIN_HEADER}"
)

configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/Plugin.hpp.in"
	"${PLUGIN_HEADER}"
	@ONLY
)

configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/Version.rc.in"
	"${VERSION_HEADER}"
	@ONLY
)

# --- Include ---

if(NOT TARGET CommonLibF4)
	add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/extern/CommonLibF4" CommonLibF4)
endif()

add_library(
	"${PROJECT_NAME}"
	SHARED
		"${SOURCES}"
		"${PLUGIN_HEADER}"
		"${VERSION_HEADER}"
)

target_include_directories(
	"${PROJECT_NAME}"
	PRIVATE
		"${CMAKE_CURRENT_BINARY_DIR}/include"
		"${CMAKE_CURRENT_SOURCE_DIR}/include"
		"${CMAKE_CURRENT_SOURCE_DIR}/src"
)

target_precompile_headers(
	"${PROJECT_NAME}"
	PRIVATE
		"${CMAKE_CURRENT_SOURCE_DIR}/include/PCH.hpp"
)

# --- Link ---

target_link_libraries(
	"${PROJECT_NAME}"
	PRIVATE
		CommonLibF4::CommonLibF4
)

# --- Copy Output ---

if(DEFINED OUTPUT_PATH)
	add_custom_command(
		TARGET "${PROJECT_NAME}"
		POST_BUILD
			COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_FILE:${PROJECT_NAME}>" "${OUTPUT_PATH}/$<TARGET_FILE_NAME:${PROJECT_NAME}>"
			COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_PDB_FILE:${PROJECT_NAME}>" "${OUTPUT_PATH}/$<TARGET_PDB_FILE_NAME:${PROJECT_NAME}>"
	)
endif()
