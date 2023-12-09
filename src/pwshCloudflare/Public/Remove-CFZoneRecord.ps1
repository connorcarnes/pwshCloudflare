# https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records
function Remove-CFZoneRecord {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'ZoneId', Mandatory)]
        [string]$ZoneId,
        [Parameter(ParameterSetName = 'ZoneName', Mandatory)]
        [string]$ZoneName,
        [Parameter(Mandatory)]
        [String]$RecordId
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
            Method     = 'DELETE'
            WebSession = $script:cfSession
            Uri        = '{0}/zones/{1}/dns_records/{2}' -f $Script:cfBaseApiUrl, $ZoneId, $RecordId
        }
        $null = Invoke-CFRestMethod @Splat
    }
    end {}
}
