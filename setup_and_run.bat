@echo off
REM ========================================
REM Redfish API test framework installation and running script
REM ========================================

echo Environment requirements:
echo   - Python 3.6+
echo   - Network connection (for installing dependencies)
echo ========================================

echo Checking Python environment...

REM Try to find Python in common locations
set PYTHON_CMD=

REM First, try where command to find Python in PATH
echo Checking PATH for python...
where python 2>nul
if not errorlevel 1 (
    for /f "delims=" %%i in ('where python 2^>nul') do (
        set PYTHON_CMD=%%i
        goto :found_python
    )
)
:found_python
if defined PYTHON_CMD (
    echo Found python at: %PYTHON_CMD%
) else (
    echo Python not found in PATH
)

REM If not found, try python3
if not defined PYTHON_CMD (
    echo Checking PATH for python3...
    where python3 2>nul
    if not errorlevel 1 (
        for /f "delims=" %%i in ('where python3 2^>nul') do (
            set PYTHON_CMD=%%i
            goto :found_python3
        )
    )
)
:found_python3
if defined PYTHON_CMD (
    echo Found python3 at: %PYTHON_CMD%
)

REM Try common installation paths
if not defined PYTHON_CMD (
    echo Checking common Python installation paths...
    for %%p in (
        C:\Python311\python.exe,
        C:\Python310\python.exe,
        C:\Python39\python.exe,
        "C:\Program Files\Python311\python.exe",
        "C:\Program Files\Python310\python.exe",
        "C:\Program Files\Python39\python.exe",
        "C:\Program Files (x86)\Python311\python.exe",
        "C:\Program Files (x86)\Python310\python.exe"
    ) do (
        if exist %%p (
            set PYTHON_CMD=%%p
            goto :found_python_path
        )
    )
)
:found_python_path
if defined PYTHON_CMD (
    echo Found Python at: %PYTHON_CMD%
)

REM Allow override via environment variable
if not defined PYTHON_CMD (
    if defined PYTHON_HOME (
        echo Checking PYTHON_HOME environment variable...
        if exist "%PYTHON_HOME%\python.exe" (
            set PYTHON_CMD=%PYTHON_HOME%\python.exe
            set PATH=%PYTHON_HOME%;%PYTHON_HOME%\Scripts;%PATH%
        )
    )
)

if not defined PYTHON_CMD (
    echo Error: Python not found in any of the expected locations
    echo.
    echo Please configure Python using one of these methods:
    echo   1. Install Python 3.x system-wide (e.g., C:\Python311)
    echo   2. Set PYTHON_HOME environment variable to Python installation directory
    echo   3. Add Python to Jenkins environment variables
    echo   4. Use Jenkins "Python" tool configuration
    echo.
    echo Current PATH: %PATH%
    echo.
    echo Debug info:
    where python 2>nul || echo python not found in PATH
    where python3 2>nul || echo python3 not found in PATH
    exit /b 1
)

echo Found Python at: %PYTHON_CMD%

echo Checking Python version...
%PYTHON_CMD% -c "import sys; exit(0 if sys.version_info >= (3, 6) else 1)" >nul 2>nul
if errorlevel 1 (
    echo Error: Python 3.6 or higher is required
    %PYTHON_CMD% --version
    exit /b 1
)

%PYTHON_CMD% --version

echo Installing Python dependencies...
%PYTHON_CMD% -m pip install -r requirements.txt

if errorlevel 1 (
    echo Error: Dependency installation failed
    echo Please check:
    echo   1. requirements.txt file exists
    echo   2. Network connection is normal
    echo   3. pip is available (try: python -m pip --version)
    exit /b 1
)

echo.
echo Dependencies installed successfully!
echo.
echo Running PCIeDevice interface test...
echo.

echo Checking test files...
if not exist "testcases\run_all_tests.robot" (
    echo Error: Test file testcases\run_all_tests.robot not found
    exit /b 1
)

echo Checking robot command...
where robot >nul 2>nul
if errorlevel 1 (
    echo robot command not in PATH, trying %PYTHON_CMD% -m robot...
    set ROBOT_CMD=%PYTHON_CMD% -m robot
) else (
    set ROBOT_CMD=robot
)

echo Executing test...
%ROBOT_CMD% --outputdir results --log log.html --report report.html testcases/run_all_tests.robot

if errorlevel 1 (
    echo.
    echo Test execution completed, but there are failed test cases
    exit /b 1
) else (
    echo.
    echo All tests passed!
)

echo.
echo Test report generated in results/ directory
echo.
