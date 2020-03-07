@echo off
setlocal

set SolutionDir=%~dp0

pushd "%SolutionDir%"

if not defined RPSMFIL (
    echo RPSMFIL is not defined!
    goto error
)

if not defined RPSTFIL (
    echo RPSTFIL is not defined!
    goto error
)

rem ================================================================================================================================
rem Specify the names of the projects to generate code into:

set EfProviderProject=SynergyEfProvider

rem ================================================================================================================================
rem Specify the names of the repository structures to generate code from:

set DATA_STRUCTURES=CUSTOMERS ITEMS ORDERS ORDER_ITEMS VENDORS
set DATA_ALIASES=%DATA_STRUCTURES%
set DATA_FILES=%DATA_STRUCTURES%

rem DATA_STRUCTURES     Is a list all structures that you wish to generate models, metadata and
rem                     controllers for. In other words it declares all of the "entities"
rem                     that are being represented and exposed by the OData environment. The
rem                     DbContextand EdmBuilder classes will be aware of the types associated
rem                     with These structures.
rem
rem DATA_ALIASES        Is a list of alias names for the structures listed in DATA_STRUCTURES.
rem                     If you wish to provide alternate names for the structures being exposed
rem                     then list them here. Specify an alias name for each structure.
rem
rem DATA_FILES          Is a list of the repository file definition names that are associated
rem                     with each structure listed in DATA_STRUCTURES. If you have a one to ONE
rem                     mapping from structures to files then you can leave the setting to
rem                     default to the same value as DATA_STRUCTURES, but if your structure and
rem                     file definitions are different, especially if you have structures that
rem                     are assigned to multiple file definitions, then it is important to list
rem                     the correct file definition assignment for each structure.
rem
rem ================================================================================================================================
rem Comment or uncomment the following lines to enable or disable optional features:

rem set DO_NOT_SET_FILE_LOGICALS=-define DO_NOT_SET_FILE_LOGICALS
set ENABLE_RELATIONS=-define ENABLE_RELATIONS
rem set ENABLE_OVERLAYS=-f o
rem set ENABLE_ALTERNATE_FIELD_NAMES=-af
rem set ENABLE_READ_ONLY_PROPERTIES=-define ENABLE_READ_ONLY_PROPERTIES

rem ================================================================================================================================
rem Configure standard command line options for the CodeGen environment

set STDOPTS=-e -r -lf %ENABLE_OVERLAYS% %DO_NOT_SET_FILE_LOGICALS% %ENABLE_ALTERNATE_FIELD_NAMES% %ENABLE_RELATIONS% %ENABLE_READ_ONLY_PROPERTIES% -rps %RPSMFIL% %RPSTFIL%

rem ================================================================================================================================
rem Generate a Web API / OData CRUD environment

rem Generate model and metadata classes
codegen -s  %DATA_STRUCTURES% ^
        -a  %DATA_ALIASES% ^
        -fo %DATA_FILES% ^
        -t  EfProviderModel EfProviderMetaData ^
        -i  %SolutionDir%Templates\StandaloneEf ^
        -o  %SolutionDir%%EfProviderProject%\Models ^
        -n  %EfProviderProject%.Models ^
            %STDOPTS%
if ERRORLEVEL 1 goto error

rem Generate the DbContext class
codegen -s  %DATA_STRUCTURES% -ms ^
        -a  %DATA_ALIASES% ^
        -fo %DATA_FILES% ^
        -t  EfProviderDbContext ^
        -i  %SolutionDir%Templates\StandaloneEf ^
        -o  %SolutionDir%%EfProviderProject% ^
        -n  %EfProviderProject% ^
        -ut MODELS_NAMESPACE=%EfProviderProject%.Models ^
            %STDOPTS%
if ERRORLEVEL 1 goto error

rem Generate the EfProviderConfig class
codegen -s  %DATA_STRUCTURES% -ms ^
        -a  %DATA_ALIASES% ^
        -fo %DATA_FILES% ^
        -t  EfProviderConfig ^
        -i  %SolutionDir%Templates\StandaloneEf ^
        -o  %SolutionDir%%EfProviderProject% ^
        -n  %EfProviderProject% ^
        -ut MODELS_NAMESPACE=%EfProviderProject%.Models ^
            %STDOPTS%
if ERRORLEVEL 1 goto error

echo.
echo DONE!
echo.
goto done

:error
echo *** CODE GENERATION INCOMPLETE ***

:done
popd
endlocal
