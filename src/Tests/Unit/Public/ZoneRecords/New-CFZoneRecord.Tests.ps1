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
    Describe 'New-CFZoneRecord Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            # Mock the dependent cmdlets and variables
            Mock Invoke-CFRestMethod { return @{ result = @{'id' = 'new_record_id' } } }
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $Script:cfZoneLookupTable = @{'example.com' = '23456' }
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        }
        Context 'Error' {
            It 'should throw an error if required parameters are missing' {
                { New-CFZoneRecord -Content '192.168.1.1' -Name 'example.com' -Type 'A' -TTL 3600 -Proxied $true } | Should -Throw
            }
            It 'should throw an error if dynamic param used incorrectly' {
                { New-CFZoneRecord -Priority 100 -Content '192.168.1.1' -Name 'example.com' -Type 'A' -TTL 3600 -Proxied $true } | Should -Throw
            }
        }
        Context 'Success' {
            It 'creates a new A record successfully' {
                { New-CFZoneRecord -ZoneName 'example.com' -Type TXT  -Content 'Foo' -Name 'Bar' } | Should -Not -Throw
            }
            It 'creates a new MX record successfully' {
                { New-CFZoneRecord -ZoneName 'example.com' -Content 'mail.example.com' -Name 'example.com' -Type 'MX' -TTL 3600 -Proxied $false -Priority 10 } | Should -Not -Throw
            }
            It 'uses ZoneName to lookup ZoneId' {
                New-CFZoneRecord -ZoneName 'example.com' -Content '192.168.1.1' -Name 'example.com' -Type 'A' -TTL 3600 -Proxied $true
                Assert-MockCalled Invoke-CFRestMethod -ParameterFilter { $Uri -eq "$script:cfBaseApiUrl/zones/23456/dns_records" }
            }
            It 'returns objects of type Cloudflare.ZoneRecord' {
                $result = New-CFZoneRecord -ZoneName 'example.com' -Type TXT  -Content 'Foo' -Name 'Bar'
                $result.PSObject.TypeNames[0] | Should -BeExactly 'Cloudflare.ZoneRecord'
            }
        }
        AfterAll {
            $script:cfSession | Remove-Variable
        }
    }
}