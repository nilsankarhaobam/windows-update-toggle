@echo off
title Disable Windows Update

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo ========================================
echo      Disabling Windows Update
echo ========================================
echo.

:: Stop services
net stop wuauserv /y
net stop bits /y
net stop dosvc /y
net stop usosvc /y
net stop WaaSMedicSvc /y

:: Disable services
sc config wuauserv start= disabled
sc config bits start= disabled
sc config dosvc start= disabled
sc config usosvc start= disabled
sc config WaaSMedicSvc start= disabled

:: Disable scheduled tasks
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_Display" /Disable >nul 2>&1

echo.
echo Windows Update has been disabled.
echo.
pause
