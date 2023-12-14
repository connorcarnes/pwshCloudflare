<#
.SYNOPSIS
    Updates a DNS record for a Cloudflare zone.
.DESCRIPTION
    The Set-CFZoneRecord function updates a DNS record for a Cloudflare zone using the Cloudflare API.
.PARAMETER RecordId
    The ID of the DNS record to update.
.PARAMETER ZoneId
    The ID of the Cloudflare zone.
.PARAMETER ZoneName
    The name of the Cloudflare zone.
.PARAMETER Content
    The content of the DNS record.
.PARAMETER Name
    The name of the DNS record.
.PARAMETER Type
    The type of the DNS record. Valid values are 'A', 'AAAA', 'CNAME', 'TXT', and 'MX'.
.PARAMETER TTL
    The Time To Live (TTL) of the DNS record in seconds. Setting to 1 means 'automatic'. Value must be between 60 and 86400, with the minimum reduced to 30 for Enterprise zones.
.PARAMETER Proxied
    Specifies whether the record is proxied through Cloudflare (orange cloud).
.PARAMETER Priority
    Required for MX, SRV, and URI records; unused by other record types. Records with lower priorities are preferred.
.EXAMPLE
    Set-CFZoneRecord -ZoneName example.com -RecordId 123abc456abc -Content 'UpdatedContent'
    This example updates the content for record with id 123abc456abc in the zone example.com to 'UpdatedContent'.
.LINK
    https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-patch-dns-record
#>
function Set-CFZoneRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RecordId,
        [Parameter(ParameterSetName = 'ZoneId', Mandatory)]
        [string]$ZoneId,
        [Parameter(ParameterSetName = 'ZoneName', Mandatory)]
        [string]$ZoneName,
        [Parameter()]
        [String]$Content,
        [Parameter()]
        [String]$Name,
        [Parameter()]
        [ValidateSet('A', 'AAAA', 'CNAME', 'TXT', 'MX')]
        [string]$Type,
        [Parameter(HelpMessage = "Time To Live (TTL) of the DNS record in seconds. Setting to 1 means 'automatic'. Value must be between 60 and 86400, with the minimum reduced to 30 for Enterprise zones.")]
        #[ValidateRange(60, 86400)]
        [int]$TTL,
        [Parameter(HelpMessage = 'Whether the record is proxied through Cloudflare (orange cloud)')]
        [bool]$Proxied,
        [Parameter()]
        [int]$Priority
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

        $Body = [PSCustomObject]@{}
        switch ($PSBoundParameters.Keys) {
            'Content' { $Body | Add-Member -MemberType NoteProperty -Name 'content'  -Value $PSBoundParameters.Content }
            'Name' { $Body | Add-Member -MemberType NoteProperty -Name 'name'     -Value $PSBoundParameters.Name }
            'Type' { $Body | Add-Member -MemberType NoteProperty -Name 'type'     -Value $PSBoundParameters.Type }
            'TTL' { $Body | Add-Member -MemberType NoteProperty -Name 'ttl'      -Value $PSBoundParameters.TTL }
            'Proxied' { $Body | Add-Member -MemberType NoteProperty -Name 'proxied'  -Value $PSBoundParameters.Proxied }
            'Priority' { $Body | Add-Member -MemberType NoteProperty -Name 'priority' -Value $PSBoundParameters.Priority }
        }
        $Splat = @{
            Body       = $Body | ConvertTo-Json
            Method     = 'PATCH'
            WebSession = $script:cfSession
            Uri        = '{0}/zones/{1}/dns_records/{2}' -f $Script:cfBaseApiUrl, $ZoneId, $RecordId
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.ZoneRecord') }
        $Result.result
    }
    end {}
}
