function Test-CloudflareSession {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'ImportedSession', Mandatory = $false)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,
        [Parameter(ParameterSetName = 'NewSession', Mandatory = $false)]
        [string]$Email,
        [Parameter(ParameterSetName = 'NewSession', Mandatory = $false)]
        [string]$ApiKey,
        [Parameter(ParameterSetName = 'NewSession', Mandatory = $false)]
        [string]$ApiToken
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'NewSession') {
            # Create a new WebRequestSession object
            $Session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            # Add headers to the session
            $Session.Headers.Add('Content-Type', 'application/json')
            if ($ApiKey) {
                $Session.Headers.Add('X-Auth-Key', $ApiKey)
            }
            if ($Email) {
                $Session.Headers.Add('X-Auth-Email', $Email)
            }
            if ($ApiToken) {
                $Session.Headers.Add('Authorization', "Bearer $ApiToken")
            }
        }

        $Output = [PSCustomObject]@{
            LegacyAuthSuccess = $false
            TokenAuthSuccess  = $false
            Session           = $Session
        }

        $NoToken = [string]::IsNullOrEmpty($Session.Headers['Authorization'])
        if ($NoToken) {
            Write-Verbose 'Skipping token auth test. No API token provided.'
        }
        else {
            $TokenAuthTest = Invoke-RestMethod -Uri "$Script:cfBaseApiUrl/user/tokens/verify"  -WebSession $Session
            $Output.TokenAuthSuccess = $TokenAuthTest.success
            if (-not $Output.TokenAuthSuccess) {
                Write-Error 'Invalid API Token provided.'
            }
        }

        $NoEmail = [string]::IsNullOrEmpty($Session.Headers['X-Auth-Email'])
        $NoApiKey = [string]::IsNullOrEmpty($Session.Headers['X-Auth-Key'])
        if ($NoEmail -and $NoApiKey) {
            Write-Verbose 'Skipping legacy auth test. No email or API key provided.'
        }
        elseif ($NoEmail -or $NoApiKey) {
            Write-Warning 'Only one of Email or API Key provided. Both are required for legacy auth (aka global api key auth).'
        }
        else {
            $LegacyAuthTest = Invoke-RestMethod -Uri "$Script:cfBaseApiUrl/user" -WebSession $Session
            $Output.LegacyAuthSuccess = $LegacyAuthTest.success
            if (-not $Output.LegacyAuthSuccess) {
                Write-Error 'Invalid Email and/or API Key provided.'
            }
        }

        $Output
    }

    end {}
}