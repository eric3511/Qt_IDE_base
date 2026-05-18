add_subdirectory(3rdparty)
add_subdirectory(aggregation)
add_subdirectory(utils)
add_subdirectory(extensionsystem)
add_subdirectory(advanceddockingsystem)

# 添加qwindowkit
include(FetchContent)
FetchContent_Declare(
    qwindowkit
    GIT_REPOSITORY https://github.com/stdware/qwindowkit.git
    GIT_TAG        1.5.0 # 或者 main
)
FetchContent_MakeAvailable(qwindowkit)

# ==========================================
# 配置 Install 规则 (完整版)
# ==========================================

# 1. 把截图里出现的所有库的 Target 名字都加上
set(EXPORT_TARGETS
    Utils
    ExtensionSystem
    Aggregation
    QWKCore
    QWKWidgets
    AdvancedDockingSystem
    KSyntaxHighlighting
    3rd_cplusplus
)

# 导出二进制文件 (.dll, .lib, .so)
install(TARGETS ${EXPORT_TARGETS}
    EXPORT MyIDESDKTargets
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# ==========================================
# 2. 导出头文件 (必须把新增库的头文件也导出去，否则别人没法 include)
# ==========================================

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/utils/
    DESTINATION include/utils
    FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extensionsystem/
    DESTINATION include/extensionsystem
    FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/aggregation/
    DESTINATION include/aggregation
    FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/advanceddockingsystem/
    DESTINATION include/advanceddockingsystem
    FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/
    DESTINATION include/3rdparty
    FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)

install(DIRECTORY ${qwindowkit_SOURCE_DIR}/include/
    DESTINATION include/qwindowkit
    FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)
