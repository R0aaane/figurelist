$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$toolsDir = Join-Path $root '.tools'
$cloudflaredPath = Join-Path $toolsDir 'cloudflared.exe'
$downloadUrl = 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe'

New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null

Write-Host "Downloading cloudflared..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $cloudflaredPath

Write-Host "Installed: $cloudflaredPath"
& $cloudflaredPath --version
