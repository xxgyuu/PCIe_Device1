@echo off
REM ========================================
REM Jenkins环境设置示例脚本
REM 根据实际环境修改此脚本
REM ========================================

echo 设置Jenkins构建环境...
echo.

REM ========================================
REM 方法1: 如果Python已安装但不在PATH中
REM ========================================
echo [方法1] 设置Python路径（根据实际安装位置修改）

REM 常见Python安装路径
set PYTHON_PATHS=^
C:\Python39;^
C:\Python39\Scripts;^
C:\Python310;^
C:\Python310\Scripts;^
C:\Program Files\Python39;^
C:\Program Files\Python39\Scripts;^
C:\Program Files\Python310;^
C:\Program Files\Python310\Scripts;^
C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python39;^
C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python39\Scripts;^
C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python310;^
C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python310\Scripts

REM 检查Python是否在常见路径中
set PYTHON_FOUND=false
for %%p in (%PYTHON_PATHS%) do (
    if exist "%%p\python.exe" (
        echo 找到Python: %%p
        set PATH=%%p;%PATH%
        set PYTHON_FOUND=true
    )
)

if "%PYTHON_FOUND%"=="false" (
    echo 未在常见路径中找到Python
    echo.
    echo ========================================
    echo 解决方案:
    echo 1. 在Jenkins节点安装Python 3.6+
    echo 2. 安装时勾选 "Add Python to PATH"
    echo 3. 或在此脚本中设置正确的Python路径
    echo.
    echo 安装Python后，重新运行构建
    echo ========================================
    exit /b 1
)

echo.
echo [方法2] 使用Jenkins Python工具（如已配置）
echo 如果使用Jenkins的Python工具插件，可以:
echo 1. Jenkins管理 → 全局工具配置 → 添加Python
echo 2. 在构建步骤中引用Python工具
echo 3. 不需要手动设置PATH

echo.
echo [方法3] 使用便携版Python
echo 可以将Python便携版放入项目目录:
echo 1. 下载Python便携版
echo 2. 解压到项目目录（如 python_portable/）
echo 3. 设置PATH:
echo    set PATH=%~dp0python_portable;%~dp0python_portable\Scripts;%PATH%

echo.
echo ========================================
echo 环境设置完成
echo ========================================
echo.
echo 检查Python:
python --version
python -m pip --version

echo.
echo 运行测试框架:
call setup_and_run.bat