@echo off
pushd %~dp0
setlocal
set SolutionDir=%~dp0

rem ================================================================================================================================
rem Specify the names of the projects to generate code into:

set ServicesProject=Services
set ModelsProject=Services.Models
set ControllersProject=Services.Controllers
set HostProject=Services.Host
set TestProject=Services.Test
set TraditionalBridgeProject=TraditionalBridge
set TraditionalBridgeNamespace=TraditionalBridge

rem ================================================================================================================================
rem Specify the names of the repository structures to generate code from:

set DATA_STRUCTURES=
set DATA_ALIASES=%DATA_STRUCTURES%

set FILE_STRUCTURES=%DATA_STRUCTURES%
set FILE_ALIASES=%DATA_ALIASES%

set CUSTOM_STRUCTURES=
set CUSTOM_ALIASES=%CUSTOM_STRUCTURES%

set BRIDGE_STRUCTURES=
set BRIDGE_ALIASES=%BRIDGE_STRUCTURES%

rem DATA_STRUCTURES     Is a list all structures that you wish to generate models, metadata and
rem                     controllers for. In other words it declares all of the "entities"
rem                     that are being represented and exposed by the environment. The DbContext
rem                     and EdmBuilder classes will be aware of the types associated with These
rem                     structures.
rem
rem FILE_STRUCTURES     If you don't have multi-record format files then this should be the
rem                     same as DATA_STRUCTURES. But if you do then FILE_STRUCTURES should
rem                     only list ONE of the structures assigned to each file, so this list
rem                     will be a subset of DATA_STRUCTURES.
rem
rem CUSTOM_STRUCTURES	Is a list of structures that you wish to generate models and metadata
rem                     for, but which will NOT be exposed to the Entity Framework provider.
rem                     These classes are intended for use only by custom code-based endpoints
rem                     and the DbContext and EdmBuilder classes will know nothing about them.

rem BRIDGE_STRUCTURES	Is a list of structures that you wish to generate models and metadata
rem                     for use with a Traditional Bridge environment. These types will NOT
rem                     be exposed to the Entity Framework provider.

rem ================================================================================================================================
rem Specify optional "system parameter file" structure

set PARAMSTR=

rem In the sammple environment the system parameter file is a relative file that contains
rem "next available record number" data for use in conjunction with POST (create with automated
rem primary key assignment) operaitons. Naming the structure associated with that file here
rem ensures that a copy of that file will be made available in the sample self-host environment
rem along with other data files in the sample data folder. This mechanism will require customization
rem for use in other environments.

rem ================================================================================================================================
rem Comment or uncomment the following lines to enable or disable optional features:

rem Note that the ENABLE_SWAGGER_DOCS and ENABLE_API_VERSIONING are mutually exclusive.

rem set ENABLE_GET_ALL=-define ENABLE_GET_ALL
rem set ENABLE_GET_ONE=-define ENABLE_GET_ONE
rem set ENABLE_SELF_HOST_GENERATION=YES
rem set ENABLE_CREATE_TEST_FILES=-define ENABLE_CREATE_TEST_FILES
rem set ENABLE_SWAGGER_DOCS=-define ENABLE_SWAGGER_DOCS
rem set ENABLE_API_VERSIONING=-define ENABLE_API_VERSIONING
rem set ENABLE_POSTMAN_TESTS=YES
rem set ENABLE_ALTERNATE_KEYS=-define ENABLE_ALTERNATE_KEYS
rem set ENABLE_COUNT=-define ENABLE_COUNT
rem set ENABLE_PROPERTY_ENDPOINTS=-define ENABLE_PROPERTY_ENDPOINTS
rem set ENABLE_PROPERTY_VALUE_DOCS=-define ENABLE_PROPERTY_VALUE_DOCS
rem set ENABLE_SELECT=-define ENABLE_SELECT
rem set ENABLE_FILTER=-define ENABLE_FILTER
rem set ENABLE_ORDERBY=-define ENABLE_ORDERBY
rem set ENABLE_TOP=-define ENABLE_TOP
rem set ENABLE_SKIP=-define ENABLE_SKIP
rem set ENABLE_RELATIONS=-define ENABLE_RELATIONS
rem set ENABLE_PUT=-define ENABLE_PUT
rem set ENABLE_POST=-define ENABLE_POST
rem set ENABLE_PATCH=-define ENABLE_PATCH
rem set ENABLE_DELETE=-define ENABLE_DELETE
rem set ENABLE_SPROC=-define ENABLE_SPROC
rem set ENABLE_ADAPTER_ROUTING=-define ENABLE_ADAPTER_ROUTING
rem set ENABLE_AUTHENTICATION=-define ENABLE_AUTHENTICATION
rem set ENABLE_CUSTOM_AUTHENTICATION=-define ENABLE_CUSTOM_AUTHENTICATION
rem set ENABLE_FIELD_SECURITY=-define ENABLE_FIELD_SECURITY
rem set ENABLE_UNIT_TEST_GENERATION=YES
rem set ENABLE_CASE_SENSITIVE_URL=-define ENABLE_CASE_SENSITIVE_URL
rem set ENABLE_CORS=-define ENABLE_CORS
rem set ENABLE_IIS_SUPPORT=-define ENABLE_IIS_SUPPORT
rem set ENABLE_OVERLAYS=-f o
rem set ENABLE_ALTERNATE_FIELD_NAMES=-af
rem set ENABLE_READ_ONLY_PROPERTIES=-define ENABLE_READ_ONLY_PROPERTIES
rem set ENABLE_TRADITIONAL_BRIDGE_GENERATION=YES

if not "NONE%ENABLE_SELECT%%ENABLE_FILTER%%ENABLE_ORDERBY%%ENABLE_TOP%%ENABLE_SKIP%%ENABLE_RELATIONS%"=="NONE" (
  set PARAM_OPTIONS_PRESENT=-define PARAM_OPTIONS_PRESENT
)

rem ================================================================================================================================
rem Configure standard command line options and the CodeGen environment

set NOREPLACEOPTS=-e -lf -u %SolutionDir%UserDefinedTokens.tkn %ENABLE_GET_ALL% %ENABLE_GET_ONE% %ENABLE_OVERLAYS% %ENABLE_ALTERNATE_FIELD_NAMES% %ENABLE_AUTHENTICATION% %ENABLE_CUSTOM_AUTHENTICATION% %ENABLE_FIELD_SECURITY% %ENABLE_PROPERTY_ENDPOINTS% %ENABLE_PROPERTY_VALUE_DOCS% %ENABLE_CASE_SENSITIVE_URL% %ENABLE_CREATE_TEST_FILES% %ENABLE_CORS% %ENABLE_IIS_SUPPORT% %ENABLE_DELETE% %ENABLE_PUT% %ENABLE_POST% %ENABLE_PATCH% %ENABLE_ALTERNATE_KEYS% %ENABLE_SWAGGER_DOCS% %ENABLE_API_VERSIONING% %ENABLE_RELATIONS% %ENABLE_SELECT% %ENABLE_FILTER% %ENABLE_ORDERBY% %ENABLE_COUNT% %ENABLE_TOP% %ENABLE_SKIP% %ENABLE_SPROC% %ENABLE_ADAPTER_ROUTING% %ENABLE_READ_ONLY_PROPERTIES% %PARAM_OPTIONS_PRESENT% -i %SolutionDir%Templates -rps %RPSMFIL% %RPSTFIL%
set STDOPTS=%NOREPLACEOPTS% -r

rem ================================================================================================================================
rem Generate a Web API / OData CRUD environment

rem Generate model and metadata classes
codegen -s %DATA_STRUCTURES% %CUSTOM_STRUCTURES% ^
        -a %DATA_ALIASES% %CUSTOM_ALIASES% ^
        -t ODataModel ODataMetaData ^
        -o %SolutionDir%%ModelsProject% ^
        -n %ModelsProject% ^
           %STDOPTS%
if ERRORLEVEL 1 goto error

rem Generate controller classes
codegen -s %DATA_STRUCTURES% ^
        -a %DATA_ALIASES% ^
        -t ODataController ^
        -o %SolutionDir%%ControllersProject% ^
        -n %ControllersProject% ^
           %STDOPTS%
if ERRORLEVEL 1 goto error

rem Generate the DbContext class
codegen -s %DATA_STRUCTURES% -ms ^
        -a %DATA_ALIASES% ^
        -t ODataDbContext ^
        -o %SolutionDir%%ModelsProject% ^
        -n %ModelsProject% ^
           %STDOPTS%
if ERRORLEVEL 1 goto error

rem Generate the EdmBuilder and Startup classes
codegen -s %DATA_STRUCTURES% -ms ^
        -a %DATA_ALIASES% ^
        -t ODataEdmBuilder ODataStartup ^
        -o %SolutionDir%%ServicesProject% ^
        -n %ServicesProject% ^
        -ut CONTROLLERS_NAMESPACE=%ControllersProject% MODELS_NAMESPACE=%ModelsProject% ^
           %STDOPTS%
if ERRORLEVEL 1 goto error

rem ================================================================================
rem Self hosting

if DEFINED ENABLE_SELF_HOST_GENERATION (
  codegen -s %FILE_STRUCTURES% %PARAMSTR% -ms ^
          -a %FILE_ALIASES% ^
          -t ODataSelfHost ODataSelfHostEnvironment ^
          -o %SolutionDir%%HostProject% ^
          -n %HostProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error
)

rem ================================================================================
rem Swagger documentation and Postman tests

rem Generate a Swagger files
if DEFINED ENABLE_SWAGGER_DOCS (
  codegen -s %DATA_STRUCTURES% -ms ^
          -a %DATA_ALIASES% ^
          -t ODataSwaggerYaml ^
          -o %SolutionDir%%ServicesProject%\wwwroot ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error

  codegen -s %DATA_STRUCTURES% ^
          -a %DATA_ALIASES% ^
          -t ODataSwaggerType ^
          -o %SolutionDir%%ServicesProject%\wwwroot ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error
)

rem Generate Postman Tests
if DEFINED ENABLE_POSTMAN_TESTS (
  codegen -s %DATA_STRUCTURES% -ms ^
          -a %DATA_ALIASES% ^
          -t ODataPostManTests ^
          -o %SolutionDir% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error
)

rem ================================================================================
rem Unit testing project

if DEFINED ENABLE_UNIT_TEST_GENERATION (

  rem Generate OData client model, data loader and unit test classes
  codegen -s %DATA_STRUCTURES% ^
          -a %DATA_ALIASES% ^
          -t ODataClientModel ODataTestDataLoader ODataUnitTests ^
          -o %SolutionDir%%TestProject% -tf ^
          -n %TestProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error

  rem Generate the test environment
  codegen -s %FILE_STRUCTURES% %PARAMSTR% -ms ^
          -a %FILE_ALIASES% ^
          -t ODataTestEnvironment ^
          -o %SolutionDir%%TestProject% ^
          -n %TestProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error

  rem Generate the unit test environment class, and the unit test hosting program
  codegen -s %FILE_STRUCTURES% -ms ^
          -a %FILE_ALIASES% ^
          -t ODataUnitTestEnvironment ODataUnitTestHost ^
          -o %SolutionDir%%TestProject% ^
          -n %TestProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error

  rem Generate the unit test constants properties classes
  codegen -s %DATA_STRUCTURES% -ms ^
          -a %DATA_ALIASES% ^
          -t ODataTestConstantsProperties ^
          -o %SolutionDir%%TestProject% ^
          -n %TestProject% ^
             %STDOPTS%
  if ERRORLEVEL 1 goto error

  rem Generate unit test constants values class; one time, not replaced
  codegen -s %DATA_STRUCTURES% -ms ^
          -a %DATA_ALIASES% ^
          -t ODataTestConstantsValues ^
          -o %SolutionDir%%TestProject% ^
          -n %TestProject% ^
             %NOREPLACEOPTS%
  if ERRORLEVEL 1 goto error
)

rem ================================================================================
rem Generate code for the TraditionalBridge sample environment

if ENABLE_TRADITIONAL_BRIDGE_GENERATION (
  set CODEGEN_TPLDIR=Templates\TraditionalBridge

  rem Generate model classes
  codegen -s %BRIDGE_STRUCTURES% ^
          -a %BRIDGE_ALIASES% ^
          -t ODataModel ^
          -o %SolutionDir%%TraditionalBridgeProject%\source ^
          -n %TraditionalBridgeNamespace% ^
          -e -r -lf
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