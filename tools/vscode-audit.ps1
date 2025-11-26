#requires -Version 7.0
<#
  tools/vscode-audit.ps1
  Output:
    reports/vscode-extensions-audit-YYYYMMDD-HHmmss.md  (timestamped)
    reports/vscode-extensions-audit.latest.md           (rolling copy)
  Scope: VS Code extensions + workspace snapshot (read-only)
#>

param(
  [string]$OutDir,
  [string]$Prefix = 'vscode-extensions-audit',
  [switch]$NoLatestAlias
)

$ErrorActionPreference = 'Stop'

# ---------- Resolve paths (no complex param defaults) ----------
$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $OutDir -or $OutDir.Trim() -eq '') {
  $OutDir = Join-Path $repoRoot 'reports'
}
if (-not (Test-Path $OutDir)) {
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
}

$ts      = Get-Date -Format 'yyyyMMdd-HHmmss'
$outFile = Join-Path $OutDir ("{0}-{1}.md" -f $Prefix, $ts)
$latest  = Join-Path $OutDir ("{0}.latest.md" -f $Prefix)

# ---------- Helpers ----------
function Try-Run {
  param([Parameter(Mandatory)][string]$Cmd,[string[]]$Args=@())
  try { & $Cmd @Args 2>$null } catch { @() }
}

function Read-Json {
  param([string]$Path)
  if (Test-Path $Path) {
    try { Get-Content -Raw -Path $Path | ConvertFrom-Json } catch { $null }
  }
}

# ---------- Extensions (CLI-only) ----------
$extCli = Try-Run 'code' @('--list-extensions','--show-versions')
$exts = @()
foreach ($line in $extCli) {
  if ($line -match '^(?<id>[^@]+)@(?<v>.+)$') {
    $exts += [PSCustomObject]@{ Id = $Matches.id; Version = $Matches.v }
  }
}

# Presence map
$have = [System.Collections.Generic.HashSet[string]]::new()
$null = $exts | ForEach-Object { [void]$have.Add($_.Id) }

# ---------- Heuristics ----------
$findings = New-Object System.Collections.Generic.List[string]

# Conflicts: stable + preview (C# / PowerShell)
if ($have.Contains('ms-dotnettools.csharp') -and $have.Contains('ms-dotnettools.csharp-preview')) {
  $findings.Add('Conflict: both ms-dotnettools.csharp and ms-dotnettools.csharp-preview installed.')
}
if ($have.Contains('ms-vscode.powershell') -and $have.Contains('ms-vscode.powershell-preview')) {
  $findings.Add('Conflict: both ms-vscode.powershell and ms-vscode.powershell-preview installed.')
}

# Overlap: Git helpers
$gitHelpers = @('eamodio.gitlens','donjayamanne.githistory','mhutchie.git-graph') | Where-Object { $have.Contains($_) }
if ($gitHelpers.Count -gt 1) {
  $findings.Add('Overlap: multiple Git helpers: ' + ($gitHelpers -join ', ') + '.')
}

# Overlap: formatters (advisory)
$formatters = @('csharpier.csharpier-vscode','ms-dotnettools.csharp','esbenp.prettier-vscode','redhat.vscode-yaml','redhat.vscode-xml') | Where-Object { $have.Contains($_) }
if ($formatters.Count -gt 1) {
  $findings.Add('Overlap: multiple formatters present: ' + ($formatters -join ', ') + '. Pin per-language defaults to avoid conflicts.')
}

# ---------- Workspace snapshot (counts only; read-only) ----------
$vsDir      = Join-Path $repoRoot '.vscode'
$setPath    = Join-Path $vsDir 'settings.json'
$launchPath = Join-Path $vsDir 'launch.json'
$tasksPath  = Join-Path $vsDir 'tasks.json'
$extRecPath = Join-Path $vsDir 'extensions.json'

$settings = Read-Json $setPath
$launch   = Read-Json $launchPath
$tasks    = Read-Json $tasksPath
$extrec   = Read-Json $extRecPath

$globalJson     = Read-Json (Join-Path $repoRoot 'global.json')
$slnExists      = Test-Path (Join-Path $repoRoot 'Water_Chemistry_Calculator.sln')
$launchSettings = Get-ChildItem -Recurse -Path $repoRoot -Filter 'launchSettings.json' -ErrorAction SilentlyContinue

# ---------- Build report (simple string list; no nested interpolation) ----------
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('# VS Code Extensions Audit')
$lines.Add('')
$lines.Add('Generated: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
$lines.Add('')

$lines.Add('## Summary')
$lines.Add(('- Extensions detected: **{0}**' -f $exts.Count))
$lines.Add(('- Solution present: **{0}**' -f $slnExists))
$lines.Add(('- global.json present: **{0}**' -f ([bool]$globalJson)))
$lines.Add(('- launchSettings.json files: **{0}**' -f ($launchSettings.Count)))
$lines.Add('')

$lines.Add('## Findings')
if ($findings.Count -eq 0) {
  $lines.Add('_No conflicts/overlaps detected by heuristics._')
} else {
  foreach ($f in $findings) { $lines.Add('- ' + $f) }
}
$lines.Add('')

$lines.Add('## Extensions Inventory')
$lines.Add('| Id | Version |')
$lines.Add('|---|---:|')
foreach ($e in ($exts | Sort-Object Id)) {
  $lines.Add('| ' + $e.Id + ' | ' + $e.Version + ' |')
}
$lines.Add('')

$lines.Add('## Workspace Settings (.vscode)')
$lines.Add(('- settings.json keys: {0}' -f ($(if($settings){ ($settings.PSObject.Properties.Name | Sort-Object) -join ', ' } else { 'none' }))))
$lines.Add(('- launch.json configurations: {0}' -f ($(if($launch -and $launch.configurations){ $launch.configurations.Count } else { 0 }))))
$lines.Add(('- tasks.json tasks: {0}' -f ($(if($tasks -and $tasks.tasks){ $tasks.tasks.Count } else { 0 }))))
$lines.Add(('- extensions.json recommendations: {0}' -f ($(if($extrec -and $extrec.recommendations){ $extrec.recommendations.Count } else { 0 }))))
$lines.Add('')

$lines.Add('## Project Settings Snapshot')
$lines.Add('- global.json: ' + ($(if($globalJson){ ($globalJson | ConvertTo-Json -Compress) } else { 'not found' })))
$lines.Add('- launchSettings.json paths:')
foreach ($ls in $launchSettings) {
  $rel = $ls.FullName.Substring($repoRoot.Length).TrimStart('\','/')
  $lines.Add('  - ' + $rel)
}
$lines.Add('')

# ---------- Write files ----------
$lines | Set-Content -Path $outFile -Encoding UTF8
if (-not $NoLatestAlias) {
  $lines | Set-Content -Path $latest -Encoding UTF8
}

Write-Host ("wrote:   {0}" -f $outFile)
if (-not $NoLatestAlias) { Write-Host ("updated: {0}" -f $latest) }
