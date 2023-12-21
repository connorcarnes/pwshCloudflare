Write-Host 'Loading profile...' -ForegroundColor Cyan
Import-Module posh-git
# PSReadline
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -Colors @{ InlinePrediction = '#2F7004' } #green
Set-PSReadLineOption -PredictionViewStyle ListView #you may prefer InlineView
# Custom prompt function
function prompt {
    <#
        .SYNOPSIS
        Custom prompt function.
        .EXAMPLE
        [2022-JUL-30 21:18][..project-starters\aws\aws-backup-automation][main ≡]
        >>
    #>
    $global:promptDateTime = [datetime]::Now
    $Global:promptDate = $global:promptDateTime.ToString('yyyy-MMM-dd').ToUpper()
    $Global:promptTime = $global:promptDateTime.ToString('HH:mm')
    # truncate the current location if too long
    $currentDirectory = $executionContext.SessionState.Path.CurrentLocation.Path
    $consoleWidth = [Console]::WindowWidth
    $maxPath = [int]($consoleWidth / 4.5)
    if ($currentDirectory.Length -gt $maxPath) {
        $currentDirectory = '..' + $currentDirectory.SubString($currentDirectory.Length - $maxPath)
    }
    $global:promptPath = $currentDirectory

    $InGitRepo = Write-VcsStatus
    if ($InGitRepo) {
        Write-Host "[$global:promptDate $global:promptTime]" -ForegroundColor Green -NoNewline
        Write-Host "[$global:promptPath]" -ForegroundColor Magenta -NoNewline
        Write-Host $InGitRepo.Trim() -NoNewline
        "`r`n>>"
    }
    else {
        Write-Host "[$global:promptDate $global:promptTime]" -ForegroundColor Green -NoNewline
        Write-Host "[$global:promptPath]" -ForegroundColor Magenta -NoNewline
        "`r`n>>"
    }
}