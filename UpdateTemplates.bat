pushd %~dp0

copy /y ..\HarmonyCore\Templates\*.tpl ProjectTemplates\dotnet-new-harmonycore-synergy\Templates
copy /y ..\HarmonyCore\Templates\SignalR\*.tpl ProjectTemplates\dotnet-new-harmonycore-synergy\Templates\SignalR
copy /y ..\HarmonyCore\Templates\TraditionalBridge\*.tpl ProjectTemplates\dotnet-new-harmonycore-synergy\Templates\TraditionalBridge

popd
pause