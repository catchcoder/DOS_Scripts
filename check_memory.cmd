rem @echo off
rem *****************************************************************
rem * Checks memory of a process and kills if using to much memory
rem *
rem * Need to set:
rem *   find_app : app name e.g. regedit
rem *   mem_threshold : max memory before restart in bytes
rem *   app : path and application e.g  "c:\windows\regedit.exe"
rem * 
rem *****************************************************************
@SETLOCAL enableextensions enabledelayedexpansion

rem User variables to change variables below
set mem_threshold=16000
set find_app=regedit
set app="c:\windows\regedit.exe"

rem **************************************
rem do not change anything below this line
rem **************************************
set command="tasklist | find "%find_app%""

:Run_command
for /f "tokens=* USEBACKQ" %%F in (`%command%`) do (
    set  myvar=%%F
)

:check_if_task_is_running
if "%myvar%" == "" goto EOF
echo."%myvar%" | findstr /C:"%find_app%" 1>nul
if errorlevel 1 goto EOF

:Extract_Memory usage
for /f "tokens=1,2,5 delims= " %%a in ("%myvar%") do (
    set xName=%%a
    set xPID=%%b
    set xm=%%c
    call set xMemory=%%xm:,=%%
)

:Compare_Memory_with_threshold
if %xMemory% geq %mem_threshold% (
taskkill /F /PID %xPID% /T

:Start_App
start /B CMD /C CALL %app% >NUL 2>&1
)

:EOF 

ENDLOCAL 

exit /b
