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
    Describe 'Get-CFZone Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            Mock Invoke-CFRestMethod { return @{ result = @(@{ Name = 'TestZone'; Id = '12345' }) } }
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
        }
        BeforeEach {
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        }
        Context 'Error' {
            It 'should throw an error if Cloudflare session is not found' {
                $ZoneName = 'example.com'
                $script:cfSession = $null
                { Get-CFZone -ZoneName $ZoneName } | Should -Throw
            }
        }
        Context 'Success' {
            It 'Calls Invoke-CFRestMethod with correct parameters for ZoneName' {
                Get-CFZone -ZoneName 'example.com'
                Assert-MockCalled Invoke-CFRestMethod -Exactly 1 -Scope It -ParameterFilter {
                    $Uri -eq 'https://api.cloudflare.com/client/v4/zones?name=example.com' -and
                    $Method -eq 'GET'
                }
            }
            It 'Calls Invoke-CFRestMethod with correct parameters for ZoneID' {
                Get-CFZone -ZoneID '12345'
                Assert-MockCalled Invoke-CFRestMethod -Exactly 1 -Scope It -ParameterFilter {
                    $Uri -eq 'https://api.cloudflare.com/client/v4/zones?id=12345' -and
                    $Method -eq 'GET'
                }
            }
            It 'Returns objects of type Cloudflare.Zone' {
                $result = Get-CFZone -ZoneName 'example.com'
                $result.PSObject.TypeNames[0] | Should -BeExactly 'Cloudflare.Zone'
            }
        }
        AfterAll {
            $script:cfSession | Remove-Variable
        }
    }
}