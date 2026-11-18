<#
.SYNOPSIS
  Script Instalasi 9Router untuk Windows Runner
#>

$ErrorActionPreference = "Stop"
Write-Host "=== Memulai Instalasi 9Router ===" -ForegroundColor Cyan

# 1. Pastikan Node.js terinstall (9Router umumnya butuh Node.js)
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js tidak ditemukan. Mengunduh dan menginstal Node.js..." -ForegroundColor Yellow
    $nodeUrl = "https://nodejs.org/dist/v20.12.2/node-v20.12.2-x64.msi"
    $nodeInstaller = "$env:TEMP\node-installer.msi"
    
    Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstaller -UseBasicParsing
    Start-Process msiexec.exe -ArgumentList "/i", "`"$nodeInstaller`"", "/quiet", "/norestart" -Wait
    Remove-Item $nodeInstaller -Force
    
    # Refresh PATH agar perintah 'node' dan 'npm' dikenali tanpa restart
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "Node.js berhasil diinstal." -ForegroundColor Green
}

# 2. Buat direktori kerja untuk 9Router
$routerDir = "C:\9Router"
if (-not (Test-Path $routerDir)) {
    New-Item -ItemType Directory -Path $routerDir -Force | Out-Null
}

# 3. Download dan Instalasi 9Router
Write-Host "Mengunduh 9Router..." -ForegroundColor Yellow

# ⚠️ PENTING: GANTI URL DI BAWAH INI dengan URL repository/release 9Router yang asli
$repoUrl = "https://github.com/USERNAME/9Router.git" # <--- GANTI DENGAN URL REPO ASLI

# Cek jika 9Router berbentuk ZIP / EXE installer, sesuaikan logikanya di sini.
# Contoh jika 9Router berbasis Git:
if (-not (Test-Path "$routerDir\.git")) {
    Set-Location $routerDir
    git clone $repoUrl .
} else {
    Set-Location $routerDir
    git pull
}

# 4. Install Dependensi (jika menggunakan Node.js/npm)
if (Test-Path "$routerDir\package.json") {
    Write-Host "Menginstal dependensi NPM..." -ForegroundColor Yellow
    npm install
} else {
    Write-Host "package.json tidak ditemukan, melewati npm install." -ForegroundColor DarkGray
}

# 5. Jalankan 9Router di Background agar RDP tidak nge-hang
Write-Host "Menjalankan 9Router..." -ForegroundColor Cyan

# Sesuaikan perintah run-nya. Contoh: npm start, atau mengeksekusi file .exe
if (Test-Path "$routerDir\package.json") {
    # Menjalankan via Node.js
    $proc = Start-Process -FilePath "cmd.exe" -ArgumentList "/c npm start" -WorkingDirectory $routerDir -WindowStyle Hidden -PassThru
} elseif (Test-Path "$routerDir\9router.exe") {
    # Menjalankan jika berbentuk .exe
    $proc = Start-Process -FilePath "$routerDir\9router.exe" -WorkingDirectory $routerDir -WindowStyle Hidden -PassThru
}

Write-Host "9Router berjalan di background (PID: $($proc.Id))." -ForegroundColor Green
Write-Host "=== Instalasi 9Router Selesai ===" -ForegroundColor Cyan