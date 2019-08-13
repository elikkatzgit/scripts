echo off
REM delete registry to solve RDP license issue
REM http://www.thewindowsclub.com/remote-session-disconnected-no-remote-desktop-client-access-licenses

ECHO Going to dleete registry value

REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSLicensing

pause