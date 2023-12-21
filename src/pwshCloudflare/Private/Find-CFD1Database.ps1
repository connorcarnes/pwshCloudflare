function Find-CFD1Database {
    [CmdletBinding()]
    param(
        [Alias('DatabaseName')]
        [Parameter()]
        [string]$Name,
        [Parameter()]
        [string]$AccountId
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
    }
    process {
        $Uri = '{0}/accounts/{1}/d1/database' -f $Script:cfBaseApiUrl, $AccountId
        if ($Name) {
            $Uri = $Uri + "?name=$Name"
        }
        $Splat = @{
            Method = 'Get'
            Uri    = $Uri
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result
    }
    end {}
}