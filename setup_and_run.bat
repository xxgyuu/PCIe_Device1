@echo off
setlocal enabledelayedexpansion
REM ========================================
REM Redfish API test framework installation and running script (Fixed for Jenkins)
REM ========================================

echo Environment requirements:
echo   - Python 3.6+
echo   - Network connection (for installing dependencies)
echo ========================================

:: 强制展开环境变量，防止 Jenkins 传入的 PATH 包含未解析的 %PATH%
set PATH=%PATH%

echo Checking Python environment...

set PYTHON_CMD=

REM 1. 首先尝试 PATH 中的 python
where python >nul 2>nul
if not errorlevel 1 (
    for /f "delims=" %%i in ('where python 2^>nul') do (
        set "PYTHON_CMD=%%i"
        goto :found_python_path
    )
)

REM 2. 尝试 PATH 中的 python3
where python3 >nul 2>nul
if not errorlevel 1 (
    for /f "delims=" %%i in ('where python3 2^>nul') do (
        set "PYTHON_CMD=%%i"
        goto :found_python_path
    )
)

REM 3. 尝试硬编码的常见路径
echo Checking common Python installation paths...
for %%p in (
    "C:\Python311\python.exe",
    "C:\Python310\python.exe",
    "C:\Python39\python.exe",
    "C:\Program Files\Python311\python.exe",
    "C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python311\python.exe",
    "C:\Users\xys47339\AppData\Local\Programs\Python\Python311\python.exe"
) do (
    if exist %%p (
        set "PYTHON_CMD=%%p"
        goto :found_python_path
    )
)

REM 4. 尝试 PYTHON_HOME
if defined PYTHON_HOME (
    if exist "%PYTHON_HOME%\python.exe" (
        set "PYTHON_CMD=%PYTHON_HOME%\python.exe"
        goto :found_python_path
    )
)

REM --- 如果走到这里还没找到，报错退出 ---
echo Error: Python not found in any of the expected locations.
echo Current PATH: %PATH%
exit /b 1

:found_python_path
echo ========================================
echo Success: Found Python at: %PYTHON_CMD%
echo ========================================

echo Checking Python version...
"%PYTHON_CMD%" -c "import sys; exit(0 if sys.version_info >= (3, 6) else 1)" >nul 2>nul
if errorlevel 1 (
    echo Error: Python 3.6 or higher is required.
    "%PYTHON_CMD%" --version
    exit /b 1
)

"%PYTHON_CMD%" --version

echo Installing Python dependencies...
"%PYTHON_CMD%" -m pip install -r requirements.txt
if errorlevel 1 (
    echo Error: Dependency installation failed.
    exit /b 1
)

echo.
echo Dependencies installed successfully!
echo.
echo Running PCIeDevice interface test...

echo Checking test files...
if not exist "testcases\run_all_tests.robot" (
    echo Error: Test file testcases\run_all_tests.robot not found.
    exit /b 1
)

:: 核心修正：在 Jenkins 系统环境下，优先使用 python -m 方式运行 robot
echo Executing test via %PYTHON_CMD% -m robot...
"%PYTHON_CMD%" -m robot --outputdir results --log log.html --report report.html testcases/run_all_tests.robot

if errorlevel 1 (
    echo.
    echo Test execution completed, but there are failed test cases.
    exit /b 1
) else (
    echo.
    echo All tests passed!
)

echo.
echo Test report generated in results/ directory.
endlocal