# Start MES frontend dev server (Windows PowerShell).
#   .\scripts\start-front.ps1                 Web admin :80
#   .\scripts\start-front.ps1 -f mes          Web admin :80
#   .\scripts\start-front.ps1 -f mes -p 8002  Web admin on 8002
param(
    [switch]$Help,
    [Alias('f')]
    [string[]]$Frontend,
    [Alias('p')]
    [int]$Port
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $PSScriptRoot
$MesRoot = Join-Path $Root 'startech-mes-basic'

function Show-Usage {
    @"
Usage:
  .\scripts\start-front.ps1                 Start Web admin (port 80)
  .\scripts\start-front.ps1 -f mes          Start Web admin (port 80)
  .\scripts\start-front.ps1 -f mes -p 8002  Start Web admin on port 8002

Flags:
  -f <app>    App to start. Values: mes (aliases: front, frontend)
  -p <port>   Override listen port
  -h          Show this help

Apps:
  mes   startech-mes-basic/frontend   npm run dev     http://localhost:80
"@
}

function Resolve-AppName([string]$Token) {
    switch ($Token) {
        { $_ -in @('mes', 'front', 'frontend') } { 'mes' }
        default { $null }
    }
}

function Get-AppDir([string]$Name) {
    switch ($Name) {
        'mes' { Join-Path $MesRoot 'frontend' }
        default { $null }
    }
}

function Get-DefaultPort([string]$Name) {
    switch ($Name) {
        'mes' { 80 }
        default { 0 }
    }
}

function Get-ListenPort([string]$Name) {
    if ($Port -gt 0) { $Port } else { Get-DefaultPort $Name }
}

function Get-PackageManager([string]$Dir) {
    $lock = Join-Path $Dir 'pnpm-lock.yaml'
    if ((Test-Path $lock) -and (Get-Command pnpm -ErrorAction SilentlyContinue)) {
        'pnpm'
    } else {
        'npm'
    }
}

function Test-AppReady([string]$Name) {
    $dir = Get-AppDir $Name
    if (-not (Test-Path $dir)) {
        Write-Host "[$Name] app directory not found: $dir"
        return $false
    }
    if (-not (Test-Path (Join-Path $dir 'node_modules'))) {
        $pm = Get-PackageManager $dir
        Write-Host "[$Name] missing node_modules. Install first:"
        Write-Host "  cd `"$dir`""
        Write-Host "  $pm install"
        return $false
    }
    return $true
}

function Start-AppHere([string]$Name, [int]$ListenPort) {
    $dir = Get-AppDir $Name
    Set-Location $dir
    $Host.UI.RawUI.WindowTitle = "MES $Name :$ListenPort"
    $env:port = "$ListenPort"
    $env:PORT = "$ListenPort"
    $pm = Get-PackageManager $dir
    if ($pm -eq 'pnpm') { pnpm run dev -- --port $ListenPort } else { npm run dev -- --port $ListenPort }
}

if ($Help) {
    Show-Usage
    exit 0
}

$Frontend = @($Frontend | Where-Object { $_ })
$resolved = @()
foreach ($token in $Frontend) {
    $name = Resolve-AppName $token
    if (-not $name) {
        Write-Host "Unknown app: $token (use mes)"
        Show-Usage
        exit 1
    }
    if ($resolved -notcontains $name) {
        $resolved += $name
    }
}

$Explicit = $resolved.Count -gt 0
if ($resolved.Count -eq 0) {
    $Apps = @('mes')
} else {
    $Apps = @($resolved)
}

if ($Port -ne 0 -and ($Port -lt 1 -or $Port -gt 65535)) {
    Write-Host "Invalid port: $Port"
    exit 1
}

if (-not (Test-Path $MesRoot)) {
    Write-Host "MES project not found: $MesRoot"
    exit 1
}

$ready = @()
foreach ($name in $Apps) {
    if (Test-AppReady $name) {
        $ready += $name
    } elseif ($Explicit) {
        exit 1
    } else {
        Write-Host "[$name] skipped"
    }
}
if ($ready.Count -eq 0) {
    Write-Host 'No frontend app is ready to start.'
    exit 1
}

$name = $ready[0]
$listen = Get-ListenPort $name
Write-Host "[$name] $(Get-AppDir $name)"
Write-Host "[$name] http://localhost:$listen"
Start-AppHere $name $listen
