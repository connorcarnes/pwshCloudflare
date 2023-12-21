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
    Describe 'Get-CFD1Database Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            $script:cfAccountLookupTable = @{'myAccount' = '12345' }
            Mock Invoke-CFRestMethod { return [PSCustomObject]@{ result = [PSCustomObject]@{ DatabaseName = 'myDb' } } }
            Mock Find-CFD1Database { return [PSCustomObject]@{ result = [PSCustomObject]@{ DatabaseName = 'myDb' } } }
        }
        Context 'Error' {
            It 'should throw if account name and id are both provided' {
                { Get-CFD1Database -AccountName 'myAccount' -AccountId '12345' -Name 'myDb' } | Should -Throw
            }
            It 'should throw if neither account name nor id are provided' {
                { Get-CFD1Database -Name 'myDb' } | Should -Throw
            }
            It 'should throw if database name and id are both provided' {
                { Get-CFD1Database -AccountName 'myAccount' -Name 'myDb' -Id 'db123' } | Should -Throw
            }
        }
        Context 'Success' {
            It 'should list all databases if name or id are not provided' {
                $Result = Get-CFD1Database -AccountName 'myAccount'
                $Result.DatabaseName | Should -Be 'myDb'
            }
            It 'should get database by name' {
                $Result = Get-CFD1Database -AccountName 'myAccount' -Name 'myDb'
                $Result.DatabaseName | Should -Be 'myDb'
            }
            It 'should get database by id' {
                $Result = Get-CFD1Database -AccountName 'myAccount' -Id 'db123'
                $Result.DatabaseName | Should -Be 'myDb'
            }
            It 'returns objects of type Cloudflare.D1Database' {
                $Result = Get-CFD1Database -AccountName 'myAccount' -Name 'myDb'
                $Result.PSObject.TypeNames[0] | Should -BeExactly 'Cloudflare.D1Database'
            }
        }
    }
}