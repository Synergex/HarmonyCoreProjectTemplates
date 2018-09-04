pushd %~dp0
dotnet new -u Harmony.Core.DemoTemplates.1.0.1
dotnet new -u Harmony.Core.ProjectTemplates.1.0.1
dotnet new -u Harmony.Core.WorkshopTemplates2018.1.0.1
popd
pause