#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'pwshCloudflare'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'pwshCloudflare' {
    Describe 'Remove-CFD1Query Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            Mock Invoke-CFRestMethod { return @{ uuid = 'db123' } }
            Mock Find-CFD1Database { return @{ uuid = 'db123' } }
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $script:cfAccountLookupTable = @{'myAccount' = '12345' }
        }
        Context 'Error' {
            It 'should throw an error if required parameters are missing' {
                # Assuming AccountId or AccountName is required
                { Remove-CFD1Database -Name 'myDb' } | Should -Throw
            }
        }
        Context 'Success' {
            It 'should successfully delete the database with AccountName and Database Name' {
                Remove-CFD1Database -AccountName 'myAccount' -Name 'myDb'

                Assert-MockCalled Invoke-CFRestMethod -Times 1 -Exactly
                Assert-MockCalled Find-CFD1Database -Times 1 -Exactly
            }

            It 'should handle deletion with AccountId and Database Id' {
                Remove-CFD1Database -AccountId '12345' -Id 'db123'

                Assert-MockCalled Invoke-CFRestMethod -Times 1 -Exactly
                Assert-MockCalled Find-CFD1Database -Times 0 -Exactly # Since direct IDs are used
            }
        }
    }
}