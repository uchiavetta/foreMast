@echo off
cls
title Installation libs -- API :: %COMPUTERNAME% -- %USERNAME%
color 2F
mode con cols=100 lines=40
echo =================================================================================
echo.
echo Installation des libs
echo.
echo Version-- creation : 04/02/2026 -- Modification : 04/02/2026
echo.
echo Par Jeros VIGAN ^< zedauna ^>
echo.
echo =================================================================================
echo %time%

REM === Chemins complets === 
set PYTHON="D:\tools\WPy64-31180\python-3.11.8.amd64\python.exe"
echo.

REM mise à jour du module PIP
%PYTHON% -m pip install --upgrade pip
timeout 5 > NUL
echo %time%
echo.

REM installation des packages
%PYTHON% -m pip install cdsapi zipfile time json datetime
timeout 5 > NUL
echo %time
echo.

REM listes des modules
%PYTHON% -m pip list
timeout 5 > NUL
echo %time%
echo.
echo Merci pour l'utilisation de ce programme!
echo.
echo Appuyez sur une touche pour quitter...
pause>NUL
cls
exit