@echo off
pushd %~dp0
setlocal
set SolutionDir=%~dp0

rem ================================================================================================================================
rem Specify the names of the projects to generate code into:

set ServicesProject=
set HostProject=
set TestProject=

rem ================================================================================================================================
rem Specify the names of the repository structures to generate code from:

set DataStructures=
set FileStructures=

rem DataStructures is used when processing all of the individual data structures
rem FileStructures may be different if data for multiple structures is stored in a single file.
rem In this case only one of those structures needs to be processed.

rem ================================================================================================================================
rem Comment or uncomment the following lines to enable or disable optional features:

rem set ENABLE_SELF_HOST_GENERATION=YES
rem set ENABLE_CREATE_TEST_FILES=-define ENABLE_CREATE_TEST_FILES
rem set ENABLE_SWAGGER_DOCS=-define ENABLE_SWAGGER_DOCS
rem set ENABLE_POSTMAN_TESTS=YES
rem set ENABLE_ALTERNATE_KEYS=-define ENABLE_ALTERNATE_KEYS
rem set ENABLE_COUNT=-define ENABLE_COUNT
rem set ENABLE_PROPERTY_ENDPOINTS=-define ENABLE_PROPERTY_ENDPOINTS
rem set ENABLE_SELECT=-define ENABLE_SELECT
rem set ENABLE_FILTER=-define ENABLE_FILTER
rem set ENABLE_ORDERBY=-define ENABLE_ORDERBY
rem set ENABLE_TOP=-define ENABLE_TOP
rem set ENABLE_SKIP=-define ENABLE_SKIP
rem set ENABLE_RELATIONS=-define ENABLE_RELATIONS
rem set ENABLE_PUT=-define ENABLE_PUT
rem set ENABLE_PATCH=-define ENABLE_PATCH
rem set ENABLE_DELETE=-define ENABLE_DELETE
rem set ENABLE_AUTHENTICATION=-define ENABLE_AUTHENTICATION
rem set ENABLE_UNIT_TEST_GENERATION=YES
rem set ENABLE_CASE_SENSITIVE_URL=-define ENABLE_CASE_SENSITIVE_URL
rem set ENABLE_CORS=-define ENABLE_CORS
rem set ENABLE_IIS_SUPPORT=-define ENABLE_IIS_SUPPORT


if not "NONE%ENABLE_SELECT%%ENABLE_FILTER%%ENABLE_ORDERBY%%ENABLE_TOP%%ENABLE_SKIP%%ENABLE_RELATIONS%"=="NONE" (
  set PARAM_OPTIONS_PRESENT=-define PARAM_OPTIONS_PRESENT
)

rem ================================================================================================================================
rem Configure standard command line options and the CodeGen environment

set NOREPLACEOPTS=-e -lf -u %SolutionDir%UserDefinedTokens.tkn %ENABLE_AUTHENTICATION% %ENABLE_PROPERTY_ENDPOINTS% %ENABLE_CASE_SENSITIVE_URL% %ENABLE_CREATE_TEST_FILES% %ENABLE_CORS% %ENABLE_IIS_SUPPORT% %ENABLE_DELETE% %ENABLE_PUT% %ENABLE_PATCH% %ENABLE_ALTERNATE_KEYS% %ENABLE_SWAGGER_DOCS% %ENABLE_RELATIONS% %ENABLE_SELECT% %ENABLE_FILTER% %ENABLE_ORDERBY% %ENABLE_COUNT% %ENABLE_TOP% %ENABLE_SKIP% %PARAM_OPTIONS_PRESENT% -i %SolutionDir%Templates -rps %RPSMFIL% %RPSTFIL%
set STDOPTS=%NOREPLACEOPTS% -r

rem ================================================================================
rem Generate a Web API / OData CRUD environment

rem Generate model, metadata and controller classes
codegen -s %DataStructures% ^
        -t ODataModel ODataMetaData ODataController ^
        -o %SolutionDir%%ServicesProject% -tf ^
        -n %ServicesProject% ^
           %STDOPTS%
if ERRORLEVEL 1 goto error

rem Generate the DbContext and EdmBuilder and Startup classes
codegen -s %DataStructures% -ms ^
        -t ODataDbContext ODataEdmBuilder ODataStartup ^
        -o %SolutionDir%%ServicesProject% ^
        -n %ServicesProject% ^
           %STDOPTS%
if ERRORLEVEL 1 goto error

rem ================================================================================
rem Self hosting

if DEFINED ENABLE_SELF_HOST_GENERATION (
  codegen -s %FileStructures% -ms ^
          -t ODataStandAloneSelfHost ^
          -o %SolutionDir%%HostProject% ^
          -n %HostProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error
)

rem ================================================================================
rem Swagger documentation and Postman tests

rem Generate a Swagger file
if DEFINED ENABLE_SWAGGER_DOCS (
  codegen -s %DataStructures% -ms ^
          -t ODataSwaggerYaml ^
          -o %SolutionDir%%ServicesProject%\wwwroot ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error
)

rem Generate Postman Tests
if DEFINED ENABLE_POSTMAN_TESTS (
  codegen -s %DataStructures% -ms ^
          -t ODataPostManTests ^
          -o %SolutionDir% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error
)

rem ================================================================================
rem Unit testing project

if DEFINED ENABLE_UNIT_TEST_GENERATION (

  rem Generate OData client model, data loader and unit test classes
  codegen -s %DataStructures% ^
          -t ODataClientModel ODataTestDataLoader ODataTestDataGenerator ODataUnitTests ^
          -o %SolutionDir%%TestProject% -tf ^
          -n %TestProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error

  rem Generate data generator classes; one time, not replaced
  codegen -s %DataStructures% ^
          -t ODataClientModel ODataTestDataLoader ODataTestDataGenerator ODataUnitTests ^
          -o %SolutionDir%%TestProject% -tf ^
          -n %TestProject% %NOREPLACEOPTS%
  if ERRORLEVEL 1 goto error

  rem Generate the test environment and unit test environment classes, and the self-hosting program
  codegen -s %FileStructures% -ms ^
          -t ODataTestEnvironment ODataUnitTestEnvironment ODataSelfHost ^
          -o %SolutionDir%%TestProject% ^
          -n %TestProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error

  rem Generate the unit test constants properties classes
  codegen -s %DataStructures% -ms ^
          -t ODataTestConstantsProperties ^
          -o %SolutionDir%%TestProject% ^
          -n %TestProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error

  rem Generate unit test constants values class; one time, not replaced
  codegen -s %DataStructures% -ms ^
          -t ODataTestConstantsValues ^
          -o %SolutionDir%%TestProject% ^
          -n %TestProject% ^
             %NOREPLACEOPTS%
  if ERRORLEVEL 1 goto error
)

rem ================================================================================

echo.
echo DONE!
echo.
goto done

:error
echo *** CODE GENERATION INCOMPLETE ***

:done
endlocal
popd