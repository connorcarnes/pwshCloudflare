#https://developers.cloudflare.com/api/operations/zones-get
function Get-CFZone {
    [CmdletBinding()]
    [OutputType('Cloudflare.Zone')]
    param(
        [Parameter()]
        [string]$ZoneName
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
        if (-not $script:cfSession) {
            throw 'Cloudflare session not found. Use Set-CloudflareSession to create a session.'
        }
    }
    process {
        if ($ZoneName) {
            $Query = "?name=$ZoneName"
        }

        $Splat = @{
            Method     = 'GET'
            WebSession = $script:cfSession
            Uri        = '{0}/zones{1}' -f $Script:cfBaseApiUrl, $Query
        }
        $Result = Invoke-CFRestMethod @Splat
        $Result.result | ForEach-Object { $_.PSobject.TypeNames.Insert(0, 'Cloudflare.Zone') }
        $Result.result
    }
    end {}
}
