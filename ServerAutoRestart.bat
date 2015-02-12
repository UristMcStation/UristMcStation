echo off
setLocal EnableDelayedExpansion
cls
title Server AutoRestart

rem # path to dmb to run
set gamedmb="C:\path\goes\here\UristMcStation\baystation12.dmb"
rem # parameters for Dream Daemon
set launchoptions=-port 12345
rem # path to dreamdaemon executable (in quotes)
set dreamdaemonpath="C:\path\goes\here\byond\bin\dreamdaemon.exe"
rem # process name in task manager
set processname=dreamdaemon.exe
rem # time between checks
set rate=30
rem # time before restart, delay in case of intentional shutdown
set delay=6

rem # randomize tmp file names to help prevent conflicts of multiple servers
set /a setrand="%random%%%9999"
set tempfileA=sar_tmp%setrand%A.txt
set tempfileB=sar_tmp%setrand%B.txt

echo (%time%) Starting Server AutoRestart process

:restart
echo (%time%) Starting server...

rem # Get and sort the current list of process IDs (PIDs)
echo " START" > %tempfileA%
for /f "tokens=2 delims=," %%A in ('tasklist -v /fo csv /nh /fi "IMAGENAME eq %processname%"') do echo %%A >> %tempfileA%
sort /+2 /rec 15 %tempfileA% /o %tempfileA%
echo " END" >> %tempfileA%

rem # Start the DMB
start "" %dreamdaemonpath% %gamedmb% %launchoptions%

rem # Get and sort the new list of process IDs (PIDs)
echo " START" > %tempfileB%
for /f "tokens=2 delims=," %%A in ('tasklist -v /fo csv /nh /fi "IMAGENAME eq %processname%"') do echo %%A >> %tempfileB%
sort /+2 /rec 15 %tempfileB% /o %tempfileB%
echo " END" >> %tempfileB%

rem # Determine the difference to get our server's PID
for /f "skip=6 tokens=1" %%A in ('fc /a /l /1 %%tempfileA%% %%tempfileB%%') do set pid=%%A & goto found
:found
rem # Remove the quotes from the number
set pid=%pid:~1,-2%

rem # Clean up temporary files
del %tempfileA% %tempfileB%

echo (%time%) ...server started with PID = %pid%

:check
rem # Wait (hack for XP and later)
ping 127.0.0.1 -n %rate% -w 1000>nul

rem ECHO (%time%) Checking server...

rem # Check if the server is still running
tasklist /FI "PID eq %pid%" 2>nul | find /I /N "%pid%">nul
if %ERRORLEVEL%==1 goto stopped

:running
rem # Server is still running, queue up another check
goto check

:stopped
rem # Server stopped
ECHO (%time%) Server with PID = %pid% exited or crashed

rem # Wait (hack for XP and later)
ping 127.0.0.1 -n %delay% -w 1000>nul

rem # Go back and start it again
goto restart