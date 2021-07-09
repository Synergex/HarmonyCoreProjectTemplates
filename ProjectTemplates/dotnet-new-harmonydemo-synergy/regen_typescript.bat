@echo off
rem =============================================================================================
rem 
rem Title: regen_typescript.bat
rem 
rem This file presents an examle of how to create various TypeScript files that can be useful
rem when using xfServerPlus miration based on a method catalog and Harmony Core Traditional Bridge 
rem and writing browser-based client applications.
rem 
rem =============================================================================================
pushd %~dp0
if not exist "TypeScript" mkdir "TypeScript"

rem =============================================================================================
rem 
rem set METHOD_CATALOG_FILE=TraditionalBridge\MethodCatalog\MethodDefinitions.xml
rem set METHOD_CATALOG_INTERFACE=MyInterface

echo.
echo Generating TypeScript interface messages
codegen -smc %METHOD_CATALOG_FILE% -interface %METHOD_CATALOG_INTERFACE% -t TypeScriptInterfaceMethods -i Templates\TypeScript -o TypeScript -lf -u UserDefinedTokens.tkn -rps Repository\rpsmain.ism Repository\rpstext.ism -define ENABLE_AUTHENTICATION -define GLOBAL_MODELSTATE_FILTER -define ENABLE_NEWTONSOFT -f o -r
echo.
echo Generating TypeScript data structures (with overlays)
codegen -smcstrs %METHOD_CATALOG_FILE% -interface %METHOD_CATALOG_INTERFACE% -ms -t TypeScriptInterfaceStructures -i Templates\TypeScript -o TypeScript -lf -u UserDefinedTokens.tkn -rps Repository\rpsmain.ism Repository\rpstext.ism -define ENABLE_AUTHENTICATION -define GLOBAL_MODELSTATE_FILTER -define ENABLE_NEWTONSOFT -ut SUFFIX=WithOverlays -f o -r
echo.
echo Generating TypeScript data structures (without overlays)
codegen -smcstrs %METHOD_CATALOG_FILE% -interface %METHOD_CATALOG_INTERFACE% -ms -t TypeScriptInterfaceStructures -i Templates\TypeScript -o TypeScript -lf -u UserDefinedTokens.tkn -rps Repository\rpsmain.ism Repository\rpstext.ism -define ENABLE_AUTHENTICATION -define GLOBAL_MODELSTATE_FILTER -define ENABLE_NEWTONSOFT -ut SUFFIX=NoOverlays -r

rem =============================================================================================
rem 
rem set DATA_STRUCTURES=
rem set DATA_ALIASES=%DATA_STRUCTURES%

echo.
echo Generating TypeScript OData structures (with overlays)
codegen -s %DATA_STRUCTURES% -a %DATA_ALIASES% -ms -t TypeScriptODataStructures -i Templates\TypeScript -o TypeScript -lf -u UserDefinedTokens.tkn -rps Repository\rpsmain.ism Repository\rpstext.ism -define ENABLE_AUTHENTICATION -define GLOBAL_MODELSTATE_FILTER -define ENABLE_NEWTONSOFT -ut SUFFIX=WithOverlays -f o -r
echo.
echo Generating TypeScript OData structures (without overlays)
codegen -s %DATA_STRUCTURES% -a %DATA_ALIASES% -ms -t TypeScriptODataStructures -i Templates\TypeScript -o TypeScript -lf -u UserDefinedTokens.tkn -rps Repository\rpsmain.ism Repository\rpstext.ism -define ENABLE_AUTHENTICATION -define GLOBAL_MODELSTATE_FILTER -define ENABLE_NEWTONSOFT -ut SUFFIX=NoOverlays -r
popd
