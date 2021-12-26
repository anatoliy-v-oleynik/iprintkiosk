@echo off
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto runas

If Defined PROCESSOR_ARCHITEW6432 (Set xOS=x64) Else If "%PROCESSOR_ARCHITECTURE%"=="AMD64" Set xOS=x64
IF %xOS%==x64 (Set SPath=%WinDir%\SysWOW64) Else (Set SPath=%WinDir%\System32)

copy %~dps0mscomm32.ocx %SPath%\mscomm32.ocx /Y

%SPath%\regsvr32.exe %SPath%\mscomm32.ocx /s
%SPath%\regsvr32.exe /i:%~dps0posdevices.wsc %SPath%\scrobj.dll /s
%SPath%\regsvr32.exe /i:%~dps0scoding.wsc  %SPath%\scrobj.dll /s

reg add "HKEY_CLASSES_ROOT\Licenses\4250E830-6AC2-11cf-8ADB-00AA00C00905" /t REG_SZ /f /d "kjljvjjjoquqmjjjvpqqkqmqykypoqjquoun" > nul
REM reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "Shell" /t REG_SZ /f /d "cscript.exe %~dp0iprintkiosk.wsf" > nul
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /f /d 1 > nul
REM powercfg.exe -hibernate off
REM netsh wlan set hostednetwork mode=allow ssid="iprintkiosk" key="12345678" keyUsage=persistent
REM netsh wlan start hostednetwork

exit /b
 
:runas
mshta.exe "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"
exit /b

