<#
.SYNOPSIS
    Gets Cloudflare D1 database(s).
.DESCRIPTION
    Gets Cloudflare D1 database(s). Must provide exactly one of AccountId or AccountName. If Name or Id is not specified, all databases will be returned.
.PARAMETER Name
    Name of database to retrieve. If not specified, all databases will be returned.
.PARAMETER Id
    ID of database to retrieve. If not specified, all databases will be returned.
.PARAMETER AccountId
    ID of account to retrieve. If not specified, all accounts will be returned.
.PARAMETER AccountName
    Name of account to retrieve. If not specified, all accounts will be returned.
.EXAMPLE
    Get-CFD1Database -AccountId '12345'
    Gets all databases for account with ID 12345.
.EXAMPLE
    Get-CFD1Database -AccountName 'My Account' -Name 'myDb'
    Gets databsse 'myDb' for account 'My Account'.
.EXAMPLE
    Get-CFD1Database -AccountName 'My Account' -Id '12345'
    Gets database with ID 12345 for account 'My Account'.
.NOTES
    The cloudflare-d1-list-databases API endpoint returns the properties uuid, name, version and created_at.
    The cloudflare-d1-get-database API endpoint returns the same properties as well as num_tables, file_size and running_in region.
    When listing all databases or getting a database by name this function makes multiple API calls. The first call is to get the database ID(s). The subsequent call(s) use the ID(s) to get the database details.
    This is done so that the same output is returned regardless of parameters used.
.LINK
    https://github.com/connorcarnes/pwshCloudflare
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-list-databases
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-get-database
#>
function Get-CFD1Database {
    [CmdletBinding()]
    [OutputType('Cloudflare.D1Database')]
    param(
        [Parameter(ParameterSetName = 'AccountName')]
        [Parameter(ParameterSetName = 'AccountId')]
        [Alias('DatabaseName')]
        [string]$Name,
        [Parameter(ParameterSetName = 'AccountName')]
        [Parameter(ParameterSetName = 'AccountId')]
        [Alias('DatabaseId')]
        [string]$Id,
        [Parameter(Mandatory, ParameterSetName = 'AccountId')]
        [string]$AccountId,
        [Parameter(Mandatory, ParameterSetName = 'AccountName')]
        [string]$AccountName
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
        if (($AccountId -and $AccountName) -or
            (-not $AccountId -and -not $AccountName) -or
            ($Name -and $Id)
        ) {
            throw 'Must provide exactly one of AccountId or AccountName and exactly one or none of Name or Id'
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
        if (-not $Id -and -not $Name) {
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
