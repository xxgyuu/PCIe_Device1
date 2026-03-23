@echo off
echo ========================================
echo Redfish API 测试环境检查脚本
echo ========================================
echo.

echo [1/5] 检查系统环境...
echo 系统版本:
ver
echo.

echo [2/5] 检查Python环境...
where python >nul 2>nul
if errorlevel 1 (
    echo ❌ 未找到Python
    echo.
    echo 解决方案:
    echo   1. 下载Python: https://www.python.org/downloads/
    echo   2. 安装时勾选 "Add Python to PATH"
    echo   3. 或手动设置PATH，例如:
    echo      set PATH=C:\Python39;C:\Python39\Scripts;%%PATH%%
    echo.
) else (
    echo ✅ 找到Python
    python --version
)

echo.
echo [3/5] 检查Python版本...
python -c "import sys; print('Python版本:', sys.version)" 2>nul
if errorlevel 1 (
    echo ❌ Python无法运行
) else (
    python -c "import sys; exit(0 if sys.version_info >= (3, 6) else 1)" >nul 2>nul
    if errorlevel 1 (
        echo ❌ 需要Python 3.6或更高版本
    ) else (
        echo ✅ Python版本符合要求
    )
)

echo.
echo [4/5] 检查pip...
python -m pip --version >nul 2>nul
if errorlevel 1 (
    echo ❌ pip不可用
    echo 尝试修复: python -m ensurepip --upgrade
) else (
    echo ✅ pip可用
    python -m pip --version
)

echo.
echo [5/5] 检查项目文件...
if exist requirements.txt (
    echo ✅ requirements.txt 存在
) else (
    echo ❌ requirements.txt 不存在
)

if exist testcases\test_pcie_device.robot (
    echo ✅ 测试文件存在
) else (
    echo ❌ 测试文件不存在
)

echo.
echo ========================================
echo 检查完成！
echo ========================================
echo.
echo 如果环境检查失败，请:
echo 1. 安装Python 3.6+
echo 2. 确保Python已添加到PATH
echo 3. 重新运行此检查脚本
echo.
echo 在Jenkins中，可以通过以下方式配置:
echo - 在节点上安装Python
echo - 使用Jenkins的Python工具插件
echo - 在批处理脚本开头设置PATH
echo.
pause