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
    Describe 'Set-CloudflareSession Function Tests' -Tag 'Unit' {
        BeforeAll {
            Mock Invoke-CFRestMethod { return @{ success = $true } }
            Mock Get-CFZone { return @{ result = @(@{ Name = 'TestZone'; Id = '12345' }) } }
            Mock Test-CloudflareSession { return @{ Session = 'MockedSessionObject' } }
            Mock Export-Clixml { return $null }
            Mock Import-Clixml { return @{ Email = 'user@example.com'; ApiKey = 'API_KEY'; ApiToken = 'API_TOKEN' } }
            Mock Test-Path { return $true }
            Mock Register-CFArgumentCompleter { return $true }
            $script:cfConfigPath = 'path\to\config.xml'
        }
        Context 'Parameter Set: SessionOnly' {
            It 'Configures session with Email and ApiKey' {
                { Set-CloudflareSession -Email 'user@example.com' -ApiKey 'API_KEY' } | Should -Not -Throw
            }

            It 'Configures session with ApiToken' {
                { Set-CloudflareSession -ApiToken 'API_TOKEN' } | Should -Not -Throw
            }
        }
        Context 'Parameter Set: SaveToFile' {
            It 'Saves session data to file' {
                { Set-CloudflareSession -Email 'user@example.com' -ApiKey 'API_KEY' -SaveToFile } | Should -Not -Throw
                Assert-MockCalled Export-Clixml -Exactly 1 -Scope It
            }

            It 'Handles LoadOnImport flag' {
                { Set-CloudflareSession -Email 'user@example.com' -ApiKey 'API_KEY' -SaveToFile -LoadOnImport:$true } | Should -Not -Throw
                Assert-MockCalled Export-Clixml -Exactly 1 -Scope It
            }
        }
        Context 'Parameter Set: ImportFromFile' {
            It 'Imports session data from file' {
                { Set-CloudflareSession -ImportFromFile } | Should -Not -Throw
                Assert-MockCalled Import-Clixml -Exactly 1 -Scope It
            }

            It 'Throws error if file does not exist' {
                Mock Test-Path { return $false }
                { Set-CloudflareSession -ImportFromFile } | Should -Throw
            }
        }
        Context 'Error Handling' {
            It 'Throws error if required parameters are missing' {
                { Set-CloudflareSession } | Should -Throw
            }
        }
    }
}
