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
        }
        Context 'Error' {
            It 'should throw an error if Cloudflare session is not found' {
                $ZoneName = 'example.com'
                $script:cfSession = $null
                { Get-CFZone -ZoneName $ZoneName } | Should -Throw 'Cloudflare session not found. Use Set-CloudflareSession to create a session.'
            }
        }
        Context 'Success' {
            BeforeEach {
                Mock -CommandName Invoke-CFRestMethod -MockWith {
                    [PSCustomObject]@{
                        result = 'Zone details'
                    }
                }
            }
        }
    }
}