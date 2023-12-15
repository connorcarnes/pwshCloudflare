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
    https://developers.cloudflare.com/api/operations/accounts-list-accounts
.LINK
    https://developers.cloudflare.com/api/operations/accounts-account-details
#>
function Get-CFAccount {
    [CmdletBinding(DefaultParameterSetName = 'AccountId')]
    [OutputType('Cloudflare.Account')]
    param(
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
        if ($AccountId) {
            $Uri = '{0}/accounts/{1}' -f $Script:cfBaseApiUrl, $AccountId
        }
        else {
            $Uri = '{0}/accounts' -f $Script:cfBaseApiUrl
        }
        $Splat = @{
            Method     = 'GET'
            WebSession = $script:cfSession
            Uri        = $Uri
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.Account') }
        $Result.result
    }
    end {}
}
