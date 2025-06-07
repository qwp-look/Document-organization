:: file_organizer_recursive.bat
@echo off
chcp 65001 >nul
setlocal enableextensions enabledelayedexpansion

:: 用法提示
if "%~1"=="" (
    echo 用法：%~nx0 源目录 [目标目录] [排除扩展名,逗号分隔]
    echo 示例：%~nx0 "C:\Downloads" "C:\Organized" "exe,msi,dll"
    exit /b 1
)

:: 参数化
set "SRC=%~1"
set "DST=%~2"
if "%DST%"=="" set "DST=%SRC%\Organized"

:: 排除列表
set "EXCLUDES=%~3"
set "EXCLUDES=%EXCLUDES:,= %%"

:: 统计总文件数
for /f %%C in ('dir /b /s "%SRC%" ^| find /c /v ""') do set TOTAL=%%C
if "%TOTAL%"=="0" (
    echo 未发现任何文件，退出。
    exit /b 0
)

:: 准备日志和进度变量
set "LOGFILE=%~dp0organizer.log"
if exist "%LOGFILE%" (
    copy /y "%LOGFILE%" "%LOGFILE%.bak" >nul
    del /q "%LOGFILE%"
)
set /a INDEX=0
set "BARFULL==================================================="
set "SPACES                                                  "

echo 总共 %TOTAL% 个文件，需要处理，开始... 

:: 主循环：遍历所有文件
for /r "%SRC%" %%F in (*) do (
    set /a INDEX+=1
    set "FULL=%%~fF"
    set "NAME=%%~nxF"
    set "EXT=%%~xF"
    if defined EXT (
        set "EXT=!EXT:~1!"
    ) else (
        set "EXT=NoExt"
    )

    :: 排除判断
    for %%E in (!EXCLUDES!) do (
        if /I "%%E"=="!EXT!" (
            goto :SKIPFILE
        )
    )

    :: 创建分类文件夹
    if not exist "%DST%\!EXT!\" (
        mkdir "%DST%\!EXT!"
        if errorlevel 1 (
            echo [%date% %time%] ERROR: 无法创建文件夹 "%DST%\!EXT%\" >> "%LOGFILE%"
            exit /b 2
        )
    )

    :: 冲突检测
    set "TARGET=%DST%\!EXT!\!NAME!"
    if exist "!TARGET!" (
        set /a COUNT=1
        for %%N in ("!NAME!") do (
            set "BASENAME=%%~nN" & set "SUFFIX=%%~xN"
        )
        :RENLOOP
        set "NEWNAME=!BASENAME!_!COUNT!!SUFFIX!"
        set "TARGET=%DST%\!EXT!\!NEWNAME!"
        if exist "!TARGET!" (
            set /a COUNT+=1
            goto :RENLOOP
        ) else (
            set "NAME=!NEWNAME!"
        )
    )

    :: 移动
    move "%FULL%" "%DST%\!EXT!\!NAME!" >nul
    if errorlevel 1 (
        echo [%date% %time%] ERROR: 移动 "%FULL%" >> "%LOGFILE%"
    ) else (
        echo [%date% %time%] MOVE "%FULL%" -> "%DST%\!EXT!\!NAME!" >> "%LOGFILE%"
    )

    :: 更新并显示进度条
    set /a PERCENT=INDEX*100/TOTAL
    set /a BLOCKS=PERCENT/2
    set "BAR=!BARFULL:~0,!BLOCKS!!!"
    set /a REST=50-BLOCKS
    set "BAR=!BAR!!SPACES:~0,%REST%!!"
    <nul set /p ="处理中 [%BAR%] %PERCENT%%% ( %INDEX%/%TOTAL% )`r"

    :SKIPFILE
)

echo.
endlocal
echo 完成，详细日志见 "%LOGFILE%"
exit /b 0
