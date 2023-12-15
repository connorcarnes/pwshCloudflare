<#
.SYNOPSIS
    Get Cloudflare account information.
.DESCRIPTION
    Get Cloudflare account information.
.PARAMETER AccountId
    ID of account to retrieve. If not specified, all accounts will be returned.
.PARAMETER AccountName
    Name of account to retrieve. If not specified, all accounts will be returned.
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-create-database
#>
function New-CFD1Database {
    [CmdletBinding()]
    [OutputType('Cloudflare.D1Database')]
    param(
        [Alias('DatabaseName')]
        [Parameter()]
        [string]$Name,
        [Parameter(ParameterSetName = 'AccountId')]
        [string]$AccountId,
        [Parameter(ParameterSetName = 'AccountName')]
        [string]$AccountName
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
        if (-not $script:cfSession) {
            throw 'Cloudflare session not found. Use Set-CloudflareSession to create a session.'
        }
    }
    process {
        if ($AccountName) {
            $AccountId = $Script:cfAccountLookupTable[$AccountName]
        }
        $Body = [PSCustomObject]@{
            name = $Name
        }
        $Splat = @{
            Body       = $Body | ConvertTo-Json
            Method     = 'POST'
            WebSession = $script:cfSession
            Uri        = '{0}/accounts/{1}/d1/database' -f $Script:cfBaseApiUrl, $AccountId
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.D1Database') }
        $Result.result
    }
    end {}
}
