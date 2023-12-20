<#
.SYNOPSIS
    Creates Cloudflare D1 database.
.DESCRIPTION
    Creates Cloudflare D1 database.
.PARAMETER Name
    Name of database to create.
.PARAMETER AccountId
    ID of account to retrieve. If not specified, all accounts will be returned.
.PARAMETER AccountName
    Name of account to retrieve. If not specified, all accounts will be returned.
.EXAMPLE
    New-CFD1Database -Name 'myDb' -AccountId '12345'
    Creates database 'myDb' for account with ID 12345.
.EXAMPLE
    New-CFD1Database -Name 'myDb' -AccountName 'My Account'
    Creates database 'myDb' for account 'My Account'.
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-create-database
#>
function New-CFD1Database {
    [CmdletBinding()]
    [OutputType('Cloudflare.D1Database')]
    param(
        [Alias('DatabaseName')]
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory, ParameterSetName = 'AccountId')]
        [string]$AccountId,
        [Parameter(Mandatory, ParameterSetName = 'AccountName')]
        [string]$AccountName
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
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
