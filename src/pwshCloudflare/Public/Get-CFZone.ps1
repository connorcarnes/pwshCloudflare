<#
.SYNOPSIS
    Retrieves information about a Cloudflare zone.

.DESCRIPTION
    The Get-CFZone function queries the Cloudflare API to retrieve information about a specific zone.
    It can query zones based on either the zone name or the zone ID.

.PARAMETER ZoneName
    The name of the zone to retrieve. This parameter is mutually exclusive with ZoneID.

.PARAMETER ZoneID
    The unique identifier of the zone to retrieve. This parameter is mutually exclusive with ZoneName.

.EXAMPLE
    PS> Get-CFZone -ZoneName "example.com"
    This example retrieves information about the zone named "example.com".

.EXAMPLE
    PS> Get-CFZone -ZoneID "1234567890abcdef1234567890abcdef"
    This example retrieves information about the zone with the ID "1234567890abcdef1234567890abcdef".

.OUTPUTS
    Cloudflare.Zone

.LINK
    https://developers.cloudflare.com/api/operations/zones-get
#>
function Get-CFZone {
    [CmdletBinding()]
    [OutputType('Cloudflare.Zone')]
    param(
        [Parameter()]
        [string]$ZoneName,
        [Parameter()]
        [string]$ZoneID
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
        if (-not $script:cfSession) {
            throw 'Cloudflare session not found. Use Set-CloudflareSession to create a session.'
        }
    }
    process {
        if ($ZoneName) {
            $Query = "?name=$ZoneName"
        }
        if ($ZoneID) {
            $Query = "?id=$ZoneID"
        }

        $Splat = @{
            Method     = 'GET'
            WebSession = $script:cfSession
            Uri        = '{0}/zones{1}' -f $Script:cfBaseApiUrl, $Query
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.Zone') }
        $Result.result
    }
    end {}
}
