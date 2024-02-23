<#
.SYNOPSIS
    Removes a DNS record from a Cloudflare zone.
.DESCRIPTION
    The Remove-CFZoneRecord function removes a DNS record from a Cloudflare zone. It can be used to delete a specific DNS record by providing the ZoneId and RecordId parameters, or by providing the ZoneName and RecordId parameters.
.PARAMETER ZoneId
    The ID of the Cloudflare zone from which the DNS record should be removed. This parameter is mandatory when using the ZoneId parameter set.
.PARAMETER ZoneName
    The name of the Cloudflare zone from which the DNS record should be removed. This parameter is mandatory when using the ZoneName parameter set.
.PARAMETER RecordId
    The ID of the DNS record to be removed. This parameter is mandatory.
.EXAMPLE
    Remove-CFZoneRecord -ZoneId "123456789" -RecordId "987654321"
    Removes the DNS record with the specified RecordId from the Cloudflare zone with the specified ZoneId.
.EXAMPLE
    Remove-CFZoneRecord -ZoneName "example.com" -RecordId "987654321"
    Removes the DNS record with the specified RecordId from the Cloudflare zone with the specified ZoneName.
.LINK
    https://github.com/connorcarnes/pwshCloudflare
.LINK
    https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-delete-dns-record
#>
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
