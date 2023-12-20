<#
.SYNOPSIS
    Deletes a Cloudflare D1 database.
.DESCRIPTION
    Get Cloudflare account information.
.PARAMETER Name
    Name of database to delete.
.PARAMETER Id
    ID of database to delete.
.PARAMETER AccountId
    ID of account to retrieve. If not specified, all accounts will be returned.
.PARAMETER AccountName
    Name of account to retrieve. If not specified, all accounts will be returned.
.EXAMPLE
    Remove-CFD1Database -Name 'myDb' -AccountId '12345'
    Deletes database 'myDb' for account with ID 12345.
.EXAMPLE
    Remove-CFD1Database -Name 'myDb' -AccountName 'My Account'
    Deletes database 'myDb' for account 'My Account'.
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-delete-database
#>
function Remove-CFD1Database {
    [CmdletBinding()]
    [OutputType('Cloudflare.D1Database')]
    param(
        [Alias('DatabaseName')]
        [Parameter()]
        [string]$Name,
        [Alias('DatabaseId')]
        [Parameter()]
        [string]$Id,
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
        if ($Name) {
            $Id = (Find-CFD1Database -Name $Name -AccountId $AccountId).uuid
        }
        $Splat = @{
            Method = 'DELETE'
            Uri    = '{0}/accounts/{1}/d1/database/{2}' -f $Script:cfBaseApiUrl, $AccountId, $Id
        }

        $null = Invoke-CFRestMethod @Splat
    }
    end {}
}
