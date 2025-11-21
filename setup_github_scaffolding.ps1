# Create GitHub scaffolding for Water Chemistry Calculator
Write-Host "Setting up GitHub scaffolding..." -ForegroundColor Cyan

$base = ".github"
$issueTemplateDir = "$base/ISSUE_TEMPLATE"

# Create folders if missing
if (!(Test-Path $base)) {
    New-Item -ItemType Directory -Path $base | Out-Null
    Write-Host "Created directory: $base"
}

if (!(Test-Path $issueTemplateDir)) {
    New-Item -ItemType Directory -Path $issueTemplateDir | Out-Null
    Write-Host "Created directory: $issueTemplateDir"
}

# Create Pull Request Template
$prTemplate = "$base/pull_request_template.md"
if (!(Test-Path $prTemplate)) {
@"
# Summary
Describe the change, the problem it solves, and the approach used.

# Type of Change
- [ ] Feature
- [ ] Bugfix
- [ ] Refactor
- [ ] Documentation
- [ ] Other

# Checklist
- [ ] Code follows repository standards
- [ ] No hard-coded constants added
- [ ] All new configs have schemas
- [ ] All math steps documented / auditable
- [ ] Unit tests added for new engine logic
- [ ] No UI regressions

# Testing
Explain tests performed and expected behavior.

# Notes
Anything reviewers should pay attention to.
"@ | Set-Content $prTemplate
    Write-Host "Created: $prTemplate"
} else {
    Write-Host "Skipped (already exists): $prTemplate"
}

# Create Bug Report Template
$bugTemplate = "$issueTemplateDir/bug_report.md"
if (!(Test-Path $bugTemplate)) {
@"
---
name: Bug Report
about: Report a problem in code, config, UI, calculations, or workflow
labels: bug
---

## Description
Detailed description of the issue.

## Steps to Reproduce
1.
2.
3.

## Expected Behavior


## Actual Behavior


## Logs / Screenshots


## Environment
- OS:
- Branch:
- Config versions:
- Equipment / Water source (if applicable)
"@ | Set-Content $bugTemplate
    Write-Host "Created: $bugTemplate"
} else {
    Write-Host "Skipped (already exists): $bugTemplate"
}

# Create Feature Request Template
$featureTemplate = "$issueTemplateDir/feature_request.md"
if (!(Test-Path $featureTemplate)) {
@"
---
name: Feature Request
about: Suggest a new feature or improvement
labels: enhancement
---

## Problem
Explain the limitation or challenge.

## Proposed Solution
Describe the change or new capability.

## Alternatives Considered


## Impact


## Additional Notes
"@ | Set-Content $featureTemplate
    Write-Host "Created: $featureTemplate"
} else {
    Write-Host "Skipped (already exists): $featureTemplate"
}

Write-Host "GitHub scaffolding setup complete." -ForegroundColor Green
