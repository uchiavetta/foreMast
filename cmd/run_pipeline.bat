@echo off
cls
setlocal enabledelayedexpansion
title foreMAST -- version 1 for forecast masting events of European :: %COMPUTERNAME% -- %USERNAME%
color 2F
mode con cols=180 lines=200
echo =================================================================================
echo.
echo Predire le masting du hetre
echo.
echo Version 1.0 Alpha
echo.
echo Par Jeros VIGAN ^< zedauna ^>                                           
echo.
echo =================================================================================
echo %time%
echo.
set /p lat="Merci de saisir la latitude: "
set /p lon="Merci de saisir la longitude: "
set /p API_KEY="Merci de saisir la cle de connexion: "
echo.
if "%lat%"=="" goto fin
if "%lon%"=="" goto fin
if "%API_KEY%"=="" goto fin
echo.

REM === Chemins complets === 
set PYTHON="D:\tools\WPy64-31180\python-3.11.8.amd64\python.exe"
set RSCRIPT="C:\Users\jv08720\AppData\Local\Programs\R\R-4.4.0\bin\Rscript.exe"

REM === Chemin du répertoire du batch ===
set SCRIPT_DIR=%~dp0
echo %SCRIPT_DIR%
echo.

REM telechargement
echo =================================================================================
echo --- Python -- Telechargement
echo =================================================================================
echo.
%PYTHON% "%SCRIPT_DIR%script_download.py" %lat% %lon% %API_KEY%
echo.
echo Script python termine.
echo.
echo %time%
echo.

REM Prediction
echo =================================================================================
echo --- R -- Traitement de prediction
echo =================================================================================
echo.
%RSCRIPT% "%SCRIPT_DIR%script_traitement.R" --lat %lat% --lon %lon%
echo.
echo Script R termine.
echo.
echo %time%
echo.
:fin
@pause
cls
exit