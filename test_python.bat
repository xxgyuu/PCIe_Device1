@echo off
REM 设置Python路径
set PATH=C:\Users\xys47339\AppData\Local\Programs\Python\Python311;C:\Users\xys47339\AppData\Local\Programs\Python\Python311\Scripts;%PATH%

echo Testing Python...
where python
python --version
python -m pip --version
