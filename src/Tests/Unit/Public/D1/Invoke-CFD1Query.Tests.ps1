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
    Describe 'Invoke-CFD1Query Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            Mock Invoke-CFRestMethod
            Mock Find-CFD1Database
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $script:cfAccountLookupTable = @{'myAccount' = '12345' }
        }
        Context 'Error' {
            It 'should throw an error if required parameters are missing' {
                # Assuming AccountId or AccountName is required
                { Invoke-CFD1Query -Query 'SELECT * FROM users;' -Name 'myDb' } | Should -Throw
            }
        }
        # Context 'Success' {
        # }
    }
}