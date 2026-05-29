add_qtc_executable(MyIDE
  DEPENDS
    ExtensionSystem
    Utils
    Aggregation
    AdvancedDockingSystem
    Qt6::Widgets
  SOURCES
    main.cpp
)

install(TARGETS MyIDE
    RUNTIME DESTINATION bin
)
