# https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records
function New-CFZoneRecord {
    [CmdletBinding()]
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
            Method     = 'POST'
            WebSession = $script:cfSession
            Uri        = '{0}/zones/{1}/dns_records' -f $Script:cfBaseApiUrl, $ZoneId
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result
    }
    end {}
}
