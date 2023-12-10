
function Invoke-CFRestMethod {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
        [string]$Method,
        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,
        [Parameter(Mandatory = $true)]
        [string]$Uri,
        [Parameter()]
        [object]$Body
    )
    #TRY RETURN result.result CATCH throw OBJ
    Invoke-RestMethod @PSBoundParameters
}
