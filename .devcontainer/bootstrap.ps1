# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.psresourceget/install-psresource?view=powershellget-3.x
# https://devblogs.microsoft.com/powershell/psresourceget-is-generally-available/
# https://github.com/PowerShell/PSResourceGet
# https://hub.docker.com/_/microsoft-powershell
# https://devblogs.microsoft.com/powershell/powershellget-in-powershell-7-4-updates/
# http://dahlbyk.github.io/posh-git/
# https://code.visualstudio.com/remote/advancedcontainers/change-default-source-mount
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.psresourceget/?view=powershellget-3.x
# https://code.visualstudio.com/docs/devcontainers/containers#_container-specific-settings
$ErrorActionPreference = 'Stop'
Install-PSResource -TrustRepository -Scope AllUsers -RequiredResource  @{
    'Microsoft.PowerShell.PSResourceGet' = @{
        version    = '1.0.2'
        repository = 'PSGallery'
    }
    'Pester'                             = @{
        version    = '5.4.0'
        repository = 'PSGallery'
    }
    'InvokeBuild'                        = @{
        version    = '5.10.2'
        repository = 'PSGallery'
    }
    'PSScriptAnalyzer'                   = @{
        version    = '1.21.0'
        repository = 'PSGallery'
    }
    'platyPS'                            = @{
        version    = '0.12.0'
        repository = 'PSGallery'
    }
    'posh-git'                           = @{
        version    = '1.1.0'
        repository = 'PSGallery'
    }
}

