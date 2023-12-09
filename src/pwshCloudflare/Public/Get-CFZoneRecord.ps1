# https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records
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
        $Result.result
    }
    end {}
}
