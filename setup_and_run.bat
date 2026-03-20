@echo off
echo ========================================
echo Redfish API 测试框架安装与运行脚本
echo ========================================

echo 正在安装Python依赖...
pip install -r requirements.txt

if errorlevel 1 (
    echo 依赖安装失败，请检查Python环境
    pause
    exit /b 1
)

echo.
echo 依赖安装成功！
echo.
echo 正在运行PCIeDevice接口测试...
echo.

robot --outputdir results --log log.html --report report.html testcases/run_all_tests.robot

if errorlevel 1 (
    echo.
    echo 测试执行完成，但有失败用例
) else (
    echo.
    echo 所有测试通过！
)

echo.
echo 测试报告已生成到 results/ 目录
echo.
pause