<#
.SYNOPSIS
    Get Cloudflare account information.
.DESCRIPTION
    Returns accounts available to the current user. Accounts can be specified by their name or id. All accounts are returned if name or id is not specified.
.PARAMETER Id
    ID of account to retrieve.
.PARAMETER Name
    Name of account to retrieve.
.EXAMPLE
    Get-CFAccount -AccountId '12345'
    Gets account with ID 12345.
.EXAMPLE
    Get-CFAccount
    Lists accounts available to current user.
.LINK
    https://github.com/connorcarnes/pwshCloudflare
.LINK
    https://developers.cloudflare.com/api/operations/accounts-list-accounts
.LINK
    https://developers.cloudflare.com/api/operations/accounts-account-details
#>
function Get-CFAccount {
    [CmdletBinding()]
    [OutputType('Cloudflare.Account')]
    param(
        [Parameter()]
        [Alias('AccountId')]
        [string]$Id,
        [Parameter()]
        [Alias('AccountName')]
        [string]$Name
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
    }
    process {
        if ($Name) {
            $Query = "?name=$Name"
            $Uri = '{0}/accounts{1}' -f $Script:cfBaseApiUrl, $Query
        }
        elseif ($Id) {
            $Uri = '{0}/accounts/{1}' -f $Script:cfBaseApiUrl, $Id
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
        # API returns empty result if name query succeeds but no account is found
        # We treat it as an error to avoid confusion and for consistency (ID endpoint errors if ID not found)
        if ($Name -and -not $Result.result) {
            throw "Cloudflare API returned null result for $Uri, check account name."
        }
        $Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.Account') }
        $Result.result
    }
    end {}
}
