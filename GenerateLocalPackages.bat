pushd %~dp0

if exist Harmony.Core.ProjectTemplates.1.0.45.nupkg del /q Harmony.Core.ProjectTemplates.1.0.45.nupkg
nuget pack Harmony.Core.ProjectTemplates.nuspec

rem if exist Harmony.Core.WorkshopTemplates2018.1.0.1.nupkg del /q Harmony.Core.WorkshopTemplates2018.1.0.1.nupkg
rem nuget pack Harmony.Core.WorkshopTemplates2018.nuspec

popd
pause