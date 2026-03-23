@echo off
echo ========================================
echo Robot Framework测试框架依赖安装
echo ========================================

echo 检查Python环境...
where python >nul 2>nul
if errorlevel 1 (
    echo 错误: 未找到Python
    echo 请确保Python已安装并添加到PATH
    echo 或在批处理文件开头设置PATH，例如:
    echo   set PATH=C:\Python39;C:\Python39\Scripts;%%PATH%%
    pause
    exit /b 1
)

echo 正在安装依赖...
echo.

python -m pip install robotframework
if errorlevel 1 goto error

python -m pip install robotframework-requests
if errorlevel 1 goto error

python -m pip install robotframework-jsonlibrary
if errorlevel 1 goto error

python -m pip install requests
if errorlevel 1 goto error

echo.
echo ========================================
echo 所有依赖安装成功！
echo ========================================
echo.
echo 要运行测试，请执行：
echo   setup_and_run.bat
echo 或
echo   robot testcases/test_pcie_device.robot
echo.
echo 在Jenkins环境中，确保Python已正确配置
echo.
pause
exit /b 0

:error
echo.
echo ========================================
echo 依赖安装失败
echo ========================================
echo 可能的原因:
echo 1. 网络连接问题
echo 2. pip版本过旧 (尝试: python -m pip install --upgrade pip)
echo 3. Python环境问题
echo.
echo 解决方案:
echo 1. 检查网络连接
echo 2. 使用国内镜像源:
echo    python -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
echo.
pause
exit /b 1