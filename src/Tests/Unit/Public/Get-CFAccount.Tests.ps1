# Set working directory and force remove/import module
Set-Location -Path $PSScriptRoot
$ModuleName = 'pwshCloudflare'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force

InModuleScope 'pwshCloudflare' {
    Describe 'Get-CFAccount Function Tests' -Tag Unit {
        BeforeAll {
            # Set variables and load mock data required for each test
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            . $PSScriptRoot/Get-MockApiResponse.ps1
            $mockResponse = Get-MockApiResponse
        }
        Context 'Error' {
            It 'Should throw if name not found' {
                Mock Invoke-CFRestMethod {
                    return [PSCustomObject]@{ result = $null }
                }
                { Get-CFAccount -Name 'nonExistingAccount' } | Should -Throw
            }
        }
        Context 'Success' {
            It 'Should get resource by name' {
                Mock Invoke-CFRestMethod {
                    return @{ result = @($mockResponse.result[0]) }
                }
                $Result = Get-CFAccount -Name 'resourceOne'
                $Result.AccountName | Should -Be 'resourceOne'
                $Result.Name | Should -Be 'resourceOne'
            }
            It 'Should get resource by id' {
                Mock Invoke-CFRestMethod {
                    return @{ result = @($mockResponse.result[0]) }
                }
                $Result = Get-CFAccount -Id '1'
                $Result.AccountId | Should -Be '1'
                $Result.Id | Should -Be '1'
            }
            It 'Should get all resources' {
                Mock Invoke-CFRestMethod {
                    return $mockResponse
                }
                $Result = Get-CFAccount
                $Result.AccountName | Should -Be @('resourceOne', 'resourceTwo', 'resourceThree')
            }
            It 'Should return correct resource type' {
                Mock Invoke-CFRestMethod {
                    return $mockResponse
                }
                $Result = Get-CFAccount
                foreach ($Item in $Result) {
                    $Item.PSObject.TypeNames[0] | Should -BeExactly 'Cloudflare.Account'
                }
            }
        }
    }
}
