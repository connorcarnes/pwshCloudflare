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
    Describe 'Get-CFAccount Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $script:cfAccountLookupTable = @{'myAccount' = '12345' }
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            Mock Invoke-CFRestMethod { return [PSCustomObject]@{ result = [PSCustomObject]@{ AccountName = 'myAcct' } } }
        }
        # Context 'Error' {
        # }
        Context 'Success' {
            It 'Should get account by name' {
                $Result = Get-CFAccount -AccountName 'myAcct'
                $Result.AccountName | Should -Be 'myAcct'
            }
            It 'Should get account by id' {
                $Result = Get-CFAccount -AccountId '12345'
                $Result.AccountName | Should -Be 'myAcct'
            }
            It 'Should get all accounts' {
                $Result = Get-CFAccount
                $Result.AccountName | Should -Be 'myAcct'
            }
            It 'Should return object of type Cloudflare.Account' {
                $Result = Get-CFAccount
                $result.PSObject.TypeNames[0] | Should -BeExactly 'Cloudflare.Account'
            }
        }
    }
}