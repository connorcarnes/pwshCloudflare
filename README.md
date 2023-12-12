# pwshCloudflare

## Synopsis

PowerShell module for interacting with the Cloudflare API.

## Description

PowerShell module for interacting with the Cloudflare API.

## Functions

| Function            | ApiOperation                                                                                                   |
| ------------------- | -------------------------------------------------------------------------------------------------------------- |
| Get-CFZone          | [List Zones](https://developers.cloudflare.com/api/operations/zones-get)                                       |
| Get-CFZoneRecord    | [List DNS Records](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records)   |
| New-CFZoneRecord    | [Create DNS Record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-create-dns-record) |
| Remove-CFZoneRecord | [Delete DNS Record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-delete-dns-record) |
| Set-CFZoneRecord    | [Patch DNS Record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-patch-dns-record)   |

## Why

The existing Cloudflare modules in the PSGallery are limited in scope. This project aims to support as many [Cloudflare products](https://developers.cloudflare.com/products/) as possible including R2, D1, Pages, Workers, Workers KV, Workers AI, Images, Stream, Access, Tunnel, Durable Objects, Queues, etc.

## Getting Started

### Installation

pwshCloudflare will be published to PSGallery in the future. For now clone this repo and import the module.

```PowerShell
git clone https://github.com/connorcarnes/pwshCloudflare
Import-Module '.pwshCloudflare/src/pwshCloudflare/pwshCloudflare.psd1'
```

### Authentication

API token and API Key authentication are supported. See [Get Started - Cloudflare Fundamentals](https://developers.cloudflare.com/fundamentals/api/get-started/) for details.

`Set-CloudflareSession` handles authentication by creating a `[Microsoft.PowerShell.Commands.WebRequestSession]` object with the appropriate headers. The object is saved to `$Script:cfSession` and used to make subsequent API calls.

You can store the configuration in a file with the `-SaveToFile` parameter. If you want the configuration to load on module import, use the `-LoadOnImport` parameter. **Your credentials will be stored in the file in plaintext**. See examples below.

### Quick start

#### Authenticate for the current PowerShell session

```PowerShell
$Splat = @{
    Email    = "user@example.com"
    ApiKey   = "API_KEY"
    ApiToken = "API_TOKEN"
}
Set-CloudflareSession @Splat
```

#### Save configuration to a file and have it load on module import

```PowerShell
# Your credentials will be saved to the file in plaintext. Default config file location:
# $Folder = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
# $FilePath = "$Folder\.pwshCloudflare\config.xml"
$Splat = @{
    Email        = "user@example.com"
    ApiKey       = "API_KEY"
    ApiToken     = "API_TOKEN"
    SaveToFile   = $true
    LoadOnImport = $true
}
Set-CloudflareSession @Splat
```

#### List all zones

```powershell
Get-CfZone
```

#### Get DNS records by zone name

```PowerShell
Get-CFZoneRecord -ZoneName 'example.com'
```

#### Get DNS records by zone id

```PowerShell
$ZoneName = 'example.com'
$Zone = Get-CfZone | Where-Object {$_.Name -eq $ZoneName}
Get-CFZoneRecord -ZoneId $Zone.id
```
