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
        # Build app table
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

        # Build directory tree
        $tree = @("apps/")
        $items = Get-ChildItem $AppsDir -Directory
        for ($i = 0; $i -lt $items.Count; $i++) {
            $prefix = if ($i -eq $items.Count - 1) { "└──" } else { "├──" }
            $tree += "$prefix $($items[$i].Name)/".PadRight(20)
        }
        $treeMd = $tree -join "`n"
    }

    End {
        # Build Markdown table
        $tableMd = $table -join "`n"

        # Define markers
        $startTableMarker = "<!-- APPS_TABLE_START -->"
        $endTableMarker   = "<!-- APPS_TABLE_END -->"
        $startTreeMarker  = "<!-- APPS_TREE_START -->"
        $endTreeMarker    = "<!-- APPS_TREE_END -->"

        # Build replacement blocks
        $tableBlock = "$startTableMarker`n$tableMd`n$endTableMarker"
        $treeBlock  = "$startTreeMarker`n```````n$treeMd`n```````n$endTreeMarker"

        # Read README
        $content = Get-Content $ReadmePath -Raw -ErrorAction SilentlyContinue

        # Replace or append sections
        $content = if ($content) {
            $content = [regex]::Replace($content, [regex]::Escape($startTableMarker) + ".*?" + [regex]::Escape($endTableMarker), $tableBlock, 'Singleline')
            [regex]::Replace($content, [regex]::Escape($startTreeMarker) + ".*?" + [regex]::Escape($endTreeMarker), $treeBlock, 'Singleline')
        } else {
            "$tableBlock`n`n$treeBlock"
        }

        # Write result
        Set-Content -Path $ReadmePath -Value $content -Encoding utf8
    }
}

Update-AppsReadme -AppsDir $AppsDir -ReadmePath $ReadmePath
