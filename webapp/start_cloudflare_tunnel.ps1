$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$appUrl = $env:APP_URL
if ([string]::IsNullOrWhiteSpace($appUrl)) {
  $appUrl = 'http://127.0.0.1:4173'
}

$installScript = Join-Path $root 'install_cloudflared_windows.ps1'
$cloudflaredPath = Join-Path $root '.tools\cloudflared.exe'

if (-not (Test-Path -LiteralPath $cloudflaredPath)) {
  & $installScript
}

function Test-AppServer {
  try {
    Invoke-WebRequest -Uri $appUrl -UseBasicParsing -TimeoutSec 2 | Out-Null
    return $true
  } catch {
    return $false
  }
}

if (-not (Test-AppServer)) {
  $node = Get-Command node -ErrorAction SilentlyContinue
  if ($null -eq $node) {
    $defaultNodePath = 'C:\Program Files\nodejs\node.exe'
    if (Test-Path -LiteralPath $defaultNodePath) {
      $node = [pscustomobject]@{ Source = $defaultNodePath }
    }
  }
  if ($null -eq $node) {
    throw "Node.js was not found. Install Node.js 24 or later, then run this script again."
  }

  Write-Host "Starting FigureList web server..."
  Start-Process -FilePath $node.Source -ArgumentList 'supervisor.js' -WorkingDirectory $root -WindowStyle Hidden

  $started = $false
  for ($i = 0; $i -lt 20; $i++) {
    Start-Sleep -Milliseconds 500
    if (Test-AppServer) {
      $started = $true
      break
    }
  }

  if (-not $started) {
    throw "FigureList web server did not start at $appUrl. Check webapp\server.err.log."
  }
}

Write-Host "Opening Cloudflare Tunnel for $appUrl"
Write-Host "Share the https://*.trycloudflare.com URL shown below."
& $cloudflaredPath tunnel --url $appUrl
