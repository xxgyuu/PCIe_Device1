@echo off
REM Set Python path (modify according to actual installation location)
set PATH=C:\Users\xys47339\AppData\Local\Programs\Python\Python311;C:\Users\xys47339\AppData\Local\Programs\Python\Python311\Scripts;%PATH%

echo ========================================
echo Redfish API test framework installation and running script
echo ========================================
echo Environment requirements:
echo   - Python 3.6+
echo   - Network connection (for installing dependencies)
echo ========================================

echo Checking Python environment...
python --version >nul 2>nul
if errorlevel 1 (
    echo Error: Python not found, please ensure Python is installed and added to PATH
    echo.
    echo Configure Python in Jenkins:
    echo   1. Install Python 3.x (check 'Add Python to PATH')
    echo   2. Or set PATH at the beginning of the batch file, for example:
    echo      set PATH=C:\Python39;C:\Python39\Scripts;%%PATH%%
    exit /b 1
)

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
python -m robot --version >nul 2>nul
if errorlevel 1 (
    echo robot command not available, installing robotframework...
    python -m pip install robotframework
)

echo Executing test...
python -m robot --outputdir results --log log.html --report report.html testcases/run_all_tests.robot

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
