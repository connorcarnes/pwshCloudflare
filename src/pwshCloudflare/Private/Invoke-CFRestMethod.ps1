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
    #TRY RETURN result.result CATCH throw OBJ
    Invoke-RestMethod @PSBoundParameters
}
