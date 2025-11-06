@echo off

rem Publishes the Harmony Core service for deployment to either Windows or Linux

rem ---------------------------------------------------------------------------
rem If we have no parameters, show usage info

if /i "%1" == "" (
    echo.
    echo Usage: publish WINDOWS [DEBUG]
    echo        publish LINUX   [DEBUG]
    echo.
    goto :eof
)

setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

rem ---------------------------------------------------------------------------
rem Options

set PROVIDE_SAMPLE_DATA=YES

rem ---------------------------------------------------------------------------
rem Make sure we're in the solution directory

set SolutionDir=%~dp0
pushd "%SolutionDir%"

rem ---------------------------------------------------------------------------
rem First clean the environment to ensure a complete rebuild

if exist CleanBinaryFiles.bat call CleanBinaryFiles.bat > nul 2>&1

rem ---------------------------------------------------------------------------
rem Make sure we have the VS installer

if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
    echo ERROR: The Visual Studio Installer is not installed!
    goto fail
)

rem ---------------------------------------------------------------------------
rem Locate MSBuild (VS 2019/2022) via vswhere

set MSBUILD=
for /f "usebackq tokens=*" %%A in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`) do set MSBUILD=%%A
if not defined MSBUILD (
    echo ERROR: Failed to detect MSBUILD location!
    goto fail
)

rem ---------------------------------------------------------------------------
rem Set up the environment

set SYNCMPOPT=-WD=316

if not defined RPSMFIL set RPSMFIL="%SolutionDir%Repository\rpsmain.ism"
if not defined RPSTFIL set RPSTFIL="%SolutionDir%Repository\rpstext.ism"

rem Are we targeting Windows or Linux?
set TARGET=
if /i "%1" == "WINDOWS" set TARGET=WINDOWS
if /i "%1" == "LINUX"   set TARGET=LINUX
if not defined TARGET (
    echo.
    echo ERROR: You must specify a target platform: WINDOWS or LINUX
    echo.
    goto fail
)

  rem Check for dos2unix tool
set DOS2UNIXEXE=%SolutionDir%Tools\dos2unix.exe
if /i "%TARGET%" equ "LINUX" (
  if not exist "%DOS2UNIXEXE%" (
    echo.
    echo ERROR: The dos2unix tool is not present!
    echo.
    goto fail
  )
)
rem Check for 7-zip
set SEVENZIPEXE=%ProgramW6432%\7-zip\7z.exe
if not exist "%SEVENZIPEXE%" (
    echo.
    echo ERROR: 7-zip is not installed!
    echo.
    goto fail
)

rem Release or Debug?
set CONFIGURATION=Release
if /i "%2" == "DEBUG" set CONFIGURATION=Debug

set HC_PLATFORM=AnyCPU

rem Set the harmony core runtime based on the target
if "%TARGET%" == "WINDOWS" set HC_RUNTIME=win-x64
if "%TARGET%" == "LINUX"   set HC_RUNTIME=linux-x64

rem Set the traditional bridge platform based on the target
if "%TARGET%" == "WINDOWS" set BRIDGE_PLATFORM=x64
if "%TARGET%" == "LINUX"   set BRIDGE_PLATFORM=linux64

rem Set up the deployment directory
set DeployDir=%SolutionDir%PUBLISH\%TARGET%TMP

rem If there is an old PUBLISH folder, delete it
if exist "%DeployDir%\." rmdir /S /Q "%DeployDir%" > nul 2>&1
if exist "%DeployDir%\." (
    echo.
    echo ERROR: Failed to delete deployment directory %DeployDir%
    echo.
    goto fail
)

rem And create a new one
mkdir "%DeployDir%"

rem Set release date/time stamp
for /f %%i in ('powershell -NoProfile -Command "[DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss')"') do set TIMESTAMP=%%i

rem Set the ZIP file name
set ZIP_FILE=%SolutionDir%Publish\HarmonyCore-%HC_RUNTIME%-%TIMESTAMP%.zip

rem ---------------------------------------------------------------------------
rem Build the Traditional Bridge code

echo.
echo Building Traditional Bridge code in %CONFIGURATION% mode

pushd TraditionalBridge

"%MSBUILD%" ^
-target:Rebuild ^
-p:Platform=%BRIDGE_PLATFORM% ^
-p:Configuration=%CONFIGURATION% ^
-verbosity:minimal ^
-nodeReuse:false ^
-nologo ^
TraditionalBridge.synproj

if errorlevel 0 (
    echo.
    echo Traditional Bridge build complete
    echo.
) else (
    echo.
    echo ERROR: Traditional Bridge build failed!
    echo.
    popd
    goto fail
)

popd

rem ---------------------------------------------------------------------------
rem Build and publish the Harmony Core code

echo.
echo Publishing Harmony Core service in %CONFIGURATION% mode
echo.

pushd Services.Host

dotnet publish ^
-p:platform=%HC_PLATFORM% ^
-p:PublishTrimmed=false ^
--configuration %CONFIGURATION% ^
--runtime %HC_RUNTIME% ^
--self-contained true ^
--output "%DeployDir%" ^
--verbosity minimal ^
-nologo

if errorlevel 0 (
    echo.
    echo Harmony Core publish complete
    echo.
) else (
    echo.
    echo ERROR: Harmony Core publish failed!
    echo.
    popd
    goto fail
)

popd

rem ---------------------------------------------------------------------------
rem Include the Traditional Bridge host program and dbp

if exist TraditionalBridge\EXE\host.dbr (
    echo Providing traditional bridge host application
    copy /y TraditionalBridge\EXE\host.dbr "%DeployDir%" > nul 2>&1
) else (
    echo ERROR: Traditional Bridge file host.dbr not found!
    goto fail
)

if exist TraditionalBridge\EXE\host.dbp (
    copy /y TraditionalBridge\EXE\host.dbp "%DeployDir%" > nul 2>&1
) else (
    echo ERROR: Traditional bridge file host.dbp not found!
    goto fail
)

rem ---------------------------------------------------------------------------
rem Provide launch script and other files (Windows)

:windows_files

if /i "%TARGET%" neq "WINDOWS" goto linux_files

if exist "TraditionalBridge\launch.bat" (
    echo Providing traditional bridge launch script
    copy /y "TraditionalBridge\launch.bat" "%DeployDir%" >nul 2>&1
) else (
    echo ERROR: Traditional bridge launch script not found!
    goto fail
)

rem Replace the web.config file with our own version that sets the
rem ASPNETCORE_ENVIRONMENT to Production
if exist "%SolutionDir%web.config" (
  echo Providing updated web.config
  if exist "%DeployDir%\web.config" del /q "%DeployDir%\web.config"
  copy /y "%SolutionDir%web.config" "%DeployDir%\web.config" > nul 2>&1
)

rem ---------------------------------------------------------------------------
rem Provide launch script and other files (Linux)

:linux_files

if /i "%TARGET%" neq "LINUX" goto ssl_cert

if exist TraditionalBridge\launch.sh (
    echo Providing traditional bridge launch script
    copy /y TraditionalBridge\launch.sh "%DeployDir%" > nul 2>&1
    "%DOS2UNIXEXE%" -q "%DeployDir%\launch.sh"
) else (
    echo ERROR: Traditional bridge launch script not found!
    goto fail
)

rem Provide service control scripts

echo Providing service configuration and control scripts

copy /y "%SolutionDir%Linux\startserver.sh" "%DeployDir%\startserver.sh" > nul 2>&1
"%DOS2UNIXEXE%" -q "%DeployDir%\startserver.sh"

copy /y "%SolutionDir%Linux\stopserver.sh" "%DeployDir%\stopserver.sh" > nul 2>&1
"%DOS2UNIXEXE%" -q "%DeployDir%\stopserver.sh"

copy /y "%SolutionDir%Linux\startserver.*.config" "%DeployDir%" > nul 2>&1
"%DOS2UNIXEXE%" -q "%DeployDir%\startserver.*.config"

rem Provide check and dump scripts

echo Providing useful utility scripts

copy /y "%SolutionDir%Linux\check.sh" "%DeployDir%\check.sh" > nul 2>&1
"%DOS2UNIXEXE%" -q "%DeployDir%\check.sh"

copy /y "%SolutionDir%Linux\dump.sh" "%DeployDir%\dump.sh" > nul 2>&1
"%DOS2UNIXEXE%" -q "%DeployDir%\dump.sh"

rem ---------------------------------------------------------------------------
rem Provide an SSL certificate

:ssl_cert

echo Providing a self-signed SSL certificate

dotnet dev-certs https --export-path "%DeployDir%\Services.Host.pfx" --password p@ssw0rd --quiet

if not exist "%DeployDir%\Services.Host.pfx" (
    echo ERROR: Failed to export https developer certificate Services.Host.pfx
    goto fail
)

rem ---------------------------------------------------------------------------
rem Provide XML documentation files

echo Providing XML documentation files

if not exist "%DeployDir%\XmlDoc" mkdir "%DeployDir%\XmlDoc"

if exist "XmlDoc\Services.xml" copy /y "XmlDoc\Services.xml" "%DeployDir%\XmlDoc" > nul 2>&1
if exist "XmlDoc\Services.Controllers.xml" copy /y "XmlDoc\Services.Controllers.xml" "%DeployDir%\XmlDoc" > nul 2>&1
if exist "XmlDoc\Services.Models.xml" copy /y "XmlDoc\Services.Models.xml" "%DeployDir%\XmlDoc" > nul 2>&1

if /i "%TARGET%" equ "LINUX" (
  if exist "%DeployDir%\XmlDoc\Services.xml" "%DOS2UNIXEXE%" -q "%DeployDir%\XmlDoc\Services.xml"
  if exist "%DeployDir%\XmlDoc\Services.Controllers.xml" "%DOS2UNIXEXE%" -q "%DeployDir%\XmlDoc\Services.Controllers.xml"
  if exist "%DeployDir%\XmlDoc\Services.Models.xml" "%DOS2UNIXEXE%" -q "%DeployDir%\XmlDoc\Services.Models.xml"
)

rem ---------------------------------------------------------------------------
rem Provide sample data (don't do this in a production environment!)

:sample_data

if /i "%PROVIDE_SAMPLE_DATA%" neq "YES" goto zip

echo Providing sample data

mkdir "%DeployDir%\SampleData"

copy "%SolutionDir%SampleData\customers.txt" "%DeployDir%\SampleData" > nul 2>&1
copy "%SolutionDir%SampleData\items.txt" "%DeployDir%\SampleData" > nul 2>&1
copy "%SolutionDir%SampleData\order_items.txt" "%DeployDir%\SampleData" > nul 2>&1
copy "%SolutionDir%SampleData\orders.txt" "%DeployDir%\SampleData" > nul 2>&1
copy "%SolutionDir%SampleData\vendors.txt" "%DeployDir%\SampleData" > nul 2>&1

copy "%SolutionDir%SampleData\customers.xdl" "%DeployDir%\SampleData" > nul 2>&1
copy "%SolutionDir%SampleData\items.xdl" "%DeployDir%\SampleData" > nul 2>&1
copy "%SolutionDir%SampleData\order_items.xdl" "%DeployDir%\SampleData" > nul 2>&1
copy "%SolutionDir%SampleData\orders.xdl" "%DeployDir%\SampleData" > nul 2>&1
copy "%SolutionDir%SampleData\vendors.xdl" "%DeployDir%\SampleData" > nul 2>&1

copy "%SolutionDir%SampleData\sysparams.txt" "%DeployDir%\SampleData\sysparams.ddf" > nul 2>&1

rem ---------------------------------------------------------------------------
rem Create the ZIP file

:zip

if exist "%DeployDir%\." (
    echo.
    echo Creating distribution %ZIP_FILE%
    pushd "%DeployDir%"
    "%SEVENZIPEXE%" a -r -bso0 -bsp0 "%ZIP_FILE%" *

    if ERRORLEVEL 0 (
        echo.
        echo Publish complete
        rem Remove the temporary deployment directory
        popd
        rmdir /S /Q "%DeployDir%" > nul 2>&1
    ) else (
        echo ERROR: Publish complete but failed to create zip file! The published application is in %DeployDir%
        echo.
        echo 
        popd
        goto fail
    )
)

rem ---------------------------------------------------------------------------
rem Exit points

:done

popd
endlocal
exit /b 0

:fail

popd
endlocal
exit /b 1
