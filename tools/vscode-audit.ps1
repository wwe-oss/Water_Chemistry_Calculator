#requires -Version 7.0
<#
  tools/vscode-audit.ps1
  Outputs: reports/vscode-extensions-audit.md
  Scope: VS Code extensions, workspace settings, dev tools snapshot
  Safe: Read-only (creates reports/ if missing)
#>

$ErrorActionPreference = 'Stop'

# ---------- Paths ----------
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot  = Resolve-Path (Join-Path $scriptDir '..') | Select-Object -ExpandProperty Path
$reportDir = Join-Path $repoRoot 'reports'
$report    = Join-Path $reportDir 'vscode-extensions-audit.md'
if (-not (Test-Path $reportDir)) { New-Item -ItemType Directory -Path $reportDir | Out-Null }

# ---------- Helpers ----------
function Try-Run {
  param(
    [Parameter(Mandatory)] [string] $Cmd,
    [string[]] $Args = @()
  )
  try {
    & $Cmd @Args 2>$null
  } catch {
    @()
  }
}

function Read-JsonFile {
  param([string] $Path)
  if (Test-Path $Path) {
    try { Get-Content -Raw -Path $Path | ConvertFrom-Json } catch { $null }
  } else {
    $null
  }
}

# ---------- Extensions inventory ----------
# Prefer CLI list; fallback to extension folders
$extCli = Try-Run -Cmd 'code' -Args @('--list-extensions','--show-versions')

$extList = @()
foreach ($line in $extCli) {
  if ($line -match '^(?<id>[^@]+)@(?<v>.+)$') {
    $extList += [PSCustomObject]@{ Id = $Matches.id; Version = $Matches.v }
  }
}

# If CLI was unavailable, attempt FS discovery
if ($extList.Count -eq 0) {
  $extRoot = Join-Path $env:USERPROFILE '.vscode\extensions'
  if (Test-Path $extRoot) {
    Get-ChildItem -Path $extRoot -Directory | ForEach-Object {
      # folder form: publisher.name-1.2.3
      if ($_.Name -match '^(?<id>.+)-(?<v>\d+\.\d+\.\d+.*)$') {
        $extList += [PSCustomObject]@{ Id = $Matches.id; Version = $Matches.v }
      }
    }
  }
}

# Pull metadata from package.json (if available)
function Read-ExtPkg {
  param([string] $Id, [string] $Version)
  $extRoot = Join-Path $env:USERPROFILE '.vscode\extensions'
  if (-not (Test-Path $extRoot)) { return $null }
  $folder = Get-ChildItem -Path $extRoot -Directory -Filter "$Id-$Version" -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $folder) {
    $folder = Get-ChildItem -Path $extRoot -Directory -Filter "$Id-*" -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1
  }
  if (-not $folder) { return $null }
  Read-JsonFile (Join-Path $folder.FullName 'package.json')
}

$extRows = @()
foreach ($e in ($extList | Sort-Object Id, Version)) {
  $pkg = Read-ExtPkg -Id $e.Id -Version $e.Version
  $deprecated   = $false
  $proposedApi  = $false
  $postInstall  = $false
  $languages    = ''
  $categories   = ''

  if ($pkg) {
    if ($pkg.PSObject.Properties.Name -contains 'deprecated' -and $pkg.deprecated -eq $true) { $deprecated = $true }
    if ($pkg.PSObject.Properties.Name -contains 'enableProposedApi' -and $pkg.enableProposedApi -eq $true) { $proposedApi = $true }
    if ($pkg.scripts) {
      $postInstall = ($pkg.scripts.PSObject.Properties.Name -contains 'postinstall')
    }
    if ($pkg.contributes -and $pkg.contributes.languages) {
      $languages = ($pkg.contributes.languages | ForEach-Object { $_.id }) -join ','
    }
    if ($pkg.categories) {
      $categories = ($pkg.categories) -join ', '
    }
  }

  $extRows += [PSCustomObject]@{
    Id          = $e.Id
    Version     = $e.Version
    Deprecated  = $deprecated
    ProposedAPI = $proposedApi
    PostInstall = $postInstall
    Languages   = $languages
    Categories  = $categories
  }
}

# ---------- Heuristics: conflicts/overlaps ----------
$findings = New-Object System.Collections.Generic.List[System.String]

function HasExt([string] $id) { return ($extRows | Where-Object { $_.Id -eq $id }).Count -gt 0 }

# Stable + Preview conflicts
if (HasExt 'ms-dotnettools.csharp' -and HasExt 'ms-dotnettools.csharp-preview') {
  $findings.Add('Conflict: C# stable and preview are both installed (ms-dotnettools.csharp, ms-dotnettools.csharp-preview). Keep one.')
}
if (HasExt 'ms-vscode.powershell' -and HasExt 'ms-vscode.powershell-preview') {
  $findings.Add('Conflict: PowerShell stable and preview are both installed (ms-vscode.powershell, ms-vscode.powershell-preview). Keep one.')
}

# Multiple Git helpers
$gitHelpers = @('eamodio.gitlens','donjayamanne.githistory','mhutchie.git-graph') | Where-Object { HasExt $_ }
if ($gitHelpers.Count -gt 1) {
  $findings.Add('Overlap: multiple Git helper extensions are installed: ' + ($gitHelpers -join ', ') + '. Consider keeping one.')
}

# Multiple test explorers
$testExpl = @('formulahendry.dotnet-test-explorer','hbenl.vscode-test-explorer') | Where-Object { HasExt $_ }
if ($testExpl.Count -gt 1) {
  $findings.Add('Overlap: multiple test explorers are installed: ' + ($testExpl -join ', ') + '. The built-in Test UI may be sufficient.')
}

# Multiple formatters (advisory)
$formatters = @('esbenp.prettier-vscode','dbaeumer.vscode-eslint','ms-dotnettools.csharp','redhat.vscode-yaml','redhat.vscode-xml','ms-python.black-formatter') | Where-Object { HasExt $_ }
if ($formatters.Count -gt 1) {
  $findings.Add('Overlap: multiple formatters present: ' + ($formatters -join ', ') + '. Set per-language default formatters to avoid conflicts.')
}

# Deprecated / Proposed / Postinstall
foreach ($r in ($extRows | Where-Object { $_.Deprecated }))   { $findings.Add('Deprecated: ' + $r.Id) }
foreach ($r in ($extRows | Where-Object { $_.ProposedAPI }))  { $findings.Add('Risk: ' + $r.Id + ' enables proposed API.') }
foreach ($r in ($extRows | Where-Object { $_.PostInstall }))  { $findings.Add('Risk: ' + $r.Id + ' declares a postinstall script.') }

# ---------- Workspace & project settings snapshot ----------
$vsDir      = Join-Path $repoRoot '.vscode'
$setPath    = Join-Path $vsDir 'settings.json'
$launchPath = Join-Path $vsDir 'launch.json'
$tasksPath  = Join-Path $vsDir 'tasks.json'
$extRecPath = Join-Path $vsDir 'extensions.json'

$settings   = Read-JsonFile $setPath
$launch     = Read-JsonFile $launchPath
$tasks      = Read-JsonFile $tasksPath
$extRec     = Read-JsonFile $extRecPath

$globalJson = Read-JsonFile (Join-Path $repoRoot 'global.json')
$dirBuildProps   = Test-Path (Join-Path $repoRoot 'Directory.Build.props')
$dirBuildTargets = Test-Path (Join-Path $repoRoot 'Directory.Build.targets')
$slnExists       = Test-Path (Join-Path $repoRoot 'Water_Chemistry_Calculator.sln')
$launchSettings  = Get-ChildItem -Recurse -Path $repoRoot -Filter 'launchSettings.json' -ErrorAction SilentlyContinue

# ---------- Dev tools snapshot ----------
$gitVersionArr    = Try-Run -Cmd 'git'   -Args @('--version')
$gitVersion       = if ($gitVersionArr) { ($gitVersionArr -join ' ') } else { 'not found' }

$codeVersionArr   = Try-Run -Cmd 'code'  -Args @('--version')
$codeVersionLine1 = if ($codeVersionArr) { ($codeVersionArr | Select-Object -First 1) } else { 'not found' }

$dotnetInfoArr    = Try-Run -Cmd 'dotnet' -Args @('--info')
$dotnetInfoHead   = if ($dotnetInfoArr) { $dotnetInfoArr | Select-Object -First 30 } else { @('not found') }

$pwshVersion      = $PSVersionTable.PSVersion.ToString()

# ---------- Build report ----------
$sb = New-Object System.Text.StringBuilder

$null = $sb.AppendLine('# VS Code Extensions Audit')
$null = $sb.AppendLine()
$null = $sb.AppendLine('Generated: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
$null = $sb.AppendLine()

$null = $sb.AppendLine('## Summary')
$null = $sb.AppendLine('- Extensions detected: **' + $extRows.Count + '**')
$null = $sb.AppendLine('- Solution present: **' + $slnExists + '**')
$null = $sb.AppendLine('- global.json present: **' + ([bool]$globalJson) + '**')
$null = $sb.AppendLine('- launchSettings.json files: **' + $launchSettings.Count + '**')
$null = $sb.AppendLine()

$null = $sb.AppendLine('## Findings')
if ($findings.Count -eq 0) {
  $null = $sb.AppendLine('_No conflicts/overlaps/deprecations detected by heuristics._')
} else {
  foreach ($f in $findings) { $null = $sb.AppendLine('- ' + $f) }
}
$null = $sb.AppendLine()

$null = $sb.AppendLine('## Extensions Inventory')
$null = $sb.AppendLine('| Id | Version | Deprecated | ProposedAPI | PostInstall | Languages |')
$null = $sb.AppendLine('|---|---:|:---:|:---:|:---:|---|')
foreach ($r in ($extRows | Sort-Object Id)) {
  $null = $sb.AppendLine('| ' + $r.Id + ' | ' + $r.Version + ' | ' + ($(if($r.Deprecated){'yes'}else{'no'})) + ' | ' + ($(if($r.ProposedAPI){'yes'}else{'no'})) + ' | ' + ($(if($r.PostInstall){'yes'}else{'no'})) + ' | ' + $r.Languages + ' |')
}
$null = $sb.AppendLine()

$null = $sb.AppendLine('## Workspace Settings (.vscode)')
$null = $sb.AppendLine('- settings.json keys: ' + ($(if($settings){ ($settings.PSObject.Properties.Name | Sort-Object) -join ', ' } else { 'none' })))
$null = $sb.AppendLine('- launch.json configurations: ' + ($(if($launch -and $launch.configurations){ $launch.configurations.Count } else { 0 })))
$null = $sb.AppendLine('- tasks.json tasks: ' + ($(if($tasks -and $tasks.tasks){ $tasks.tasks.Count } else { 0 })))
$null = $sb.AppendLine('- extensions.json recommendations: ' + ($(if($extRec -and $extRec.recommendations){ $extRec.recommendations.Count } else { 0 })))
$null = $sb.AppendLine()

$null = $sb.AppendLine('## Project Settings Snapshot')
$null = $sb.AppendLine('- global.json: ' + ($(if($globalJson){ ($globalJson | ConvertTo-Json -Compress) } else { 'not found' })))
$null = $sb.AppendLine('- Directory.Build.props present: ' + $dirBuildProps)
$null = $sb.AppendLine('- Directory.Build.targets present: ' + $dirBuildTargets)
$null = $sb.AppendLine('- launchSettings.json paths:')
foreach ($ls in $launchSettings) {
  $rel = $ls.FullName.Substring($repoRoot.Length).TrimStart('\','/')
  $null = $sb.AppendLine('  - ' + $rel)
}
$null = $sb.AppendLine()

$null = $sb.AppendLine('## Dev Tools')
$null = $sb.AppendLine('```')
$null = $sb.AppendLine('git:      ' + $gitVersion)
$null = $sb.AppendLine('pwsh:     ' + $pwshVersion)
$null = $sb.AppendLine('code:     ' + $codeVersionLine1)
$null = $sb.AppendLine('dotnet --info (first 30 lines):')
foreach ($ln in $dotnetInfoHead) { $null = $sb.AppendLine($ln) }
$null = $sb.AppendLine('```')
$null = $sb.AppendLine()

# ---------- Write file ----------
$sb.ToString() | Set-Content -Path $report -Encoding UTF8
Write-Host "Wrote report: $report"
