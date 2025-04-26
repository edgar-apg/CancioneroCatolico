@echo off
setlocal enabledelayedexpansion

echo ==============================================
echo ¡Vamos a exportar un canto!  (ChordPro PDF)
echo ==============================================
echo.

:: Mostrar carpetas disponibles
echo ¿Qué tipo de canto es? 
set count=0
for /d %%a in (Cantos\*) do (
    set /a count+=1
    set folder[!count!]=%%~nxa
    echo !count!. %%~nxa
)

echo.
set /p choice="Selecciona el número de la carpeta: "

set foldername=!folder[%choice%]!

if not defined foldername (
    echo  Opción inválida.
    pause
    exit /b
)

echo.
set /p archivo="Escribe el nombre del archivo (sin .cho): "

if not exist PDFs (
    mkdir PDFs
)

chordpro -c config.json -o PDFs\%archivo%.pdf Cantos\%foldername%\%archivo%.cho

echo.
echo  ¡Canto exportado en la carpeta PDFs! 
pause
