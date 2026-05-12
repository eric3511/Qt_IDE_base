cmake_minimum_required(VERSION 3.16)
## 添加模块路径
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
## 包含Utils模块
include(Utils)
include(FeatureSummary)
include(QtCreatorIDEBranding RESULT_VARIABLE IDE_BRANDING_FILE)
include(QtCreatorAPI)

set(IDE_REVISION FALSE CACHE BOOL "Marks the presence of IDE revision string.")
set(IDE_REVISION_STR "" CACHE STRING "The IDE revision string.")
set(IDE_REVISION_URL "" CACHE STRING "The IDE revision Url string.")
mark_as_advanced(IDE_REVISION IDE_REVISION_STR IDE_REVISION_URL)
project(MyIDE VERSION ${IDE_VERSION})

## C++标准设置
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
##  禁用了编译器特定的扩展（如 GNU 的 gnu++17）
set(CMAKE_CXX_EXTENSIONS OFF)


## 检查工具
option(WITH_SANITIZE "Build with sanitizer enabled" OFF)
set(SANITIZE_FLAGS "" CACHE STRING "Sets flags for sanitizer compilation flags used in Debug builds")
add_feature_info("Build with sanitize" ${WITH_SANITIZE} "SANITIZE_FLAGS='${SANITIZE_FLAGS}'")


#set(QTC_MERGE_BINARY_DIR ON)
## 当前目录的源码目录和构建目录自动加入头文件搜索路径
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 查找 Qt 6 (替换了原版冗长的 Qt5/Qt6 兼容逻辑)
# ExtensionSystem 主要依赖 Core, Gui, Widgets, Xml
find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Xml Network Qml Core5Compat)


# 集中管理编译输出目录 (极其重要！)
# 这会让生成的 .dll/.so 和插件都放在同一个 bin 目录下，避免运行时找不到动态库
set(QTC_MERGE_BINARY_DIR ON)

# 屏蔽 MSVC 的一些烦人警告
if(MSVC)
  add_compile_options(/wd4573 /permissive- /Zc:__cplusplus)
  # Debug 模式下使用多线程动态运行时
  if (QT_FEATURE_static_runtime)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
  endif()
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL GNU)
  add_compile_options(-Wno-missing-field-initializers)
endif()

# 进入源码目录编译
add_subdirectory(src)

# 打印配置摘要
feature_summary(INCLUDE_QUIET_PACKAGES WHAT ALL)
