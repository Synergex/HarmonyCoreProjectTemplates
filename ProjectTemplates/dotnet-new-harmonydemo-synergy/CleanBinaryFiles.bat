@echo off
pushd %~dp0
if exist .vs\. rd /s /q .vs
if exist bin\. rd /s /q bin
if exist obj\. rd /s /q obj
if exist PUBLISH\. rd /s /q PUBLISH
if exist Repository\bin\. rd /s /q Repository\bin
if exist Repository\obj\. rd /s /q Repository\obj
if exist SampleData\*.ism del /q SampleData\*.ism
if exist SampleData\*.is1 del /q SampleData\*.is1
if exist Services\.intellisense\. rd /s /q Services\.intellisense
if exist Services\bin\. rd /s /q Services\bin
if exist Services\obj\. rd /s /q Services\obj
if exist Services.Controllers\.intellisense\. rd /s /q Services.Controllers\.intellisense
if exist Services.Controllers\bin\. rd /s /q Services.Controllers\bin
if exist Services.Controllers\obj\. rd /s /q Services.Controllers\obj
if exist Services.Host\.intellisense\. rd /s /q Services.Host\.intellisense
if exist Services.Host\bin\. rd /s /q Services.Host\bin
if exist Services.Host\obj\. rd /s /q Services.Host\obj
if exist Services.Isolated\.intellisense\. rd /s /q Services.Isolated\.intellisense
if exist Services.Isolated\bin\. rd /s /q Services.Isolated\bin
if exist Services.Isolated\obj\. rd /s /q Services.Isolated\obj
if exist Services.Models\.intellisense\. rd /s /q Services.Models\.intellisense
if exist Services.Models\bin\. rd /s /q Services.Models\bin
if exist Services.Models\obj\. rd /s /q Services.Models\obj
if exist TraditionalBridge\.intellisense\. rd /s /q TraditionalBridge\.intellisense
if exist TraditionalBridge\bin\. rd /s /q TraditionalBridge\bin
if exist TraditionalBridge\obj\. rd /s /q TraditionalBridge\obj
if exist TraditionalBridge\exe\host.dbp del /q TraditionalBridge\exe\host.dbp
if exist TraditionalBridge\exe\host.dbr del /q TraditionalBridge\exe\host.dbr
if exist TraditionalBridge\exe\launch del /q TraditionalBridge\exe\launch
if exist TraditionalBridge\exe\launch.bat del /q TraditionalBridge\exe\launch.bat
if exist TraditionalBridge\XmlDoc\Services.Controllers.xml del /q TraditionalBridge\XmlDoc\Services.Controllers.xml
if exist TraditionalBridge\XmlDoc\Services.Models.xml del /q TraditionalBridge\XmlDoc\Services.Models.xml
if exist TraditionalBridge\XmlDoc\Services.xml del /q TraditionalBridge\XmlDoc\Services.xml
popd