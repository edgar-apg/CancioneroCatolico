Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "Vamos a crear un PDF! (ChordPro) " -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# Buscar subcarpetas en Cantos/
$cantosPath = Join-Path $PSScriptRoot "Cantos"
$carpetas = Get-ChildItem -Path $cantosPath -Directory

if ($carpetas.Count -eq 0) {
    Write-Host "No se encontraron carpetas en 'Cantos'." -ForegroundColor Red
    exit
}

# Mostrar menú
Write-Host "Que tipo de canto quieres exportar?" -ForegroundColor Yellow
for ($i = 0; $i -lt $carpetas.Count; $i++) {
    Write-Host "$($i + 1)) $($carpetas[$i].Name)"
}
Write-Host ""

# Elegir carpeta (convertir a número)
$eleccion = [int](Read-Host "Escribe el numero")

if ($eleccion -lt 1 -or $eleccion -gt $carpetas.Count) {
    Write-Host "Opcion invalida." -ForegroundColor Red
    exit
}
$carpetaSeleccionada = $carpetas[$eleccion - 1].Name

# Buscar archivos .chordpro en la carpeta seleccionada
$cancionesPath = Join-Path $cantosPath $carpetaSeleccionada
$archivos = Get-ChildItem -Path $cancionesPath -Filter *.chordpro

if ($archivos.Count -eq 0) {
    Write-Host "No se encontraron archivos .chordpro en '$carpetaSeleccionada'." -ForegroundColor Red
    exit
}

# Mostrar menú de canciones
Write-Host ""
Write-Host "Canciones disponibles en '$carpetaSeleccionada':"
for ($j = 0; $j -lt $archivos.Count; $j++) {
    Write-Host "$($j + 1)) $($archivos[$j].BaseName)"
}
Write-Host ""

# Elegir archivo
$eleccionArchivo = [int](Read-Host "Escribe el numero de la cancion que quieres exportar")

if ($eleccionArchivo -lt 1 -or $eleccionArchivo -gt $archivos.Count) {
    Write-Host "Opcion invalida." -ForegroundColor Red
    exit
}
$archivoSeleccionado = $archivos[$eleccionArchivo - 1]

# Obtener el nombre de archivo sin extensión
$nombreArchivo = $archivoSeleccionado.BaseName

# Asegurarse que la carpeta 'PDFs' exista
$pdfsPath = Join-Path $PSScriptRoot "PDFs"
if (!(Test-Path -Path $pdfsPath)) {
    New-Item -ItemType Directory -Path $pdfsPath | Out-Null
}

# Ruta del archivo PDF de salida
$pdfSalida = Join-Path $pdfsPath "$nombreArchivo.pdf"

# Imprimir las rutas para depuración
Write-Host "Ruta del archivo .chordpro: $($archivoSeleccionado.FullName)" -ForegroundColor Cyan
Write-Host "Ruta del PDF de salida: $pdfSalida" -ForegroundColor Cyan

# Comando para exportar
$cancionPath = $archivoSeleccionado.FullName

# Ejecutar el comando chordpro
chordpro --config=modern3 --output="$pdfSalida" "$cancionPath"

Write-Host ""
Write-Host ("Canto exportado exitosamente a 'PDFs\$nombreArchivo.pdf'!") -ForegroundColor Green
