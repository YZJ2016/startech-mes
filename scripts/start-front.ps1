# Start MES frontend dev servers (Windows PowerShell).
#   .\scripts\start-front.ps1                 start all
#   .\scripts\start-front.ps1 -f mes          Web admin :8084
#   .\scripts\start-front.ps1 -f pad          Pad H5    :8082
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
$MesRoot = Join-Path $Root 'yixiang-mes-system'

function Show-Usage {
    @"
Usage:
  .\scripts\start-front.ps1                 Start all frontend apps
  .\scripts\start-front.ps1 -f mes          Start Web admin (port 8084)
  .\scripts\start-front.ps1 -f pad          Start pad H5 (port 8082)
  .\scripts\start-front.ps1 -f mes -f pad   Start the listed apps
  .\scripts\start-front.ps1 -f pad -p 8002  Start pad H5 on port 8002

Flags:
  -f <app>    App to start. Repeatable. Values: mes, pad
  -p <port>   Override listen port (only with a single -f)
  -h          Show this help

Apps:
  mes   yixiang-mes-system/front   npm/pnpm run dev     http://localhost:8084
  pad   yixiang-mes-system/pad     uni-app H5           http://localhost:8082
"@
}

function Resolve-AppName([string]$Token) {
    switch ($Token) {
        { $_ -in @('mes', 'front') } { 'mes' }
        'pad' { 'pad' }
        default { $null }
    }
}

function Get-AppDir([string]$Name) {
    switch ($Name) {
        'mes' { Join-Path $MesRoot 'front' }
        'pad' { Join-Path $MesRoot 'pad' }
        default { $null }
    }
}

function Get-DefaultPort([string]$Name) {
    switch ($Name) {
        'mes' { 8084 }
        'pad' { 8082 }
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
        if ($Name -eq 'pad') {
            Write-Host '  pad is uni-app; H5 CLI start also needs @dcloudio/vue-cli-plugin-uni (or use HBuilderX).'
        }
        return $false
    }
    if ($Name -eq 'pad') {
        $bin = Join-Path $dir 'node_modules\.bin'
        $hasCli = (Test-Path (Join-Path $bin 'vue-cli-service')) -or (Test-Path (Join-Path $bin 'vue-cli-service.cmd'))
        if (-not $hasCli) {
            Write-Host '[pad] H5 CLI toolchain not found (vue-cli-service).'
            Write-Host '  Install @dcloudio/vue-cli-plugin-uni in yixiang-mes-system/pad, or run pad H5 from HBuilderX.'
            return $false
        }
    }
    return $true
}

function Start-AppHere([string]$Name, [int]$ListenPort) {
    $dir = Get-AppDir $Name
    Set-Location $dir
    $Host.UI.RawUI.WindowTitle = "MES $Name :$ListenPort"
    $env:port = "$ListenPort"
    $env:PORT = "$ListenPort"
    switch ($Name) {
        'mes' {
            $pm = Get-PackageManager $dir
            if ($pm -eq 'pnpm') { pnpm run dev -- --port $ListenPort } else { npm run dev -- --port $ListenPort }
        }
        'pad' {
            $env:NODE_ENV = 'development'
            $env:UNI_PLATFORM = 'h5'
            npx --no-install vue-cli-service uni-serve --port $ListenPort
        }
    }
}

function Get-ChildCommand([string]$Name, [int]$ListenPort) {
    $dir = Get-AppDir $Name
    $pm = Get-PackageManager $dir
    switch ($Name) {
        'mes' {
            "`$env:port='$ListenPort'; `$env:PORT='$ListenPort'; $pm run dev -- --port $ListenPort"
        }
        'pad' {
            "`$env:NODE_ENV='development'; `$env:UNI_PLATFORM='h5'; `$env:port='$ListenPort'; `$env:PORT='$ListenPort'; npx --no-install vue-cli-service uni-serve --port $ListenPort"
        }
    }
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
        Write-Host "Unknown app: $token (use mes or pad)"
        Show-Usage
        exit 1
    }
    if ($resolved -notcontains $name) {
        $resolved += $name
    }
}

$Explicit = $resolved.Count -gt 0
if ($resolved.Count -eq 0) {
    $Apps = @('mes', 'pad')
} else {
    $Apps = @($resolved)
}

if ($Port -ne 0 -and ($Port -lt 1 -or $Port -gt 65535)) {
    Write-Host "Invalid port: $Port"
    exit 1
}

if ($Port -gt 0 -and $Apps.Count -ne 1) {
    Write-Host '-p requires a single -f app'
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
$Apps = @($ready)

if ($Apps.Count -eq 1) {
    $name = $Apps[0]
    $listen = Get-ListenPort $name
    Write-Host "[$name] $(Get-AppDir $name)"
    Write-Host "[$name] http://localhost:$listen"
    Start-AppHere $name $listen
    exit 0
}

foreach ($name in $Apps) {
    $dir = Get-AppDir $name
    $listen = Get-ListenPort $name
    $inner = @"
Set-Location -LiteralPath '$dir'
`$Host.UI.RawUI.WindowTitle = 'MES $name :$listen'
$(Get-ChildCommand $name $listen)
"@
    Write-Host "[$name] opening window → http://localhost:$listen"
    Start-Process -FilePath 'powershell.exe' -WorkingDirectory $dir -ArgumentList @(
        '-NoExit',
        '-NoProfile',
        '-Command',
        $inner
    )
}

Write-Host "Started $($Apps.Count) frontend apps. Close each window to stop that service."
