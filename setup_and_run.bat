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
where python >nul 2>nul
if not errorlevel 1 (
    set PYTHON_CMD=python
)

REM If not found, try python3
if not defined PYTHON_CMD (
    where python3 >nul 2>nul
    if not errorlevel 1 (
        set PYTHON_CMD=python3
    )
)

REM Try common installation paths
if not defined PYTHON_CMD (
    if exist "C:\Python311\python.exe" (
        set PYTHON_CMD=C:\Python311\python.exe
        set PATH=C:\Python311;C:\Python311\Scripts;%PATH%
    )
)

if not defined PYTHON_CMD (
    if exist "C:\Python310\python.exe" (
        set PYTHON_CMD=C:\Python310\python.exe
        set PATH=C:\Python310;C:\Python310\Scripts;%PATH%
    )
)

if not defined PYTHON_CMD (
    if exist "C:\Python39\python.exe" (
        set PYTHON_CMD=C:\Python39\python.exe
        set PATH=C:\Python39;C:\Python39\Scripts;%PATH%
    )
)

REM Check Program Files for Python installations
if not defined PYTHON_CMD (
    if exist "C:\Program Files\Python311\python.exe" (
        set PYTHON_CMD=C:\Program Files\Python311\python.exe
        set PATH=C:\Program Files\Python311;C:\Program Files\Python311\Scripts;%PATH%
    )
)

if not defined PYTHON_CMD (
    if exist "C:\Program Files\Python310\python.exe" (
        set PYTHON_CMD=C:\Program Files\Python310\python.exe
        set PATH=C:\Program Files\Python310;C:\Program Files\Python310\Scripts;%PATH%
    )
)

REM Check for Python in Program Files (x86)
if not defined PYTHON_CMD (
    if exist "C:\Program Files (x86)\Python311\python.exe" (
        set PYTHON_CMD=C:\Program Files (x86)\Python311\python.exe
        set PATH=C:\Program Files (x86)\Python311;C:\Program Files (x86)\Python311\Scripts;%PATH%
    )
)

REM Allow override via environment variable
if not defined PYTHON_CMD (
    if defined PYTHON_HOME (
        if exist "%PYTHON_HOME%\python.exe" (
            set PYTHON_CMD=%PYTHON_HOME%\python.exe
            set PATH=%PYTHON_HOME%;%PYTHON_HOME%\Scripts;%PATH%
        )
    )
)

REM If still not found, check user-specific paths (for non-Jenkins environments)
if not defined PYTHON_CMD (
    if exist "C:\Users\xys47339\AppData\Local\Programs\Python\Python311\python.exe" (
        set PYTHON_CMD=C:\Users\xys47339\AppData\Local\Programs\Python\Python311\python.exe
        set PATH=C:\Users\xys47339\AppData\Local\Programs\Python\Python311;C:\Users\xys47339\AppData\Local\Programs\Python\Python311\Scripts;%PATH%
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
    exit /b 1
)

echo Found Python at: %PYTHON_CMD%

echo Checking Python version...
python -c "import sys; exit(0 if sys.version_info >= (3, 6) else 1)" >nul 2>nul
if errorlevel 1 (
    echo Error: Python 3.6 or higher is required
    python --version
    exit /b 1
)

python --version

echo Installing Python dependencies...
python -m pip install -r requirements.txt

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
    echo robot command not in PATH, trying python -m robot...
    set ROBOT_CMD=python -m robot
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
