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
    Describe 'Get-CFZoneRecord Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            Mock Invoke-CFRestMethod { return @{ result = @(@{ RecordId = '12345'; ZoneName = 'example.com' }) } }
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $Script:cfZoneLookupTable = @{'example.com' = '23456' }
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        }
        # Context 'Error' {
        # }
        Context 'Success' {
            It 'Calls Invoke-CFRestMethod with correct parameters for ZoneName' {
                Get-CFZoneRecord -ZoneName 'example.com'
                Assert-MockCalled Invoke-CFRestMethod -Exactly 1 -Scope It -ParameterFilter {
                    $Uri -eq 'https://api.cloudflare.com/client/v4/zones/23456/dns_records' -and
                    $Method -eq 'GET'
                }
            }
            It 'Calls Invoke-CFRestMethod with correct parameters for ZoneID' {
                Get-CFZoneRecord -ZoneID '23456'
                Assert-MockCalled Invoke-CFRestMethod -Exactly 1 -Scope It -ParameterFilter {
                    $Uri -eq 'https://api.cloudflare.com/client/v4/zones/23456/dns_records' -and
                    $Method -eq 'GET'
                }
            }
            It 'Returns objects of type Cloudflare.ZoneRecord' {
                $result = Get-CFZoneRecord -ZoneName 'example.com'
                $result.PSObject.TypeNames[0] | Should -BeExactly 'Cloudflare.ZoneRecord'
            }
        }
        AfterAll {
            $script:cfSession | Remove-Variable
        }
    }
}