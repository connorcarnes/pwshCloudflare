InModuleScope 'pwshCloudflare' {
    Describe 'Set-CFZoneRecord Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            $script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
            $script:cfZoneLookupTable = @{ 'example.com' = '12345' }
            Mock Invoke-CFRestMethod { return @{ result = @{'id' = 'updated_record_id' } } }
            $script:cfSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        }
        # Context 'Error Handling' {
        # }
        Context 'Success' {
            It 'Calls Invoke-CFRestMethod with correct parameters for ZoneName' {
                Set-CFZoneRecord -ZoneName 'example.com' -RecordId '123abc456abc' -Content 'UpdatedContent'
                Assert-MockCalled Invoke-CFRestMethod -ParameterFilter {
                    $Uri -eq "$script:cfBaseApiUrl/zones/12345/dns_records/123abc456abc" -and
                    $Method -eq 'PATCH' -and
                    $Body -like '*UpdatedContent*'
                }
            }
            It 'Calls Invoke-CFRestMethod with correct parameters for ZoneID' {
                Set-CFZoneRecord -ZoneId '12345' -RecordId '123abc456abc' -Content 'UpdatedContent'
                Assert-MockCalled Invoke-CFRestMethod -ParameterFilter {
                    $Uri -eq "$script:cfBaseApiUrl/zones/12345/dns_records/123abc456abc" -and
                    $Method -eq 'PATCH' -and
                    $Body -like '*UpdatedContent*'
                }
            }
            It 'Returns objects of type Cloudflare.ZoneRecord' {
                $result = Set-CFZoneRecord -ZoneName 'example.com' -RecordId '123abc456abc' -Content 'UpdatedContent'
                $result.PSObject.TypeNames -contains 'Cloudflare.ZoneRecord' | Should -Be $true
            }
        }
        AfterAll {
            $script:cfSession | Remove-Variable
        }
    }
}
