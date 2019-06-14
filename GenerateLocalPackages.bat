pushd %~dp0
setlocal

set /p HC_VERSION=<HarmonyCoreVersion.txt
set NUPKG_FILE=Harmony.Core.ProjectTemplates.%HC_VERSION%.nupkg

if exist %NUPKG_FILE% del /q %NUPKG_FILE%
nuget pack Harmony.Core.ProjectTemplates.nuspec -properties hc_version=%HC_VERSION%

endlocal
popd
pause