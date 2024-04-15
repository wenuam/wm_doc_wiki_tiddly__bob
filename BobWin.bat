@echo off && setlocal EnableDelayedExpansion
if "%~dp0" neq "!guid!\" (set "guid=%tmp%\crlf.%~nx0.%~z0" & set "cd=%~dp0" & (if not exist "!guid!\%~nx0" (mkdir "!guid!" 2>nul & find "" /v<"%~f0" >"!guid!\%~nx0")) & call "!guid!\%~nx0" %* & rmdir /s /q "!guid!" 2>nul & exit /b) else (if "%cd:~-1%"=="\" set "cd=%cd:~0,-1%")

set "bob_proc=%~n0.exe"
set "bob_conf=.\IndexWiki\settings\settings.json"

echo Starting TW5-Bob...
	echo   proc=%bob_proc%
	for /f "tokens=1" %%i In ('tasklist /nh /fi "imagename eq %bob_proc%"') do set "bob_task=%%~i"
	if /i not "%bob_task%"=="%bob_proc%" (
		if not "%bob_html%"=="" (
			start "%bob_proc% (%bob_html%)" /min /d "%cd%" "%bob_proc%"
		) else (
			start "%bob_proc%" /min /d "%cd%" "%bob_proc%"
			timeout 1 >nul
		)
	) else (
		echo     ^(already running^)
	)

echo Reading configuration file...
	echo   conf=%bob_conf%
	for /f "delims=" %%i in ('Powershell -Nop -C "(Get-Content %bob_conf%|ConvertFrom-Json).'ws-server'.host"') do set "bob_host=%%~i"
	if "%bob_host%"=="" ( set "bob_host=localhost" )
	if "%bob_host%"=="0.0.0.0" ( set "bob_host=localhost" )
	for /f "delims=" %%i in ('Powershell -Nop -C "(Get-Content %bob_conf%|ConvertFrom-Json).'ws-server'.port"') do set "bob_port=%%~i"
	if "%bob_port%"=="" ( set "bob_port=8080" )
	rem NOT https
	set "bob_html=http://%bob_host%:%bob_port%"

echo Opening TW5-Bob page...
	echo   html=%bob_html%
	start "" /d "%cd%" "%bob_html%"
