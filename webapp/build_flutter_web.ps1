param(
  [switch]$NoRestart,
  [switch]$ForceWorkerBuild
)

$ErrorActionPreference = 'Stop'

$webappRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $webappRoot
$flutterBuildDir = Join-Path $projectRoot 'build\web'
$publicDir = Join-Path $webappRoot 'public'
$uploadsDir = Join-Path $publicDir 'uploads'
$tempRoot = Join-Path $webappRoot '.tmp'
$stageDir = Join-Path $tempRoot 'public-stage'
$uploadsBackup = Join-Path $tempRoot 'uploads'
$assetCacheDir = Join-Path $webappRoot '.cache'
$sqliteWasmCache = Join-Path $assetCacheDir 'sqlite3.wasm'
$sqliteWasmUrl = 'https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.3.1/sqlite3.wasm'
$driftWorkerEntry = Join-Path $projectRoot 'tool\drift_worker.dart'
$driftWorker = Join-Path $stageDir 'drift_worker.js'
$existingDriftWorker = Join-Path $publicDir 'drift_worker.js'

function Get-TreeFingerprint([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    return ''
  }

  $root = (Resolve-Path -LiteralPath $Path).Path
  if (-not $root.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
    $root = "$root$([System.IO.Path]::DirectorySeparatorChar)"
  }
  $items = Get-ChildItem -LiteralPath $root -Recurse -File |
    Where-Object {
      $relative = $_.FullName.Substring($root.Length)
      -not $relative.StartsWith("uploads$([System.IO.Path]::DirectorySeparatorChar)")
    } |
    Sort-Object FullName

  $parts = foreach ($item in $items) {
    $relative = $item.FullName.Substring($root.Length).Replace('\', '/')
    if ($relative -eq 'flutter_bootstrap.js') {
      $content = Get-Content -LiteralPath $item.FullName -Raw
      $content = $content -replace 'serviceWorkerVersion: "[0-9]+"', 'serviceWorkerVersion: "<stable>"'
      $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
      $sha = [System.Security.Cryptography.SHA256]::Create()
      try {
        $hash = ([System.BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '')
      } finally {
        $sha.Dispose()
      }
    } else {
      $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $item.FullName).Hash
    }
    "$relative=$hash"
  }
  return ($parts -join "`n")
}

function Ensure-SqliteWasm {
  New-Item -ItemType Directory -Force -Path $assetCacheDir | Out-Null
  if (Test-Path -LiteralPath $sqliteWasmCache) {
    return
  }

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
      -OutFile $sqliteWasmCache
  } catch {
    $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
    if ($null -ne $curl) {
      & $curl.Source -L --fail -o $sqliteWasmCache $sqliteWasmUrl
    } else {
      Invoke-WebRequest -Uri $sqliteWasmUrl -OutFile $sqliteWasmCache
    }
  }

  if (-not (Test-Path -LiteralPath $sqliteWasmCache)) {
    throw "sqlite3.wasm was not found. Download it from $sqliteWasmUrl and place it at $sqliteWasmCache."
  }
}

function Restart-AppServer {
  if ($NoRestart) {
    return
  }

  try {
    Invoke-WebRequest `
      -Uri 'http://127.0.0.1:4172/api/server/restart' `
      -Method Post `
      -UseBasicParsing `
      -TimeoutSec 5 | Out-Null
    Write-Host "Restarted FigureList web server."
  } catch {
    Write-Host "Skipped server restart because the control server is not reachable."
  }
}

New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
Remove-Item -LiteralPath $stageDir -Recurse -Force -ErrorAction SilentlyContinue

Push-Location $projectRoot
try {
  Write-Host "Running flutter build web..."
  flutter build web --release --no-wasm-dry-run
} finally {
  Pop-Location
}

if (-not (Test-Path -LiteralPath $flutterBuildDir)) {
  throw "Flutter web build output was not found at $flutterBuildDir."
}

Copy-Item -LiteralPath $flutterBuildDir -Destination $stageDir -Recurse
Ensure-SqliteWasm
Copy-Item -LiteralPath $sqliteWasmCache -Destination (Join-Path $stageDir 'sqlite3.wasm') -Force

if ((Test-Path -LiteralPath $existingDriftWorker) -and -not $ForceWorkerBuild) {
  Copy-Item -LiteralPath $existingDriftWorker -Destination $driftWorker -Force
} else {
  Write-Host "Building drift web worker..."
  Push-Location $projectRoot
  try {
    dart compile js $driftWorkerEntry -O2 -o $driftWorker
  } finally {
    Pop-Location
  }
}
Remove-Item -LiteralPath "$driftWorker.deps" -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath "$driftWorker.map" -Force -ErrorAction SilentlyContinue

$oldFingerprint = Get-TreeFingerprint $publicDir
$newFingerprint = Get-TreeFingerprint $stageDir

if ($oldFingerprint -eq $newFingerprint) {
  Write-Host "Cloudflare public assets are already up to date."
  Remove-Item -LiteralPath $stageDir -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
  exit 0
}

if (Test-Path -LiteralPath $uploadsBackup) {
  Remove-Item -LiteralPath $uploadsBackup -Recurse -Force
}
if (Test-Path -LiteralPath $uploadsDir) {
  Move-Item -LiteralPath $uploadsDir -Destination $uploadsBackup
}

Remove-Item -LiteralPath $publicDir -Recurse -Force -ErrorAction SilentlyContinue
Move-Item -LiteralPath $stageDir -Destination $publicDir

if (Test-Path -LiteralPath $uploadsBackup) {
  Move-Item -LiteralPath $uploadsBackup -Destination $uploadsDir
}

Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Updated Cloudflare public assets from build\web."
Restart-AppServer
