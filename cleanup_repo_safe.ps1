Write-Host "=== Water Chemistry Repo Cleanup (Safe Mode) ===" -ForegroundColor Cyan

$targets = @(
    "src/WaterChem.CLI/bin",
    "src/WaterChem.CLI/obj",
    "src/WaterChem.Domain/bin",
    "src/WaterChem.Domain/obj",
    "src/WaterChem.Engine/bin",
    "src/WaterChem.Engine/obj",
    "tests/WaterChem.Domain.Tests/obj",
    "tests/WaterChem.Engine.Tests/obj",
    ".vscode/sessions.json",
    "Water_Chemistry_Calculator.code-workspace"
)

Write-Host "`n--- DRY RUN: The following tracked files WOULD BE removed ---" -ForegroundColor Yellow

foreach ($t in $targets) {
    git ls-files --error-unmatch $t 2>$null | ForEach-Object {
        Write-Host "Would remove: $_"
    }
}

Write-Host "`nDry run complete.`n" -ForegroundColor Yellow
$confirm = Read-Host "Proceed with ACTUAL cleanup? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Cleanup cancelled." -ForegroundColor Red
    exit
}

Write-Host "`n--- Performing cleanup ---" -ForegroundColor Green

foreach ($t in $targets) {
    git rm -r --cached $t 2>$null
}

Write-Host "`nCleanup finished. Run:" -ForegroundColor Green
Write-Host "    git add .gitignore"
Write-Host "    git commit -m 'chore(repo): safe cleanup of tracked build artifacts'" -ForegroundColor Cyan
Write-Host "    git push" -ForegroundColor Cyan
