<#
.SYNOPSIS
    Get Cloudflare account information.
.DESCRIPTION
    Get Cloudflare account information.
.PARAMETER AccountId
    ID of account to retrieve. If not specified, all accounts will be returned.
.PARAMETER AccountName
    Name of account to retrieve. If not specified, all accounts will be returned.
.NOTES
    The cloudflare-d1-list-databases API endpoint returns the properties uuid, name, version and created_at.
    The cloudflare-d1-get-database API endpoint returns the same properties as well as num_tables, file_size and running_in region.
    When listing all databases or getting a database by name this function makes multiple API calls. The first call is to get the database ID(s). The subsequent call(s) use the ID(s) to get the database details.
    This is done so that the same output is returned regardless of parameters used.
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-list-databases
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-get-database
#>
function Get-CFD1Database {
    [CmdletBinding()]
    [OutputType('Cloudflare.D1Database')]
    param(
        [Parameter(ParameterSetName = 'AccountNameDatabaseName')]
        [Parameter(ParameterSetName = 'AccountIdDatabaseName')]
        [Alias('DatabaseName')]
        [string]$Name,
        [Parameter(ParameterSetName = 'AccountNameDatabaseId')]
        [Parameter(ParameterSetName = 'AccountIdDatabaseId')]
        [Alias('DatabaseId')]
        [string]$Id,
        [Parameter(ParameterSetName = 'ListAllByAccountId')]
        [Parameter(ParameterSetName = 'AccountIdDatabaseName')]
        [Parameter(ParameterSetName = 'AccountIdDatabaseId')]
        [string]$AccountId,
        [Parameter(ParameterSetName = 'ListAllByAccountName')]
        [Parameter(ParameterSetName = 'AccountNameDatabaseName')]
        [Parameter(ParameterSetName = 'AccountNameDatabaseId')]
        [string]$AccountName,
        [Parameter(ParameterSetName = 'ListAllByAccountName')]
        [Parameter(ParameterSetName = 'ListAllByAccountId')]
        [switch]$List
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
        $Splat = @{
            Method     = 'Get'
            WebSession = $script:cfSession
        }
        if ($List) {
            Write-Verbose "Listing all databases for account $AccountId"
            $FindResult = Find-CFD1Database -AccountId $AccountId
            $Output = [System.Collections.ArrayList]::new()
            foreach ($Database in $FindResult) {
                Write-Verbose "Getting details of database with id $($Database.uuid) for account $AccountId"
                $Uri = '{0}/accounts/{1}/d1/database/{2}' -f $Script:cfBaseApiUrl, $AccountId, $Database.uuid
                $Splat.Uri = $Uri
                $Result = Invoke-CFRestMethod @Splat
                [void]$Output.Add($Result.result)
            }
        }
        elseif ($Name) {
            Write-Verbose "Getting database with name $Name for account $AccountId"
            $FindResult = Find-CFD1Database -Name $Name -AccountId $AccountId
            $Uri = '{0}/accounts/{1}/d1/database/{2}' -f $Script:cfBaseApiUrl, $AccountId, $FindResult.uuid
            $Splat.Uri = $Uri
            Write-Verbose "Getting details of database with name $Name for account $AccountId"
            $Result = Invoke-CFRestMethod @Splat
            $Output = $Result.result
        }
        else {
            Write-Verbose "Getting details of database with $Id for account $AccountId"
            $Uri = '{0}/accounts/{1}/d1/database/{2}' -f $Script:cfBaseApiUrl, $AccountId, $Id
            $Splat.Uri = $Uri
            $Result = Invoke-CFRestMethod @Splat
            $Output = $Result.result
        }
        $Output | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.D1Database') }
        $Output
    }
    end {}
}
