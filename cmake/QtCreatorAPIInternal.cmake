# =====================================================================
# 基础定义与路径配置 (保留了极其优秀的跨平台路径和 RPATH 处理)
# =====================================================================
include(FeatureSummary)

# 默认编译宏
list(APPEND DEFAULT_DEFINES
  QT_NO_JAVA_STYLE_ITERATORS
  QT_NO_CAST_TO_ASCII QT_RESTRICTED_CAST_FROM_ASCII
  QT_USE_QSTRINGBUILDER
)

if (WIN32)
  list(APPEND DEFAULT_DEFINES UNICODE _UNICODE _CRT_SECURE_NO_WARNINGS)
  list(APPEND DEFAULT_DEFINES WINVER=0x0602 _WIN32_WINNT=0x0602 WIN32_LEAN_AND_MEAN)
endif()

# 跨平台输出目录配置 (非常重要，决定了你的 dll/so 和 plugins 生成到哪里)
if (APPLE)
  set(_IDE_APP_PATH ".")
  set(_IDE_APP_TARGET "${IDE_DISPLAY_NAME}")
  set(_IDE_OUTPUT_PATH "${_IDE_APP_TARGET}.app/Contents")
  set(_IDE_LIBRARY_BASE_PATH "Frameworks")
  set(_IDE_LIBRARY_PATH "${_IDE_OUTPUT_PATH}/${_IDE_LIBRARY_BASE_PATH}")
  set(_IDE_PLUGIN_PATH "${_IDE_OUTPUT_PATH}/PlugIns")
  set(_IDE_LIBEXEC_PATH "${_IDE_OUTPUT_PATH}/Resources/libexec")
  set(_IDE_DATA_PATH "${_IDE_OUTPUT_PATH}/Resources")
  set(_IDE_DOC_PATH "${_IDE_OUTPUT_PATH}/Resources/doc")
  set(_IDE_BIN_PATH "${_IDE_OUTPUT_PATH}/MacOS")
  set(_IDE_LIBRARY_ARCHIVE_PATH "${_IDE_LIBRARY_PATH}")
elseif(WIN32)
  set(_IDE_APP_PATH "bin")
  set(_IDE_APP_TARGET "${IDE_ID}")
  set(_IDE_LIBRARY_BASE_PATH "lib")
  set(_IDE_LIBRARY_PATH "${_IDE_LIBRARY_BASE_PATH}/${IDE_ID}")
  set(_IDE_PLUGIN_PATH "${_IDE_LIBRARY_BASE_PATH}/${IDE_ID}/plugins")
  set(_IDE_LIBEXEC_PATH "bin")
  set(_IDE_DATA_PATH "share/${IDE_ID}")
  set(_IDE_DOC_PATH "share/doc/${IDE_ID}")
  set(_IDE_BIN_PATH "bin")
  set(_IDE_LIBRARY_ARCHIVE_PATH "${_IDE_BIN_PATH}")
else ()
  include(GNUInstallDirs)
  set(_IDE_APP_PATH "${CMAKE_INSTALL_BINDIR}")
  set(_IDE_APP_TARGET "${IDE_ID}")
  set(_IDE_LIBRARY_BASE_PATH "${CMAKE_INSTALL_LIBDIR}")
  set(_IDE_LIBRARY_PATH "${_IDE_LIBRARY_BASE_PATH}/${IDE_ID}")
  set(_IDE_PLUGIN_PATH "${_IDE_LIBRARY_BASE_PATH}/${IDE_ID}/plugins")
  set(_IDE_LIBEXEC_PATH "${CMAKE_INSTALL_LIBEXECDIR}/${IDE_ID}")
  set(_IDE_DATA_PATH "${CMAKE_INSTALL_DATAROOTDIR}/${IDE_ID}")
  set(_IDE_DOC_PATH "${CMAKE_INSTALL_DATAROOTDIR}/doc/${IDE_ID}")
  set(_IDE_BIN_PATH "${CMAKE_INSTALL_BINDIR}")
  set(_IDE_LIBRARY_ARCHIVE_PATH "${_IDE_LIBRARY_PATH}")
endif ()

file(RELATIVE_PATH _PLUGIN_TO_LIB "/${_IDE_PLUGIN_PATH}" "/${_IDE_LIBRARY_PATH}")
file(RELATIVE_PATH _PLUGIN_TO_QT "/${_IDE_PLUGIN_PATH}" "/${_IDE_LIBRARY_BASE_PATH}/Qt/lib")
file(RELATIVE_PATH _LIB_TO_QT "/${_IDE_LIBRARY_PATH}" "/${_IDE_LIBRARY_BASE_PATH}/Qt/lib")

if (APPLE)
  set(_RPATH_BASE "@executable_path")
  set(_LIB_RPATH "@loader_path")
  set(_PLUGIN_RPATH "@loader_path;@loader_path/${_PLUGIN_TO_LIB}")
elseif (WIN32)
  set(_RPATH_BASE "")
  set(_LIB_RPATH "")
  set(_PLUGIN_RPATH "")
else()
  set(_RPATH_BASE "\$ORIGIN")
  set(_LIB_RPATH "\$ORIGIN;\$ORIGIN/${_LIB_TO_QT}")
  set(_PLUGIN_RPATH "\$ORIGIN;\$ORIGIN/${_PLUGIN_TO_LIB};\$ORIGIN/${_PLUGIN_TO_QT}")
endif ()

# =====================================================================
# 核心辅助函数
# =====================================================================

function(qtc_add_link_flags_no_undefined target)
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.18)
    include(CheckLinkerFlag)
    set(no_undefined_flag "-Wl,--no-undefined")
    check_linker_flag(CXX ${no_undefined_flag} QTC_LINKER_SUPPORTS_NO_UNDEFINED)
    if (NOT QTC_LINKER_SUPPORTS_NO_UNDEFINED)
        set(no_undefined_flag "-Wl,-undefined,error")
        check_linker_flag(CXX ${no_undefined_flag} QTC_LINKER_SUPPORTS_UNDEFINED_ERROR)
        if (NOT QTC_LINKER_SUPPORTS_UNDEFINED_ERROR)
            return()
        endif()
    endif()
    target_link_options("${target}" PRIVATE "${no_undefined_flag}")
  endif()
endfunction()

function(append_extra_translations target_name)
  if(NOT ARGN)
    return()
  endif()
  if(TARGET "${target_name}")
    get_target_property(_input "${target_name}" QT_EXTRA_TRANSLATIONS)
    if (_input)
      set(_output "${_input}" "${ARGN}")
    else()
      set(_output "${ARGN}")
    endif()
    set_target_properties("${target_name}" PROPERTIES QT_EXTRA_TRANSLATIONS "${_output}")
  endif()
endfunction()

function(set_explicit_moc target_name file)
  unset(file_dependencies)
  if (file MATCHES "^.*plugin.h$")
    set(file_dependencies DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${target_name}.json")
  endif()
  set_property(SOURCE "${file}" PROPERTY SKIP_AUTOMOC ON)
  # 【关键修复】：升级为 Qt 6 的 qt6_wrap_cpp
  qt6_wrap_cpp(file_moc "${file}" ${file_dependencies})
  target_sources(${target_name} PRIVATE "${file_moc}")
endfunction()

function(set_public_headers target sources)
  # 简化：剥离时通常不需要安装头文件，保持空实现或简单包含即可
endfunction()

function(update_resource_files_list sources)
  # 内部缓存列表更新，保留空实现防止报错
endfunction()

function(set_public_includes target includes)
  foreach(inc_dir IN LISTS includes)
    if (NOT IS_ABSOLUTE ${inc_dir})
      set(inc_dir "${CMAKE_CURRENT_SOURCE_DIR}/${inc_dir}")
    endif()
    target_include_directories(${target} PUBLIC $<BUILD_INTERFACE:${inc_dir}>)
  endforeach()
endfunction()

function(check_qtc_disabled_targets target_name dependent_targets)
  # 简化：假设所有依赖都开启
endfunction()

function(add_qtc_depends target_name)
  cmake_parse_arguments(_arg "" "" "PRIVATE;PUBLIC" ${ARGN})
  set(depends "${_arg_PRIVATE}")
  set(public_depends "${_arg_PUBLIC}")

  get_target_property(target_type ${target_name} TYPE)
  if (NOT target_type STREQUAL "OBJECT_LIBRARY")
    target_link_libraries(${target_name} PRIVATE ${depends} PUBLIC ${public_depends})
  else()
    list(APPEND object_lib_depends ${depends})
    list(APPEND object_public_depends ${public_depends})
  endif()

  foreach(obj_lib IN LISTS object_lib_depends)
    target_compile_options(${target_name} PRIVATE $<TARGET_PROPERTY:${obj_lib},INTERFACE_COMPILE_OPTIONS>)
    target_compile_definitions(${target_name} PRIVATE $<TARGET_PROPERTY:${obj_lib},INTERFACE_COMPILE_DEFINITIONS>)
    target_include_directories(${target_name} PRIVATE $<TARGET_PROPERTY:${obj_lib},INTERFACE_INCLUDE_DIRECTORIES>)
  endforeach()
  foreach(obj_lib IN LISTS object_public_depends)
    target_compile_options(${target_name} PUBLIC $<TARGET_PROPERTY:${obj_lib},INTERFACE_COMPILE_OPTIONS>)
    target_compile_definitions(${target_name} PUBLIC $<TARGET_PROPERTY:${obj_lib},INTERFACE_COMPILE_DEFINITIONS>)
    target_include_directories(${target_name} PUBLIC $<TARGET_PROPERTY:${obj_lib},INTERFACE_INCLUDE_DIRECTORIES>)
  endforeach()
endfunction()

function(find_dependent_plugins varName)
  set(_RESULT ${ARGN})
  foreach(i ${ARGN})
    if(NOT TARGET ${i})
      continue()
    endif()
    set(_dep)
    get_property(_dep TARGET "${i}" PROPERTY _arg_DEPENDS)
    if (_dep)
      find_dependent_plugins(_REC ${_dep})
      list(APPEND _RESULT ${_REC})
    endif()
  endforeach()
  if (_RESULT)
    list(REMOVE_DUPLICATES _RESULT)
    list(SORT _RESULT)
  endif()
  set("${varName}" ${_RESULT} PARENT_SCOPE)
endfunction()

# 【关键修复】：彻底干掉 PCH（预编译头）的复杂逻辑
# 因为剥离出来的项目没有 Qt Creator 原始的 PCH 文件，强行开启会导致编译失败
function(enable_pch target)
  # 留空，禁用 PCH
endfunction()

function(condition_info varName condition)
  if (NOT ${condition})
    set(${varName} "" PARENT_SCOPE)
  else()
    string(REPLACE ";" " " _contents "${${condition}}")
    set(${varName} "with CONDITION ${_contents}" PARENT_SCOPE)
  endif()
endfunction()

# =====================================================================
# 最核心的 Target 扩展函数 (处理源码、宏、依赖)
# =====================================================================
function(extend_qtc_target target_name)
  cmake_parse_arguments(_arg
    ""
    "SOURCES_PREFIX;SOURCES_PREFIX_FROM_TARGET;FEATURE_INFO"
    "CONDITION;DEPENDS;PUBLIC_DEPENDS;DEFINES;PUBLIC_DEFINES;INCLUDES;PUBLIC_INCLUDES;SOURCES;EXPLICIT_MOC;SKIP_AUTOMOC;EXTRA_TRANSLATIONS;PROPERTIES"
    ${ARGN}
  )

  if (NOT _arg_CONDITION)
    set(_arg_CONDITION ON)
  endif()
  if (NOT ${_arg_CONDITION})
    return()
  endif()

  if (_arg_SOURCES_PREFIX_FROM_TARGET)
    if (NOT TARGET ${_arg_SOURCES_PREFIX_FROM_TARGET})
      return()
    else()
      get_target_property(_arg_SOURCES_PREFIX ${_arg_SOURCES_PREFIX_FROM_TARGET} SOURCES_DIR)
    endif()
  endif()

  add_qtc_depends(${target_name}
    PRIVATE ${_arg_DEPENDS}
    PUBLIC ${_arg_PUBLIC_DEPENDS}
  )
  target_compile_definitions(${target_name}
    PRIVATE ${_arg_DEFINES}
    PUBLIC ${_arg_PUBLIC_DEFINES}
  )
  target_include_directories(${target_name} PRIVATE ${_arg_INCLUDES})

  set_public_includes(${target_name} "${_arg_PUBLIC_INCLUDES}")

  if (_arg_SOURCES_PREFIX)
    foreach(source IN LISTS _arg_SOURCES)
      list(APPEND prefixed_sources "${_arg_SOURCES_PREFIX}/${source}")
    endforeach()

    if (NOT IS_ABSOLUTE ${_arg_SOURCES_PREFIX})
      set(_arg_SOURCES_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/${_arg_SOURCES_PREFIX}")
    endif()
    target_include_directories(${target_name} PRIVATE $<BUILD_INTERFACE:${_arg_SOURCES_PREFIX}>)

    set(_arg_SOURCES ${prefixed_sources})
  endif()
  target_sources(${target_name} PRIVATE ${_arg_SOURCES})

  foreach(file IN LISTS _arg_EXPLICIT_MOC)
    set_explicit_moc(${target_name} "${file}")
  endforeach()

  foreach(file IN LISTS _arg_SKIP_AUTOMOC)
    set_property(SOURCE ${file} PROPERTY SKIP_AUTOMOC ON)
  endforeach()

  append_extra_translations(${target_name} "${_arg_EXTRA_TRANSLATIONS}")

  if (_arg_PROPERTIES)
    set_target_properties(${target_name} PROPERTIES ${_arg_PROPERTIES})
  endif()
endfunction()
