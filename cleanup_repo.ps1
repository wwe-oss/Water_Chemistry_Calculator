Write-Host "=== Cleaning tracked build artifacts ==="

# Remove tracked build outputs
git rm -r --cached "src/WaterChem.CLI/bin"
git rm -r --cached "src/WaterChem.CLI/obj"

git rm -r --cached "src/WaterChem.Domain/bin"
git rm -r --cached "src/WaterChem.Domain/obj"

git rm -r --cached "src/WaterChem.Engine/bin"
git rm -r --cached "src/WaterChem.Engine/obj"

git rm -r --cached "tests/WaterChem.Domain.Tests/obj"
git rm -r --cached "tests/WaterChem.Engine.Tests/obj"

# VS Code junk
git rm --cached ".vscode/sessions.json"

# Workspace file (should stay local only)
git rm --cached "Water_Chemistry_Calculator.code-workspace"

Write-Host "=== Cleanup complete. Commit next. ==="
