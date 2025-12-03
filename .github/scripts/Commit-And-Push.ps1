param (
    [string]$FilePath = "README.md",
    [string]$Message = "Update apps table [skip ci]"
)

git add $FilePath
if (git diff --cached --quiet) {
    Write-Host "No changes to commit."
} else {
    git commit -m $Message
    git push
}
