# this psm1 is for local testing and development use only

# dot source the parent import for local development variables
. $PSScriptRoot\Imports.ps1

# discover all ps1 file(s) in Public and Private paths
$itemSplat = @{
    Filter      = '*.ps1'
    Recurse     = $true
    ErrorAction = 'Stop'
}
try {
    $public = @(Get-ChildItem -Path "$PSScriptRoot\Public" @itemSplat)
    $private = @(Get-ChildItem -Path "$PSScriptRoot\Private" @itemSplat)
}
catch {
    Write-Error $_
    throw 'Unable to get get file information from Public & Private src.'
}

# dot source all .ps1 file(s) found
foreach ($file in @($public + $private)) {
    try {
        . $file.FullName
    }
    catch {
        throw "Unable to dot source [$($file.FullName)]"

    }
}

# export all public functions
Export-ModuleMember -Function $public.Basename

# Load all types
$Types = Get-ChildItem -Path "$PSScriptRoot\Types" -Filter '*.ps1xml'
foreach ($Type in $Types) {
    Update-TypeData -PrependPath $Type.FullName
}

$Path = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
$cfFolder = "$Path\.pwshCloudflare"
$Script:cfConfigPath = "$cfFolder\config.xml"
$Script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
$Script:cfApiSchemaUrl = 'https://developers.cloudflare.com/schema'

if (-not (Test-Path $cfFolder)) {
    Write-Verbose "Creating Cloudflare folder at $cfFolder"
    New-Item -Path $cfFolder -ItemType Directory -Force
}

if (Test-Path $cfConfigPath) {
    Write-Verbose "Loading Cloudflare session from $cfConfigPath"
    $SavedConfig = Import-Clixml -Path $cfConfigPath
    if ($SavedConfig.LoadOnImport) {
        Set-CloudflareSession -ImportFromFile
    }
}

if (-not $Script:cfSession) {
    Write-Warning 'Cloudflare session not found. Use Set-CloudflareSession to create a session.'
}