pushd %~dp0

if exist Harmony.Core.ProjectTemplates.1.0.54.nupkg del /q Harmony.Core.ProjectTemplates.1.0.54.nupkg
nuget pack Harmony.Core.ProjectTemplates.nuspec

popd
pause