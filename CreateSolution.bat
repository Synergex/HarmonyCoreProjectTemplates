pushd %~dp0
if exist HarmonyCoreExample\. rmdir /s /q HarmonyCoreExample
dotnet new harmonycore -n HarmonyCoreExample -o HarmonyCoreExample
popd
pause