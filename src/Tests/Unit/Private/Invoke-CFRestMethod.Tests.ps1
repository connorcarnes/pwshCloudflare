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
    Describe 'Invoke-CFRestMethod Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            Mock Invoke-RestMethod
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        }
        Context 'Success' {
            It 'should call Invoke-RestMethod with <Method>' -TestCases @(
                @{ Method = 'GET' },
                @{ Method = 'POST' },
                @{ Method = 'PUT' },
                @{ Method = 'PATCH' },
                @{ Method = 'DELETE' }
            ) {
                param($Method)

                Invoke-CFRestMethod -Method $Method -Uri 'https://api.cloudflare.com/client/v4/zones'
                Assert-MockCalled Invoke-RestMethod -ParameterFilter { $Method -eq $Method } -Times 1 -Exactly
            }
            It 'should successfully invoke the method with valid parameters' {
                $uri = 'https://api.cloudflare.com/client/v4/zones'
                Invoke-CFRestMethod -Method 'GET' -Uri $uri
                Assert-MockCalled Invoke-RestMethod -ParameterFilter { $Uri -eq $uri } -Times 1 -Exactly
            }
        }
        Context 'Error' {
            It 'should throw an error if Cloudflare session is not found' {
                $ZoneName = 'example.com'
                $script:cfSession = $null
                { Invoke-CFRestMethod -ZoneName $ZoneName } | Should -Throw
            }
        }
        AfterAll {
            $script:cfSession | Remove-Variable
        }
    }
}