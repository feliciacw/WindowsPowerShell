# ---------------------------------------------------------------------------
# PowerShell Profile
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# PSReadLine — history search, tab completion, predictions
# ---------------------------------------------------------------------------
if ($host.Name -eq 'ConsoleHost') {
    Set-PSReadLineOption -MaximumHistoryCount 4000
    Set-PSReadLineOption -HistoryNoDuplicates:$true

    # PredictionSource requires PSReadLine 2.1+
    if ((Get-Module PSReadLine).Version -ge [version]'2.1.0') {
        Set-PSReadLineOption -PredictionSource History
    }

    Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete
    Set-PSReadLineKeyHandler -Chord 'Shift+Tab' -Function Complete
}

# ---------------------------------------------------------------------------
# Modules
# ---------------------------------------------------------------------------

# Git prompt support
Import-Module Posh-Git -ErrorAction SilentlyContinue

# Colorized directory listings (modern replacement for PSColor)
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# Profile reload/edit helpers
Import-Module Profile -ErrorAction SilentlyContinue

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
Set-Alias n notepad.exe

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------
function prompt {
    $dir = (Get-Location).Path
    $host.UI.RawUI.WindowTitle = $dir

    $gitBranch = ''
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) { $gitBranch = " ($branch)" }
    }

    Write-Host -NoNewline -ForegroundColor Green "PS "
    Write-Host -NoNewline -ForegroundColor Cyan $dir
    Write-Host -NoNewline -ForegroundColor Yellow $gitBranch
    return ' > '
}
