#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'pwshCloudflare'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'pwshCloudflare' {
    Describe 'Test-CloudflareSession Function Tests' -Tag Unit {
        BeforeAll {
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            Mock Invoke-RestMethod { return [PSCustomObject]@{ success = $true } }
        }

        Context 'Success' {
            It 'Successfully tests token authentication' {
                $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                $session.Headers.Add('Authorization', 'Bearer validToken')
                $result = Test-CloudflareSession -Session $session
                $result.TokenAuthSuccess | Should -Be $true
            }

            It 'Successfully tests legacy authentication' {
                $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                $session.Headers.Add('X-Auth-Email', 'user@example.com')
                $session.Headers.Add('X-Auth-Key', 'validApiKey')
                $result = Test-CloudflareSession -Session $session
                $result.LegacyAuthSuccess | Should -Be $true
            }
        }

        Context 'Error' {
            It 'Fails token authentication with invalid token' {
                Mock Invoke-RestMethod { throw }
                $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                $session.Headers.Add('Authorization', 'Bearer invalidToken')
                { Test-CloudflareSession -Session $session } | Should -Throw
            }

            It 'Fails legacy authentication with invalid credentials' {
                Mock Invoke-RestMethod { throw }
                $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                $session.Headers.Add('X-Auth-Email', 'user@example.com')
                $session.Headers.Add('X-Auth-Key', 'invalidApiKey')
                { Test-CloudflareSession -Session $session } | Should -Throw
            }

            It 'Handles missing token and legacy credentials' {
                $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                $result = Test-CloudflareSession -Session $session
                $result.TokenAuthSuccess | Should -Be $false
                $result.LegacyAuthSuccess | Should -Be $false
            }
        }
    }
}
