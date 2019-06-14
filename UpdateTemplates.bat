pushd %~dp0

copy /y ..\HarmonyCore\Templates\*.tpl ProjectTemplates\dotnet-new-harmonycore-synergy\Templates
copy /y ..\HarmonyCore\Templates\TraditionalBridge\ODataMetaData.tpl ProjectTemplates\dotnet-new-harmonycore-synergy\Templates\TraditionalBridge
copy /y ..\HarmonyCore\Templates\TraditionalBridge\ODataModel.tpl ProjectTemplates\dotnet-new-harmonycore-synergy\Templates\TraditionalBridge

copy /y ..\HarmonyCore\Templates\*.tpl ProjectTemplates\dotnet-new-harmonycorebasic-synergy\Templates
copy /y ..\HarmonyCore\Templates\TraditionalBridge\ODataMetaData.tpl ProjectTemplates\dotnet-new-harmonycorebasic-synergy\Templates\TraditionalBridge
copy /y ..\HarmonyCore\Templates\TraditionalBridge\ODataModel.tpl ProjectTemplates\dotnet-new-harmonycorebasic-synergy\Templates\TraditionalBridge

popd
pause