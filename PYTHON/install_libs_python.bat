@echo off
cls
title Telechargement-- API :: %COMPUTERNAME% -- %USERNAME%
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
echo.
REM mise à jour du module PIP
python -m pip install --upgrade pip
timeout 5 > NUL
echo %time%
echo.
REM installation des packages
python -m pip install cdsapi zipfile time json datetime
echo.
REM listes des modules
python -m pip list
timeout 5 > NUL
echo %time%
echo Merci pour l'utilisation de ce programme!
echo.
echo Appuyez sur une touche pour quitter...
pause>NUL
cls
exit