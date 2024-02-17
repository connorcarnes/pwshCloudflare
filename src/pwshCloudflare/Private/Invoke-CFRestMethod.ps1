<#
.SYNOPSIS
    Invoke-RestMethod wrapper for the Cloudflare API.
.DESCRIPTION
    Invoke-RestMethod wrapper for the Cloudflare API.
.PARAMETER Method
    Specifies the HTTP method to be used for the API request. Valid values are 'GET', 'POST', 'PUT', 'PATCH', and 'DELETE'.
.PARAMETER WebSession
    Specifies the web session to be used for the API request. This parameter is optional and can be used to provide a custom web session object.
.PARAMETER Uri
    Specifies the URI of the API endpoint to send the request to.
.PARAMETER Body
    Specifies the request body to be included in the API request. This parameter is optional and can be used to send data in the request body.
.EXAMPLE
    Invoke-CFRestMethod -Method 'GET' -Uri 'https://api.cloudflare.com/client/v4/zones'
    This example sends a GET request to the Cloudflare API to retrieve information about all zones.
#>
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
    try {
        if (-not $PSBoundParameters['WebSession']) {
            $PSBoundParameters.Add('WebSession', $script:cfSession)
        }
        Write-Verbose "Uri: $($PSBoundParameters['Uri'])"
        Write-Verbose "Method: $($PSBoundParameters['Method'])"
        Invoke-RestMethod @PSBoundParameters
    }
    catch {
        if ($_.ErrorDetails.Message -eq 'page not found') {
            # TODO: This could be that the resource doesn't exists, for example if the user input
            # the wrong database name. Update this error handling to dump $PsBoundParameters to
            # give the user more information about what went wrong.
            throw $_
        }
        $ApiError = $_.ErrorDetails.Message | ConvertFrom-Json
        if ($ApiError.errors.count -eq 1) {
            throw "Cloudflare API returned error code $($ApiError.errors.code) with message: $($ApiError.errors.message)"
        }
        else {
            # Cloudflare API returned multiple errors. Update function to handle this scenario.
            throw $_
        }
    }
}
