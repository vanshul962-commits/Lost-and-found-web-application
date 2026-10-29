@echo off
title Milgaya - Lost and Found Platform
echo =================================================================
echo   MILGAYA - LOST AND FOUND PORTAL (Apache NetBeans / Java Project)
echo =================================================================
echo.
echo Starting application build and launcher...
echo.

set MVN_CMD=mvn
if exist "C:\Program Files\Apache NetBeans\java\maven\bin\mvn.cmd" (
    set MVN_CMD="C:\Program Files\Apache NetBeans\java\maven\bin\mvn.cmd"
)

call %MVN_CMD% compile exec:java
pause
