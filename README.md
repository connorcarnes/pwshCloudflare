# pwshCloudflare

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-purple.svg)](https://github.com/PowerShell/PowerShell) ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE)

[license-badge]: https://img.shields.io/github/license/connorcarnes/pwshCloudflare

| Branch | Windows - PowerShell | Windows - pwsh | Linux | MacOS |
| --- | --- | --- | --- | --- |
| main   | ![Build Status Windows PowerShell Main](https://github.com/connorcarnes/pwshCloudflare/actions/workflows/wf_WindowsPowerShell.yml/badge.svg?branch=main) | ![Build Status Windows pwsh Main](https://github.com/connorcarnes/pwshCloudflare/actions/workflows/wf_Windows.yml/badge.svg?branch=main) | ![Build Status Linux Main](https://github.com/connorcarnes/pwshCloudflare/actions/workflows/wf_Linux.yml/badge.svg?branch=main) | ![Build Status MacOS dev](https://github.com/connorcarnes/pwshCloudflare/actions/workflows/wf_MacOS.yml/badge.svg?branch=main) |
| dev    | ![Build Status Windows PowerShell dev](https://github.com/connorcarnes/pwshCloudflare/actions/workflows/wf_WindowsPowerShell.yml/badge.svg?branch=dev)   | ![Build Status Windows pwsh dev](https://github.com/connorcarnes/pwshCloudflare/actions/workflows/wf_Windows.yml/badge.svg?branch=dev)   | ![Build Status Linux dev](https://github.com/connorcarnes/pwshCloudflare/actions/workflows/wf_Linux.yml/badge.svg?branch=dev)   | ![Build Status MacOS dev](https://github.com/connorcarnes/pwshCloudflare/actions/workflows/wf_MacOS.yml/badge.svg?branch=dev)  |

## Description

PowerShell module for the [Cloudflare Client API v4](https://developers.cloudflare.com/api/). See similar projects [python-cloudflare](https://github.com/cloudflare/python-cloudflare) and [cloudflare-go](https://github.com/cloudflare/cloudflare-go) as well as [Cloudflare products](https://developers.cloudflare.com/products/)

## Functions

| Function            | ApiOperation                                                                                                   |
| ------------------- | -------------------------------------------------------------------------------------------------------------- |
| [Get-CFAccount](docs/Get-CFAccount.md)             | [Account Details](https://developers.cloudflare.com/api/operations/accounts-account-details)                   |
| [Get-CFD1Database](docs/Get-CFD1Database.md)       | [Get D1 Database](https://developers.cloudflare.com/api/operations/cloudflare-d1-get-database)                 |
| [Get-CFZone](docs/Get-CFZone.md)                   | [List Zones](https://developers.cloudflare.com/api/operations/zones-get)                                       |
| [Get-CFZoneRecord](docs/Get-CFZoneRecord.md)       | [List DNS Records](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records)   |
| [Invoke-CFD1Query](docs/Invoke-CFD1Query.md)       | [Query D1 Database](https://developers.cloudflare.com/api/operations/cloudflare-d1-query-database)             |
| [New-CFD1Database](docs/New-CFD1Database.md)       | [Create D1 Database](https://developers.cloudflare.com/api/operations/cloudflare-d1-create-database)           |
| [New-CFZoneRecord](docs/New-CFZoneRecord.md)       | [Create DNS Record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-create-dns-record) |
| [Remove-CFD1Database](docs/New-CFD1Database.md)    | [Delete D1 Database](https://developers.cloudflare.com/api/operations/cloudflare-d1-delete-database)           |
| [Remove-CFZoneRecord](docs/Remove-CFZoneRecord.md) | [Delete DNS Record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-delete-dns-record) |
| [Set-CFZoneRecord](docs/Set-CFZoneRecord.md)       | [Patch DNS Record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-patch-dns-record)   |

## Getting Started

### Installation

pwshCloudflare will be published to PSGallery in the future. For now clone this repo and import the module.

```PowerShell
git clone https://github.com/connorcarnes/pwshCloudflare
Import-Module '.pwshCloudflare/src/pwshCloudflare/pwshCloudflare.psd1'
```

### Authentication

`Set-CloudflareSession` creates a `[Microsoft.PowerShell.Commands.WebRequestSession]` object with the appropriate headers, saves it to `$Script:cfSession`, and uses it make subsequent API calls. By default `Set-CloudflareSession` only configures authentication for the current session. Use the `-SaveToFile` and `-LoadOnImport` parameters to save your configuration and have it load on module import. **Your credentials will be stored in plaintext**. Examples are included in the [Quickstart section below](#quick-start).

You can use API token authentication, API key authentication, or both. See [Get Started - Cloudflare Fundamentals](https://developers.cloudflare.com/fundamentals/api/get-started/) for details. `Set-CloudflareSession` will validate the provided credentials with `Test-CloudflareSession`.

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
# Your credentials will be stored in plaintext. Default config file location:
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

## Contributors

- [Connor Carnes](https://github.com/connorcarnes)
- [Kenneth Carnes](https://github.com/kennethcarnes)