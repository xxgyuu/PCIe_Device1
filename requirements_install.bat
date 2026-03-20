@echo off
echo 正在安装Robot Framework测试框架依赖...
echo.

pip install robotframework
if errorlevel 1 goto error

pip install robotframework-requests
if errorlevel 1 goto error

pip install robotframework-jsonlibrary
if errorlevel 1 goto error

pip install requests
if errorlevel 1 goto error

echo.
echo 所有依赖安装成功！
echo.
echo 要运行测试，请执行：
echo   setup_and_run.bat
echo 或
echo   robot testcases/test_pcie_device.robot
echo.
pause
exit /b 0

:error
echo.
echo 依赖安装失败，请检查Python环境
pause
exit /b 1