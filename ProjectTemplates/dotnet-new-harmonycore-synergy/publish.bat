@echo off
setlocal

rem ---------------------------------------------------------------------------
rem NOTE: This file is intended to provide an example of how to publish a
rem       Harmony Core application. You may need to alter the file to meet
rem       your specific requirements. This file WILL NOT BE REPLACED by
rem       subsequent Harmony Core updates.
rem 
rem ---------------------------------------------------------------------------
rem Configure the environment

set SolutionDir=%~dp0
set DeployDir=%SolutionDir%PUBLISH
set rpsmfil=%SolutionDir%Repository\bin\Debug\rpsmain.ism
set rpstfil=%SolutionDir%Repository\bin\Debug\rpstext.ism

rem Traditional Bridge configuration

set BridgeFolder=
set BridgeDbrFile=
set BridgeBatchFile=

rem ---------------------------------------------------------------------------
rem Publish the solution

rem Move to the solution directory
pushd "%SolutionDir%"

rem Make sure the deployment directory exists
if not exist %DeployDir%\. mkdir %DeployDir%

rem Publish the application
pushd Services.Host
dotnet publish -c Debug -r win7-x64 -o %DeployDir%
popd

rem Do we have Traditional Bridge?
if exist %BridgeFolder%\. (
  rem Yes! The project will not have been built by the dotnet publish command,
  rem  so we must build the solution with MSBUILD to make the runtime files.
  msbuild /p:Configuration=Debug
  rem Copy the bridge runtime files to the deployment directory
  copy %BridgeDbrFile% %DeployDir%
  copy %BridgeBatchFile% %DeployDir%
)

popd
endlocal
