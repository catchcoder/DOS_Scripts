net start | find /i "Port Reporter" > nul
if not errorlevel 1 net start "Port Reporter"
