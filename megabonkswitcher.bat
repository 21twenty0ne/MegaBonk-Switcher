@echo off
setlocal EnableDelayedExpansion

:: настройка кодировки консоли для работы с русским языком
chcp 65001 >nul

:: установка размера окна
mode con: cols=80 lines=30

:: ==========================================
::             НАСТРОЙКИ ПОЛЬЗОВАТЕЛЯ
:: ==========================================
set "STEAM_APP_ID=3405340"
set "LINK_NAME=Megabonk"
set "CLEAN_DIR=Megabonk_vanilla"
set "MODDED_DIR=Megabonk_modded"
set "CONFIG_PATH=%USERPROFILE%\AppData\LocalLow\Ved\Megabonk\Saves\LocalDir\config.json"
set "LANG_FILE=megabonk_lang.ini"
:: ==========================================

:: проверка прав администратора для создания симлинков
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Write-Host '  ! Недостаточно прав. Запуск от имени администратора...' -ForegroundColor Red"
    powershell -Command "Start-Process '%~nx0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"

:: логика выбора и сохранения языка
if not exist "%LANG_FILE%" goto :SelectLang
set /p USER_LANG=<"%LANG_FILE%"
if "%USER_LANG%"=="RU" (
    call :SetLangRU
) else (
    call :SetLangEN
)
goto :Init

:SelectLang
cls
echo.
echo      [ 1 ] English
echo      [ 2 ] Русский
echo.
set /p "LangChoice=   > Select Language / Выберите язык (1/2): "
if "%LangChoice%"=="1" (
    echo EN > "%LANG_FILE%"
    call :SetLangEN
    goto :Init
)
if "%LangChoice%"=="2" (
    echo RU > "%LANG_FILE%"
    call :SetLangRU
    goto :Init
)
goto :SelectLang

:SetLangEN
set "MSG_INIT=  ● Initializing Environment..."
set "MSG_ERR_DIR=  ✖ Error: Directory %LINK_NAME% not found."
set "MSG_DETECT_VANILLA=  ➜ Detected: Vanilla source"
set "MSG_CLONE_MODDED=  ➜ Cloning to Modded directory..."
set "MSG_DETECT_MODDED=  ➜ Detected: Modded source"
set "MSG_CLONE_VANILLA=  ➜ Cloning to Vanilla directory..."
set "MSG_CLEAN_VANILLA=  ➜ Cleaning Vanilla directory..."
set "MSG_MENU_1_TITLE=         [ 1 ]  MEGALADDER (megabonk.su)"
set "MSG_MENU_1_DESC=                Competitive Modded. Custom meta. GAZ"
set "MSG_MENU_2_TITLE=         [ 2 ]  STEAM OFFICIAL"
set "MSG_MENU_2_DESC=                Vanilla meta. Global leaderboards enabled"
set "MSG_MENU_3_TITLE=         [ 3 ]  CHANGE LANGUAGE / СМЕНИТЬ ЯЗЫК"
set "MSG_MENU_3_DESC=                Switch UI language"
set "MSG_SELECT_MODE=   > Select option (1/2/3): "
set "MSG_LOAD_OFFICIAL=  ● Loading Official Profile..."
set "MSG_SYNC_CONFIG=  ● Syncing configuration..."
set "MSG_MODE_ACTIVE_OFFICIAL=  ✔ Mode Active: OFFICIAL"
set "MSG_LOAD_COMPETITIVE=  ● Loading Competitive Profile..."
set "MSG_APPLY_RULES=  ● Applying League Rules..."
set "MSG_MODE_ACTIVE_LADDER=  ✔ Mode Active: MEGALADDER"
set "MSG_LAUNCHING=  ● Launching Steam..."
exit /b

:SetLangRU
set "MSG_INIT=  ● Инициализация окружения..."
set "MSG_ERR_DIR=  ✖ Ошибка: Папка %LINK_NAME% не найдена."
set "MSG_DETECT_VANILLA=  ➜ Обнаружено: Ванильная версия"
set "MSG_CLONE_MODDED=  ➜ Клонирование в папку модов..."
set "MSG_DETECT_MODDED=  ➜ Обнаружено: Модифицированная версия"
set "MSG_CLONE_VANILLA=  ➜ Клонирование в ванильную папку..."
set "MSG_CLEAN_VANILLA=  ➜ Очистка ванильной папки..."
set "MSG_MENU_1_TITLE=         [ 1 ]  MEGALADDER (megabonk.su)"
set "MSG_MENU_1_DESC=                Соревновательный мод. Своя мета. ГАЗ"
set "MSG_MENU_2_TITLE=         [ 2 ]  ОФИЦИАЛЬНЫЙ STEAM"
set "MSG_MENU_2_DESC=                Ванильная мета. Глобальные таблицы лидеров"
set "MSG_MENU_3_TITLE=         [ 3 ]  СМЕНИТЬ ЯЗЫК / CHANGE LANGUAGE"
set "MSG_MENU_3_DESC=                Переключить язык интерфейса"
set "MSG_SELECT_MODE=   > Выберите опцию (1/2/3): "
set "MSG_LOAD_OFFICIAL=  ● Загрузка официального профиля..."
set "MSG_SYNC_CONFIG=  ● Синхронизация настроек..."
set "MSG_MODE_ACTIVE_OFFICIAL=  ✔ Режим активен: ОФИЦИАЛЬНЫЙ"
set "MSG_LOAD_COMPETITIVE=  ● Загрузка соревновательного профиля..."
set "MSG_APPLY_RULES=  ● Применение правил лиги..."
set "MSG_MODE_ACTIVE_LADDER=  ✔ Режим активен: MEGALADDER"
set "MSG_LAUNCHING=  ● Запуск Steam..."
exit /b

:Init
:: проверка существования рабочих директорий
if exist "%CLEAN_DIR%" if exist "%MODDED_DIR%" goto :MainMenu

cls
echo.
powershell -Command "Write-Host '%MSG_INIT%' -ForegroundColor Cyan"

if not exist "%LINK_NAME%" (
    powershell -Command "Write-Host '%MSG_ERR_DIR%' -ForegroundColor Red"
    pause
    exit /b
)

:: определение текущего состояния игры при первом запуске
if not exist "%LINK_NAME%\BepInEx" (
    powershell -Command "Write-Host '%MSG_DETECT_VANILLA%' -ForegroundColor Gray"
    ren "%LINK_NAME%" "%CLEAN_DIR%"
    powershell -Command "Write-Host '%MSG_CLONE_MODDED%' -ForegroundColor DarkGray"
    xcopy "%CLEAN_DIR%" "%MODDED_DIR%" /E /I /Q >nul
) else (
    powershell -Command "Write-Host '%MSG_DETECT_MODDED%' -ForegroundColor Gray"
    ren "%LINK_NAME%" "%MODDED_DIR%"
    powershell -Command "Write-Host '%MSG_CLONE_VANILLA%' -ForegroundColor DarkGray"
    xcopy "%MODDED_DIR%" "%CLEAN_DIR%" /E /I /Q >nul
    
    powershell -Command "Write-Host '%MSG_CLEAN_VANILLA%' -ForegroundColor DarkGray"
    if exist "%CLEAN_DIR%\BepInEx" rmdir /s /q "%CLEAN_DIR%\BepInEx"
    if exist "%CLEAN_DIR%\winhttp.dll" del /f /q "%CLEAN_DIR%\winhttp.dll"
    if exist "%CLEAN_DIR%\doorstop_config.ini" del /f /q "%CLEAN_DIR%\doorstop_config.ini"
)

:: создание базовой точки входа через джанкшен
mklink /J "%LINK_NAME%" "%MODDED_DIR%" >nul
timeout /t 1 >nul

:MainMenu
cls
echo.
echo.
powershell -Command "Write-Host '                     ██████╗  █████╗ ███████╗' -ForegroundColor Cyan"
powershell -Command "Write-Host '                    ██╔════╝ ██╔══██╗╚══███╔╝' -ForegroundColor Cyan"
powershell -Command "Write-Host '                    ██║  ███╗███████║  ███╔╝ ' -ForegroundColor Cyan"
powershell -Command "Write-Host '                    ██║   ██║██╔══██║ ███╔╝  ' -ForegroundColor Cyan"
powershell -Command "Write-Host '                    ╚██████╔╝██║  ██║███████╗' -ForegroundColor Cyan"
powershell -Command "Write-Host '                     ╚═════╝ ╚═╝  ╚═╝╚══════╝' -ForegroundColor Cyan"
echo.
powershell -Command "Write-Host '            MEGABONK SWITCHER' -ForegroundColor White -NoNewline; Write-Host '  ::  v1.0 by 21twentyone' -ForegroundColor DarkGray"
echo.
powershell -Command "Write-Host '  ══════════════════════════════════════════════════════════════════════════' -ForegroundColor DarkGray"
echo.

powershell -Command "Write-Host '%MSG_MENU_1_TITLE%' -ForegroundColor White"
powershell -Command "Write-Host '%MSG_MENU_1_DESC%' -ForegroundColor DarkGray"
echo.
powershell -Command "Write-Host '%MSG_MENU_2_TITLE%' -ForegroundColor White"
powershell -Command "Write-Host '%MSG_MENU_2_DESC%' -ForegroundColor DarkGray"
echo.
powershell -Command "Write-Host '%MSG_MENU_3_TITLE%' -ForegroundColor White"
powershell -Command "Write-Host '%MSG_MENU_3_DESC%' -ForegroundColor DarkGray"
echo.
powershell -Command "Write-Host '  ══════════════════════════════════════════════════════════════════════════' -ForegroundColor DarkGray"
echo.

set /p "UserChoice=%MSG_SELECT_MODE%"

if "%UserChoice%"=="1" goto :SetModded
if "%UserChoice%"=="2" goto :SetVanilla
if "%UserChoice%"=="3" goto :ChangeLang
goto :MainMenu

:ChangeLang
if exist "%LANG_FILE%" del "%LANG_FILE%"
goto :SelectLang

:SetVanilla
echo.
powershell -Command "Write-Host '%MSG_LOAD_OFFICIAL%' -ForegroundColor Cyan"
if exist "%LINK_NAME%" rmdir "%LINK_NAME%"
mklink /J "%LINK_NAME%" "%CLEAN_DIR%" >nul

:: патчинг json конфига для включения лидербордов
powershell -Command "Write-Host '%MSG_SYNC_CONFIG%' -ForegroundColor DarkGray"
if exist "%CONFIG_PATH%" (
    attrib -r "%CONFIG_PATH%"
    powershell -Command "$j = Get-Content '%CONFIG_PATH%' -Raw | ConvertFrom-Json; $j.cfGameSettings | Add-Member 'hide_leaderboards' 0 -Force -MemberType NoteProperty; $j.cfGameSettings | Add-Member 'upload_score_to_leaderboard' 1 -Force -MemberType NoteProperty; $j | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG_PATH%'"
    powershell -Command "Write-Host '%MSG_MODE_ACTIVE_OFFICIAL%' -ForegroundColor Green"
)
goto :LaunchGame

:SetModded
echo.
powershell -Command "Write-Host '%MSG_LOAD_COMPETITIVE%' -ForegroundColor Cyan"
if exist "%LINK_NAME%" rmdir "%LINK_NAME%"
mklink /J "%LINK_NAME%" "%MODDED_DIR%" >nul

:: патчинг json конфига для отключения лидербордов (правила лиги)
powershell -Command "Write-Host '%MSG_APPLY_RULES%' -ForegroundColor DarkGray"
if exist "%CONFIG_PATH%" (
    attrib -r "%CONFIG_PATH%"
    powershell -Command "$j = Get-Content '%CONFIG_PATH%' -Raw | ConvertFrom-Json; $j.cfGameSettings | Add-Member 'hide_leaderboards' 1 -Force -MemberType NoteProperty; $j.cfGameSettings | Add-Member 'upload_score_to_leaderboard' 0 -Force -MemberType NoteProperty; $j | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG_PATH%'"
    powershell -Command "Write-Host '%MSG_MODE_ACTIVE_LADDER%' -ForegroundColor Green"
)
goto :LaunchGame

:LaunchGame
echo.
powershell -Command "Write-Host '%MSG_LAUNCHING%' -ForegroundColor Gray"
start steam://rungameid/%STEAM_APP_ID%
timeout /t 3 >nul
exit