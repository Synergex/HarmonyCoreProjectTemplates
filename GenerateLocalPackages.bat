pushd %~dp0

if exist Harmony.Core.ProjectTemplates.1.0.46.nupkg del /q Harmony.Core.ProjectTemplates.1.0.46.nupkg
nuget pack Harmony.Core.ProjectTemplates.nuspec

popd
pause