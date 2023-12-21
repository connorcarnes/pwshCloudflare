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
    Describe 'New-CFD1Database Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            Mock Invoke-CFRestMethod { return [PSCustomObject]@{ result = [PSCustomObject]@{ DatabaseName = 'myDb' } } }
        }
        Context 'Error' {
            It 'should throw an error if required parameters are missing' {
                { New-CFD1Database -Name 'myDb' } | Should -Throw
            }
        }
        Context 'Success' {
            It 'should successfully create a database with AccountName' {
                $Result = New-CFD1Database -AccountName 'myAccount' -Name 'myDb'
                $Result.DatabaseName | Should -Be 'myDb'
                Assert-MockCalled Invoke-CFRestMethod -Times 1 -Exactly
            }

            It 'should successfully create a database with AccountId' {
                $Result = New-CFD1Database -AccountId '12345' -Name 'myDb'
                $Result.DatabaseName | Should -Be 'myDb'
                Assert-MockCalled Invoke-CFRestMethod -Times 1 -Exactly
            }
        }
    }
}