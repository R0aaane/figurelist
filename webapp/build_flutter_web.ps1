$ErrorActionPreference = 'Stop'

$webappRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $webappRoot
$publicDir = Join-Path $webappRoot 'public'
$uploadsDir = Join-Path $publicDir 'uploads'
$tempRoot = Join-Path $webappRoot '.tmp'
$uploadsBackup = Join-Path $tempRoot 'uploads'
$sqliteWasm = Join-Path $publicDir 'sqlite3.wasm'
$driftWorker = Join-Path $publicDir 'drift_worker.js'
$driftWorkerEntry = Join-Path $projectRoot 'tool\drift_worker.dart'
$sqliteWasmUrl = 'https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.3.1/sqlite3.wasm'

New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

if (Test-Path -LiteralPath $uploadsBackup) {
  Remove-Item -LiteralPath $uploadsBackup -Recurse -Force
}

if (Test-Path -LiteralPath $uploadsDir) {
  Move-Item -LiteralPath $uploadsDir -Destination $uploadsBackup
}

try {
  Push-Location $projectRoot
  flutter build web --release --output (Join-Path 'webapp' 'public')
} finally {
  Pop-Location
}

if (Test-Path -LiteralPath $uploadsBackup) {
  New-Item -ItemType Directory -Force -Path $publicDir | Out-Null
  if (Test-Path -LiteralPath $uploadsDir) {
    Remove-Item -LiteralPath $uploadsDir -Recurse -Force
  }
  Move-Item -LiteralPath $uploadsBackup -Destination $uploadsDir
}

Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue

if (-not (Test-Path -LiteralPath $sqliteWasm)) {
  Write-Host "Downloading sqlite3.wasm..."
  try {
    $release = Invoke-RestMethod `
      -Uri 'https://api.github.com/repos/simolus3/sqlite3.dart/releases/tags/sqlite3-3.3.1'
    $asset = $release.assets | Where-Object { $_.name -eq 'sqlite3.wasm' } | Select-Object -First 1
    if ($null -eq $asset) {
      throw 'sqlite3.wasm asset was not found in the GitHub release.'
    }
    Invoke-WebRequest `
      -Uri $asset.url `
      -Headers @{ Accept = 'application/octet-stream'; 'User-Agent' = 'FigureList-build' } `
      -OutFile $sqliteWasm
  } catch {
    $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
    if ($null -ne $curl) {
      & $curl.Source -L --fail -o $sqliteWasm $sqliteWasmUrl
    } else {
      Invoke-WebRequest -Uri $sqliteWasmUrl -OutFile $sqliteWasm
    }
  }
}

if (-not (Test-Path -LiteralPath $sqliteWasm)) {
  throw "sqlite3.wasm was not found. Download it from $sqliteWasmUrl and place it at $sqliteWasm."
}

Write-Host "Building drift web worker..."
Push-Location $projectRoot
try {
  dart compile js $driftWorkerEntry -O2 -o $driftWorker
} finally {
  Pop-Location
}

Remove-Item -LiteralPath "$driftWorker.deps" -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath "$driftWorker.map" -Force -ErrorAction SilentlyContinue
