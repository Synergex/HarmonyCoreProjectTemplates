@echo off
pushd %~dp0

pushd ProjectTemplates\dotnet-new-harmonycore-synergy
if exist .vs\. rd /s /q .vs
if exist packages\. rd /s /q packages
if exist Repository\bin\. rd /s /q Repository\bin
if exist Repository\obj\. rd /s /q Repository\obj
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

if exist SampleData\customers.ism del /q SampleData\customers.ism > nul
if exist SampleData\customers.is1 del /q SampleData\customers.is1 > nul
if exist SampleData\items.ism del /q SampleData\items.ism> nul
if exist SampleData\items.is1 del /q SampleData\items.is1 > nul
if exist SampleData\order_items.ism del /q SampleData\order_items.ism> nul
if exist SampleData\order_items.is1 del /q SampleData\order_items.is1 > nul
if exist SampleData\orders.ism del /q SampleData\orders.ism> nul
if exist SampleData\orders.is1 del /q SampleData\orders.is1 > nul
if exist SampleData\vendors.ism del /q SampleData\vendors.ism> nul
if exist SampleData\vendors.is1 del /q SampleData\vendors.is1 > nul
if exist SampleData\sysparams.ddf del /q SampleData\sysparams.ddf > nul

popd

popd