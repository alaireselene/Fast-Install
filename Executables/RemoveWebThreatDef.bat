@echo off
set version=23.07

for /f %%i in ('reg query "HKLM\SYSTEM\ControlSet001\Services" /s /k "webthreatdefusersvc" /f 2^>nul ^| find /i "webthreatdefusersvc" ') do (
  reg add "%%i" /v "Start" /t REG_DWORD /d "4" /f >NUL 2>nul
)