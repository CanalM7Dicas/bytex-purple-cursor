@echo off
chcp 65001 >nul
title Instalador e Aplicador - ByteX Purple Cursor
echo ========================================================
echo       APLICADOR DE CURSORES - BYTEX PURPLE CURSOR
echo              Créditos: Canal M7Dicas
echo ========================================================
echo.
echo Aplicando os novos cursores ByteX no seu Windows...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Apply-ByteX-Theme.ps1"

echo.
pause
