param (
    [string]$AppsDir = "apps",
    [string]$ReadmePath = "README.md"
)

function Update-AppsReadme {
    param (
        [string]$AppsDir,
        [string]$ReadmePath
    )

    Begin {
        $table = @()
        $table += "| App | Ansible | Compose | Image | Last Commit |"
        $table += "| --- | --- | --- | --- | --- |"
    }

    Process {
        Get-ChildItem $AppsDir -Directory | ForEach-Object {
            $app = $_.Name
            $appPath = $_.FullName

            $ansible = if (Test-Path "$appPath/ansible") { "✅" } else { "" }
            $compose = if (Test-Path "$appPath/compose") { "✅" } else { "" }
            $image   = if (Test-Path "$appPath/image")   { "✅" } else { "" }

            $gitDate = ""
            if (Test-Path "$appPath/.git") {
                $gitDate = git -C $appPath log -1 --format="%cd" --date=short
            } elseif (Test-Path ".git") {
                $gitDate = git log -1 --format="%cd" --date=short -- $appPath 2>$null
            }

            $table += "| $app | $ansible | $compose | $image | $gitDate |"
        }
    }

    End {
        $tableMd = $table -join "`n"
        $startMarker = "<!-- APPS_TABLE_START -->"
        $endMarker = "<!-- APPS_TABLE_END -->"

        if (Get-Content $ReadmePath -Raw -ErrorAction SilentlyContinue | Select-String $startMarker) {
            $content = Get-Content $ReadmePath -Raw
            $pattern = [regex]::Escape($startMarker) + ".*?" + [regex]::Escape($endMarker)
            $replacement = "$startMarker`n$tableMd`n$endMarker"
            $newContent = [regex]::Replace($content, $pattern, $replacement, [Text.RegularExpressions.RegexOptions]::Singleline)
        } else {
            $newContent = "$startMarker`n$tableMd`n$endMarker"
        }

        Set-Content -Path $ReadmePath -Value $newContent -Encoding utf8
    }
}

Update-AppsReadme -AppsDir $AppsDir -ReadmePath $ReadmePath
