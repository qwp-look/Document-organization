@echo off
setlocal EnableDelayedExpansion

echo =================================
echo File Organization Tool
echo Author: qwp-look
echo =================================

:: Create base directories
md "Documents" 2>nul
md "Images" 2>nul
md "Videos" 2>nul
md "Music" 2>nul
md "Archives" 2>nul
md "Software" 2>nul
md "Others" 2>nul

echo Processing files...
echo.

:: Process all files recursively
for /r %%F in (*.*) do (
    if not "%%~nxF"=="%~nx0" (
        set "dest=Others"
        
        rem Documents
        if /i "%%~xF"==".doc" set "dest=Documents"
        if /i "%%~xF"==".docx" set "dest=Documents"
        if /i "%%~xF"==".pdf" set "dest=Documents"
        if /i "%%~xF"==".txt" set "dest=Documents"
        if /i "%%~xF"==".xls" set "dest=Documents"
        if /i "%%~xF"==".xlsx" set "dest=Documents"
        
        rem Images
        if /i "%%~xF"==".jpg" set "dest=Images"
        if /i "%%~xF"==".jpeg" set "dest=Images"
        if /i "%%~xF"==".png" set "dest=Images"
        if /i "%%~xF"==".gif" set "dest=Images"
        
        rem Videos
        if /i "%%~xF"==".mp4" set "dest=Videos"
        if /i "%%~xF"==".avi" set "dest=Videos"
        if /i "%%~xF"==".mkv" set "dest=Videos"
        
        rem Music
        if /i "%%~xF"==".mp3" set "dest=Music"
        if /i "%%~xF"==".wav" set "dest=Music"
        
        rem Archives
        if /i "%%~xF"==".zip" set "dest=Archives"
        if /i "%%~xF"==".rar" set "dest=Archives"
        if /i "%%~xF"==".7z" set "dest=Archives"
        
        rem Software
        if /i "%%~xF"==".exe" set "dest=Software"
        if /i "%%~xF"==".msi" set "dest=Software"
        
        echo Moving: %%~nxF to !dest!
        move "%%F" "%CD%\!dest!\%%~nxF" >nul 2>nul
    )
)

:: Remove empty directories
for /f "delims=" %%D in ('dir /s /b /ad ^| sort /r') do rd "%%D" 2>nul

echo.
echo =================================
echo Organization complete!
echo Files have been sorted into:
echo - Documents
echo - Images
echo - Videos
echo - Music
echo - Archives
echo - Software
echo - Others
echo =================================

pause