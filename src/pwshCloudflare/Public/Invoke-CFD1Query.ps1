﻿<#
.SYNOPSIS
    Get Cloudflare account information.
.DESCRIPTION
    Get Cloudflare account information.
.PARAMETER AccountId
    ID of account to retrieve. If not specified, all accounts will be returned.
.PARAMETER AccountName
    Name of account to retrieve. If not specified, all accounts will be returned.
.LINK
    https://developers.cloudflare.com/api/operations/cloudflare-d1-query-database
.LINK
    https://developers.cloudflare.com/d1/platform/client-api
.LINK
    https://developers.cloudflare.com/d1/learning/querying-json/
#>
function Invoke-CFD1Query {
    [CmdletBinding()]
    #[OutputType('Cloudflare.D1Database')]
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
        $Sql = 'CREATE TABLE IF NOT EXISTS users (id integer PRIMARY KEY AUTOINCREMENT, userName text NOT NULL);'
        $Sql2 = "INSERT INTO users (userName) VALUES ('JohnDoe');"
        $Sql3 = 'SELECT ?1 FROM users;'
        $QueryParams = @()
        $QueryParams += 'JohnDoe'
        $Body = [PSCustomObject]@{
            sql    = $Sql3
            params = $QueryParams
        }
        $Splat = @{
            Body       = $Body | ConvertTo-Json
            Method     = 'POST'
            WebSession = $script:cfSession
            Uri        = '{0}/accounts/{1}/d1/database/{2}/query' -f $Script:cfBaseApiUrl, $AccountId, $Id
        }
        $Result = Invoke-CFRestMethod @Splat
        #$Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.D1Database') }
        $Result.result
    }
    end {}
}