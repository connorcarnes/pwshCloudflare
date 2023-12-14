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
    Describe 'Remove-CFZoneRecord Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $Script:cfZoneLookupTable = @{'example.com' = '12345' }
            Mock Invoke-CFRestMethod { return @{ result = @{'id' = '12345' } } }
        }
        BeforeEach {
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        }
        Context 'Error' {
            It 'should throw an error if Cloudflare session is not found' {
                $ZoneName = 'example.com'
                $script:cfSession = $null
                { Remove-CFZoneRecord -ZoneName $ZoneName -RecordId '12345' } | Should -Throw
            }
        }
        Context 'Success' {
            It 'Calls Invoke-CFRestMethod with correct parameters for ZoneName' {
                Remove-CFZoneRecord -ZoneName 'example.com' -RecordId '12345'
                Assert-MockCalled Invoke-CFRestMethod -Exactly 1 -Scope It -ParameterFilter {
                    $Uri -eq 'https://api.cloudflare.com/client/v4/zones/12345/dns_records/12345' -and
                    $Method -eq 'DELETE'
                }
            }
            It 'Calls Invoke-CFRestMethod with correct parameters for ZoneID' {
                Remove-CFZoneRecord -ZoneID '12345' -RecordId '12345'
                Assert-MockCalled Invoke-CFRestMethod -Exactly 1 -Scope It -ParameterFilter {
                    $Uri -eq 'https://api.cloudflare.com/client/v4/zones/12345/dns_records/12345' -and
                    $Method -eq 'DELETE'
                }
            }
            It 'Returns null' {
                $result = Remove-CFZoneRecord -ZoneName 'example.com' -RecordId '12345'
                $result | Should -BeExactly $null
            }
        }
        AfterAll {
            $script:cfSession | Remove-Variable
        }
    }
}