@echo off
setlocal

rem ==============================
rem ✅ 用户配置部分
rem 请确认 VS2022 安装路径是否正确
set VS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community

rem 请确认 OWT 项目的 src 目录
set SRC_DIR=D:\code\work\owt-client-native\src
rem ==============================

rem 设置绕过 depot_tools 的默认 VS2019 toolchain
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set GYP_MSVS_VERSION=2022
set GYP_MSVS_OVERRIDE_PATH=%VS_PATH%

rem 进入工程目录
cd /d %SRC_DIR%

rem 创建伪 clang 版本 stamp 文件，避免 clang 检查失败
mkdir third_party\llvm-build\Release+Asserts >nul 2>nul
echo llvmorg-16-init-6578-g0d30e92f-1 > third_party\llvm-build\Release+Asserts\cr_build_revision

rem 执行 gn gen
gn gen out\Default --ide=vs --args="is_debug=true rtc_include_tests=false use_custom_libcxx=false treat_warnings_as_errors=false use_mfx=false use_ffmpeg=false rtc_include_ilbc=false"

if %errorlevel% neq 0 (
    echo ❌ 生成失败，请检查环境变量或 Python/Clang 缺失
    pause
    exit /b 1
)

echo ✅ 生成完成：%SRC_DIR%\out\Default\all.sln
echo 🔍 可用 VS 打开查看项目源码
pause
