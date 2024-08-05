set GameToolkitPath=E:\Home\Karg\Projects\GameToolkit
set ProjectPath=E:\Home\Karg\Projects\Haxe\GameLib

@rem English
IF NOT EXIST "%ProjectPath%\data\strings\EN" mkdir "%ProjectPath%\data\strings\EN"
"%GameToolkitPath%\bin\StringTool\StringTool.exe" -input "%ProjectPath%\data\strings\Strings_EN.xml" -script "%ProjectPath%\tools\StringTool\StringScript_AS30_ByteArray.csl" -output "%ProjectPath%\data\strings\EN"

@rem Romanian
IF NOT EXIST "%ProjectPath%\data\strings\RO" mkdir "%ProjectPath%\data\strings\RO"
"%GameToolkitPath%\bin\StringTool\StringTool.exe" -input "%ProjectPath%\data\strings\Strings_RO.xml" -script "%ProjectPath%\tools\StringTool\StringScript_AS30_ByteArray.csl" -output "%ProjectPath%\data\strings\RO"

cp -f "%ProjectPath%\data\strings\EN\AllStrings.hx" "%ProjectPath%\src\data"
cp -f "%ProjectPath%\data\strings\EN\StringPackages.hx" "%ProjectPath%\src\data"

@rem Build the library swf
"C:\Program Files\swfmill-0.2.12.5-win32\swfmill.exe" simple data.xml data.swf
