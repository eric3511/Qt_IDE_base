# =====================================================================
# IDE 版本信息
# =====================================================================
set(IDE_VERSION "1.0.0")                              # 你的 IDE 内部版本号
set(IDE_VERSION_COMPAT "1.0.0")                       # 插件兼容的最低版本号
set(IDE_VERSION_DISPLAY "1.0.0")                      # UI 上显示的对外版本号
set(IDE_COPYRIGHT_YEAR "2026")                        # 版权年份

# =====================================================================
# 你的 IDE 品牌信息 (极其重要！)
# =====================================================================
# 这两个变量决定了 QSettings 的存储位置 (Windows 下的注册表路径，或 AppData 目录)
set(IDE_SETTINGSVARIANT "MyCompany")                  # 对应 QSettings 的 Organization (组织名)
set(IDE_CASED_ID "MyIDE")                          # 对应 QSettings 的 Application (应用名)

set(IDE_DISPLAY_NAME "MyIDEBase")                    # 你的 IDE 名字 (显示在主窗口标题栏)
set(IDE_ID "myplcide")                                # 纯小写 ID (决定了插件存放的文件夹名，如 lib/myplcide/plugins)
set(IDE_BUNDLE_IDENTIFIER "com.mycompany.${IDE_ID}")  # Mac 下的包名

# =====================================================================
# 杂项配置
# =====================================================================
# 你的 IDE 专属的本地用户配置文件后缀 (Qt Creator 是 .user，你可以改成你自己的)
set(PROJECT_USER_FILE_EXTENSION .user_info)

# 图标路径 (前期剥离阶段直接留空即可，等你的主程序跑起来了再加)
set(IDE_ICON_PATH "")
set(IDE_LOGO_PATH "")

# 删除了原版中关于 qdocconf (Qt 文档生成器) 的配置，因为你不需要
