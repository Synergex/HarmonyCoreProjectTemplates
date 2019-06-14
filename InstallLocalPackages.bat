pushd %~dp0
setlocal

set /p HC_VERSION=<HarmonyCoreVersion.txt
set NUPKG_FILE=Harmony.Core.ProjectTemplates.%HC_VERSION%.nupkg

dotnet new -i %NUPKG_FILE%

endlocal
popd
pause