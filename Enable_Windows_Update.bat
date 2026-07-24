@echo off
title Enable Windows Update

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo ========================================
echo      Enabling Windows Update
echo ========================================
echo.

:: Enable services
sc config wuauserv start= demand
sc config bits start= delayed-auto
sc config dosvc start= auto
sc config usosvc start= auto
sc config WaaSMedicSvc start= demand

:: Start services
net start bits
net start dosvc
net start usosvc
net start wuauserv

:: Enable scheduled tasks
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_Display" /Enable >nul 2>&1

echo.
echo Windows Update has been enabled.
echo.
pause
