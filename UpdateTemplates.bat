pushd %~dp0
copy /y ..\HarmonyCore\Templates\*.tpl ProjectTemplates\dotnet-new-harmonycore-synergy\Templates
copy /y ..\HarmonyCore\Templates\*.tpl ProjectTemplates\dotnet-new-harmonycorebasic-synergy\Templates
popd
pause