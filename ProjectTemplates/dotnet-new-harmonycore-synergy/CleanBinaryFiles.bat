@echo off
pushd %~dp0
if exist .vs\. rd /s /q .vs
if exist bin\. rd /s /q bin
if exist obj\. rd /s /q obj
if exist PUBLISH\. rd /s /q PUBLISH
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
popd