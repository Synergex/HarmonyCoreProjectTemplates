pushd %~dp0
dotnet new -i Harmony.Core.ProjectTemplates.1.0.2.nupkg
dotnet new -i Harmony.Core.WorkshopTemplates2018.1.0.2.nupkg
popd
pause