# This is a locally sourced Imports file for local development.
# It can be imported by the psm1 in local development to add script level variables.
# It will merged in the build process. This is for local development only.

# region script variables
# $script:resourcePath = "$PSScriptRoot\Resources"
$Path = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
$cfFolder = "$Path\.pwshCloudflare"
$Script:cfConfigPath = "$cfFolder\config.xml"
$Script:cfBaseApiUrl = 'https://api.cloudflare.com/client/v4'
$Script:cfApiSchemaUrl = 'https://developers.cloudflare.com/schema'