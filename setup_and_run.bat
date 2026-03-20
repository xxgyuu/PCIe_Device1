@echo off
echo ========================================
echo Redfish API 测试框架安装与运行脚本
echo ========================================
echo 环境要求:
echo   - Python 3.6+
echo   - 网络连接 (用于安装依赖)
echo ========================================

echo 检查Python环境...
where python >nul 2>nul
if errorlevel 1 (
    echo 错误: 未找到Python，请确保Python已安装并添加到PATH
    echo.
    echo 在Jenkins中配置Python:
    echo   1. 安装Python 3.x (勾选'Add Python to PATH')
    echo   2. 或在批处理文件开头设置PATH，例如:
    echo      set PATH=C:\Python39;C:\Python39\Scripts;%%PATH%%
    exit /b 1
)

echo 检查Python版本...
python -c "import sys; exit(0 if sys.version_info >= (3, 6) else 1)" >nul 2>nul
if errorlevel 1 (
    echo 错误: 需要Python 3.6或更高版本
    python --version
    exit /b 1
)

python --version

echo 正在安装Python依赖...
python -m pip install -r requirements.txt

if errorlevel 1 (
    echo 错误: 依赖安装失败
    echo 请检查:
    echo   1. requirements.txt文件是否存在
    echo   2. 网络连接是否正常
    echo   3. pip是否可用 (尝试: python -m pip --version)
    exit /b 1
)

echo.
echo 依赖安装成功！
echo.
echo 正在运行PCIeDevice接口测试...
echo.

echo 检查测试文件...
if not exist "testcases\run_all_tests.robot" (
    echo 错误: 未找到测试文件 testcases\run_all_tests.robot
    exit /b 1
)

echo 检查robot命令...
where robot >nul 2>nul
if errorlevel 1 (
    echo robot命令不在PATH中，尝试使用python -m robot...
    set ROBOT_CMD=python -m robot
) else (
    set ROBOT_CMD=robot
)

echo 执行测试...
%ROBOT_CMD% --outputdir results --log log.html --report report.html testcases/run_all_tests.robot

if errorlevel 1 (
    echo.
    echo 测试执行完成，但有失败用例
    exit /b 1
) else (
    echo.
    echo 所有测试通过！
)

echo.
echo 测试报告已生成到 results/ 目录
echo.