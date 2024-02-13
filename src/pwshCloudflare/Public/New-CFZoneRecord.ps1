<#
.SYNOPSIS
    Creates a new DNS record for a Cloudflare zone.
.DESCRIPTION
    The New-CFZoneRecord function creates a new DNS record for a Cloudflare zone. It supports creating records by either ZoneId or ZoneName. The function requires the Content, Name, Type, TTL, and Proxied parameters to be specified. Additional parameters are required for specific record types (MX, SRV, and URI).
.PARAMETER ZoneId
    Specifies the ID of the Cloudflare zone where the DNS record will be created. This parameter is mandatory when using the ZoneId parameter set.
.PARAMETER ZoneName
    Specifies the name of the Cloudflare zone where the DNS record will be created. This parameter is mandatory when using the ZoneName parameter set.
.PARAMETER Content
    Specifies the content of the DNS record.
.PARAMETER Name
    Specifies the name of the DNS record.
.PARAMETER Type
    Specifies the type of the DNS record. Valid values are 'A', 'AAAA', 'CNAME', 'TXT', and 'MX'.
.PARAMETER TTL
    Specifies the Time To Live (TTL) of the DNS record in seconds. Setting it to 1 means 'automatic'. The value must be between 60 and 86400, with the minimum reduced to 30 for Enterprise zones.
.PARAMETER Proxied
    Specifies whether the record is proxied through Cloudflare (orange cloud).
.PARAMETER Priority
    Required for MX, SRV, and URI records; unused by other record types. Records with lower priorities are preferred.
.EXAMPLE
    New-CFZoneRecord -ZoneId '1234567890abcdef' -Content '192.168.1.1' -Name 'example.com' -Type 'A' -TTL 3600 -Proxied $true
    Creates a new 'A' record with the specified parameters in the Cloudflare zone with the ID '1234567890abcdef'.
.EXAMPLE
    New-CFZoneRecord -ZoneName 'example.com' -Content 'mail.example.com' -Name 'example.com' -Type 'MX' -TTL 3600 -Proxied $false -Priority 10
    Creates a new 'MX' record with the specified parameters in the Cloudflare zone with the name 'example.com'.
.LINK
    https://github.com/connorcarnes/pwshCloudflare
.LINK
    https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-create-dns-record
#>
function New-CFZoneRecord {
    [CmdletBinding()]
    [OutputType('Cloudflare.ZoneRecord')]
    param(
        [Parameter(ParameterSetName = 'ZoneId', Mandatory)]
        [string]$ZoneId,
        [Parameter(ParameterSetName = 'ZoneName', Mandatory)]
        [string]$ZoneName,
        [Parameter(Mandatory)]
        [String]$Content,
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [ValidateSet('A', 'AAAA', 'CNAME', 'TXT', 'MX')]
        [string]$Type,
        [Parameter(HelpMessage = "Time To Live (TTL) of the DNS record in seconds. Setting to 1 means 'automatic'. Value must be between 60 and 86400, with the minimum reduced to 30 for Enterprise zones.")]
        #[ValidateRange(60, 86400)]
        [int]$TTL,
        [Parameter(HelpMessage = 'Whether the record is proxied through Cloudflare (orange cloud)')]
        [bool]$Proxied
    )
    DynamicParam {
        if ($Type -in 'MX', 'SRV', 'URI') {
            # https://powershellmagazine.com/2014/05/29/dynamic-parameters-in-powershell/
            # https://adamtheautomator.com/powershell-parameter-validation/
            $priorityAttribute = New-Object System.Management.Automation.ParameterAttribute
            $priorityAttribute.HelpMessage = 'Required for MX, SRV and URI records; unused by other record types. Records with lower priorities are preferred.'
            $priorityAttribute.Mandatory = $true
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($priorityAttribute)
            $attributeCollection.Add((New-Object System.Management.Automation.ValidateRangeAttribute(0, 65535)))
            $priorityParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Priority', [int], $attributeCollection)
            $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('Priority', $priorityParam)
            return $paramDictionary
        }
    }
    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
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
            Method     = 'POST'
            WebSession = $script:cfSession
            Uri        = '{0}/zones/{1}/dns_records' -f $Script:cfBaseApiUrl, $ZoneId
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.ZoneRecord') }
        $Result.result
    }
    end {}
}
