@echo off
set version=23.07

for /f "tokens=2 delims==" %%a in ('wmic os get TotalVisibleMemorySize /format:value') do set "memTemp=%%a"
set /a "mem=%memTemp% + 1024000"
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "%mem%" /f >NUL
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f >NUL

for /f "usebackq tokens=2 delims=\" %%a in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
  REM If the "Volatile Environment" key exists, that means it is a proper user. Built in accounts/SIDs do not have this key.
  reg query "HKEY_USERS\%%a" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > nul 2>&1
    if not errorlevel 1 (
      if %mem% lss 9000000 ( 
        reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >NUL
        reg add "HKU\%%a\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >NUL 2>nul
      )
    )
  )
