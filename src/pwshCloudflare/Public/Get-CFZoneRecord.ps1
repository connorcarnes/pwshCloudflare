<#
.SYNOPSIS
    Retrieves DNS records for a Cloudflare zone.
.DESCRIPTION
    The Get-CFZoneRecord function retrieves DNS records for a Cloudflare zone. It can be used to get all DNS records for a specific zone by providing either the ZoneId or ZoneName parameter.
.PARAMETER ZoneId
    Specifies the ID of the Cloudflare zone for which to retrieve DNS records. This parameter is mandatory when using the ZoneId parameter set.
.PARAMETER ZoneName
    Specifies the name of the Cloudflare zone for which to retrieve DNS records. This parameter is mandatory when using the ZoneName parameter set.
.EXAMPLE
    Get-CFZoneRecord -ZoneId "1234567890"
    Retrieves all DNS records for the Cloudflare zone with the specified ZoneId.
.EXAMPLE
    Get-CFZoneRecord -ZoneName "example.com"
    Retrieves all DNS records for the Cloudflare zone with the specified ZoneName.
.INPUTS
    None.
.LINK
    https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records
#>
function Get-CFZoneRecord {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'ZoneId', Mandatory)]
        [string]$ZoneId,
        [Parameter(ParameterSetName = 'ZoneName', Mandatory)]
        [string]$ZoneName
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
            $ZoneId = $Script:cfZoneLookupTable[$ZoneName]
        }
        $Splat = @{
            Method     = 'GET'
            WebSession = $script:cfSession
            Uri        = '{0}/zones/{1}/dns_records' -f $Script:cfBaseApiUrl, $ZoneId
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.ZoneRecord') }
        $Result.result
    }
    end {}
}
