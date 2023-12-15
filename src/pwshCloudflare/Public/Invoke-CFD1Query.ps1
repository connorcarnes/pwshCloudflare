<#
.SYNOPSIS
    Executes a SQL query against a Cloudflare D1 database.
.DESCRIPTION
    Executes a SQL query against a Cloudflare D1 database. Must include a query as well as the account name or id as well as the database name or id.
.PARAMETER Name
    The name of the database to query.
.PARAMETER Id
    The ID of the database to query.
.PARAMETER AccountId
    The ID of the account that owns the database.
.PARAMETER AccountName
    The name of the account that owns the database.
.PARAMETER Query
    The SQL query to execute.
.PARAMETER QueryParams
    The parameters to pass to the query.
.EXAMPLE
    $Query = 'CREATE TABLE IF NOT EXISTS users (id integer PRIMARY KEY AUTOINCREMENT, userName text NOT NULL);'
    Invoke-CFD1Query -AccountName 'myAccount' -Name 'myDb' -Query $Query
    Creates a 'users' table in the 'myDb' database.
.EXAMPLE
    $Query = "INSERT INTO users (userName) VALUES ('JohnDoe');"
    Invoke-CFD1Query -AccountName 'myAccount' -Name 'myDb' -Query $Query
    Inserts a user with username 'JohnDoe' into the 'users' table of the 'myDb' database.
.EXAMPLE
    $Query       = 'SELECT ?1 FROM users;'
    $QueryParams = @('JohnDoe')
    Invoke-CFD1Query -AccountName 'myAccount' -Name 'myDb' -Query $Query -QueryParams $QueryParams
    Returns the user with username 'JohnDoe' from the 'users' table of the 'myDb' database.
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-query-database
.LINK
    https://developers.cloudflare.com/d1/platform/client-api
.LINK
    https://developers.cloudflare.com/d1/learning/querying-json/
#>
function Invoke-CFD1Query {
    [CmdletBinding()]
    [OutputType('Cloudflare.D1QueryResult')]
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
        [string]$AccountName,
        [Parameter(Mandatory = $true)]
        [string]$Query,
        [Parameter()]
        [string[]]$QueryParams
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
        $Body = [PSCustomObject]@{
            sql = $Query
        }
        if ($QueryParams) {
            $Body | Add-Member -MemberType NoteProperty -Name 'params' -Value $QueryParams
        }
        $Splat = @{
            Body       = $Body | ConvertTo-Json
            Method     = 'POST'
            WebSession = $script:cfSession
            Uri        = '{0}/accounts/{1}/d1/database/{2}/query' -f $Script:cfBaseApiUrl, $AccountId, $Id
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.Result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.D1QueryResult') }
        $Result.Result
    }
    end {}
}
