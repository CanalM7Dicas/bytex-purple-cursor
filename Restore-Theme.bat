@echo off
chcp 65001 >nul
title Restaurar Cursores Padrão do Windows
echo Restaurando os cursores originais do Windows...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-Default-Theme.ps1"

echo.
pause
