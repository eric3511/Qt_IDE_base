set(ads_SRCS
    ads_globals.cpp
    DockAreaTabBar.cpp
    DockAreaTitleBar.cpp
    DockAreaWidget.cpp
    DockContainerWidget.cpp
    DockManager.cpp
    DockOverlay.cpp
    DockSplitter.cpp
    DockWidget.cpp
    DockWidgetTab.cpp
    DockingStateReader.cpp
    DockFocusController.cpp
    ElidingLabel.cpp
    FloatingDockContainer.cpp
    FloatingDragPreview.cpp
    IconProvider.cpp
    DockComponentsFactory.cpp
    AutoHideSideBar.cpp
    AutoHideTab.cpp
    AutoHideDockContainer.cpp
    PushButton.cpp
    ResizeHandle.cpp
    ads.qrc
)

set(ads_HEADERS
    ads_globals.h
    DockAreaTabBar.h
    DockAreaTitleBar.h
    DockAreaTitleBar_p.h
    DockAreaWidget.h
    DockContainerWidget.h
    DockManager.h
    DockOverlay.h
    DockSplitter.h
    DockWidget.h
    DockWidgetTab.h
    DockingStateReader.h
    DockFocusController.h
    ElidingLabel.h
    FloatingDockContainer.h
    FloatingDragPreview.h
    IconProvider.h
    DockComponentsFactory.h
    AutoHideSideBar.h
    AutoHideTab.h
    AutoHideDockContainer.h
    PushButton.h
    ResizeHandle.h
)

if (UNIX AND NOT APPLE)
    list(APPEND ads_SRCS linux/FloatingWidgetTitleBar.cpp)
    list(APPEND ads_HEADERS linux/FloatingWidgetTitleBar.h)
endif()

# 使用你 IDE 的宏来构建库
add_qtc_library(AdvancedDockingSystem
  PUBLIC_DEPENDS Qt6::Core Qt6::Gui Qt6::Widgets
  SOURCES
    ${ads_SRCS}
    ${ads_HEADERS}
)

# 强制取消 IDE 框架强加的禁用 Java 风格迭代器的宏
if (MSVC)
    target_compile_options(AdvancedDockingSystem PRIVATE /UQT_NO_JAVA_STYLE_ITERATORS)
else()
    target_compile_options(AdvancedDockingSystem PRIVATE -UQT_NO_JAVA_STYLE_ITERATORS)
endif()


# 导出动态库符号 (对应 QtADS 原本的 ADS_SHARED_EXPORT)
extend_qtc_target(AdvancedDockingSystem DEFINES ADS_SHARED_EXPORT)

if(UNIX AND NOT APPLE)
    extend_qtc_target(AdvancedDockingSystem PUBLIC_DEPENDS xcb)
    # 如果是 Qt6，可能还需要 GuiPrivate
    if (TARGET Qt6::GuiPrivate)
        extend_qtc_target(AdvancedDockingSystem DEPENDS Qt6::GuiPrivate)
    endif()
endif()
