<# 
    GitHub Repository Scaffolding Script
    -----------------------------------
    Creates:
      .github/
        ├── ISSUE_TEMPLATE/
        │     ├── bug_report.md
        │     ├── feature_request.md
        │     └── SECURITY.md
        ├── pull_request_template.md
        ├── CONTRIBUTING.md
        └── labels.json
#>

Write-Host "=== Water Chemistry Calculator — GitHub Scaffolding ===" -ForegroundColor Cyan

# Base .github directory
$githubDir = ".github"
$issueDir  = ".github/ISSUE_TEMPLATE"

$dirs = @(
    $githubDir,
    $issueDir
)

foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        Write-Host "Creating directory: $d"
        New-Item -ItemType Directory -Path $d | Out-Null
    } else {
        Write-Host "Directory already exists: $d"
    }
}

# -------------------------------------------------------
# ISSUE TEMPLATES
# -------------------------------------------------------

$bugReport = @"
---
name: Bug Report
about: Report a problem with the Water Chemistry Calculator
labels: bug
---

## Description
Describe the bug clearly.

## Steps To Reproduce
1. 
2. 
3. 

## Expected Behavior
Describe what you expected to happen.

## Actual Behavior
Describe what actually happened.

## Screenshots (optional)

## Logs (optional)

"@

$featureRequest = @"
---
name: Feature Request
about: Suggest a new feature or improvement
labels: enhancement
---

## Summary
Describe the feature you want.

## Problem It Solves
Explain why this feature is useful.

## Proposed Solution
Describe how it could work.

## Alternatives Considered

## Additional Context

"@

$securityReport = @"
# Security Policy

## Reporting a Vulnerability
Please report security issues privately.

Do **not** open public GitHub issues for vulnerabilities.

"@

Set-Content -Path "$issueDir/bug_report.md" -Value $bugReport
Set-Content -Path "$issueDir/feature_request.md" -Value $featureRequest
Set-Content -Path "$issueDir/SECURITY.md" -Value $securityReport

Write-Host "Issue templates created." -ForegroundColor Green

# -------------------------------------------------------
# PULL REQUEST TEMPLATE
# -------------------------------------------------------

$prTemplate = @"
# Pull Request

## Description
Describe what this PR changes.

## Related Issue
Closes #ISSUE_NUMBER

## Validation
- [ ] Builds successfully
- [ ] Tests pass
- [ ] No sensitive data included
- [ ] PR follows project coding standards

## Additional Notes

"@

Set-Content -Path "$githubDir/pull_request_template.md" -Value $prTemplate
Write-Host "Pull request template created." -ForegroundColor Green

# -------------------------------------------------------
# CONTRIBUTING GUIDE
# -------------------------------------------------------

$contributing = @"
# Contributing Guide

Thank you for contributing to the Water Chemistry Calculator!

## Branch Strategy
- \`main\`: stable, production-ready.
- \`develop\`: active development.
- feature/\*: one branch per feature.

## Pull Requests
1. Create a feature branch.
2. Commit with conventional commit style.
3. Write tests for all new logic.
4. Open a Pull Request into \`develop\`.

## Code Style
- Use C#/.NET 8 conventions.
- Keep logic deterministic.
- All numerics must be precise (prefer decimal).
- Document all chemical formulas used.

"@

Set-Content -Path "$githubDir/CONTRIBUTING.md" -Value $contributing
Write-Host "CONTRIBUTING.md created." -ForegroundColor Green

# -------------------------------------------------------
# Labels JSON (optional)
# -------------------------------------------------------

$labelsJson = @"
[
  { "name": "bug",         "color": "d73a4a" },
  { "name": "enhancement", "color": "a2eeef" },
  { "name": "documentation","color": "0075ca" },
  { "name": "cleanup",     "color": "cfd3d7" }
]
"@

Set-Content -Path "$githubDir/labels.json" -Value $labelsJson
Write-Host "labels.json created." -ForegroundColor Green

Write-Host "=== GitHub scaffolding setup complete ===" -ForegroundColor Cyan
