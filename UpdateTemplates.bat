pushd %~dp0
copy /y ..\HarmonyCore\Templates\*.tpl DemoTemplates\dotnet-new-hcdemo-synergy\Templates
copy /y ..\HarmonyCore\Templates\*.tpl ProjectTemplates\dotnet-new-harmonycore-synergy\Templates
copy /y ..\HarmonyCore\Templates\*.tpl WorkshopTemplates2018\dotnet-new-hcworkshop-synergy\Templates
popd
pause